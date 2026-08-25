#!/usr/bin/env python3
"""Discover cross-insights inputs without reading or printing message bodies."""

from __future__ import annotations

import argparse
import json
import os
import sqlite3
from datetime import datetime, timedelta, timezone
from pathlib import Path


def file_record(path: Path) -> dict[str, object]:
    stat = path.stat()
    return {
        "ref": path.name,
        "modified_at": datetime.fromtimestamp(stat.st_mtime, timezone.utc).isoformat(),
        "size_bytes": stat.st_size,
    }


def recent_files(roots: list[Path], pattern: str, cutoff: float) -> list[Path]:
    found: list[Path] = []
    for root in roots:
        if not root.exists():
            continue
        for path in root.rglob(pattern):
            try:
                if path.is_file() and path.stat().st_mtime >= cutoff:
                    found.append(path)
            except OSError:
                continue
    return sorted(found, key=lambda path: path.stat().st_mtime, reverse=True)


def parse_time(value: str) -> float | None:
    try:
        return datetime.fromisoformat(value.replace("Z", "+00:00")).timestamp()
    except (TypeError, ValueError):
        return None


def indexed_codex_sessions(codex_home: Path, cutoff: float) -> list[Path]:
    index_path = codex_home / "session_index.jsonl"
    if not index_path.exists():
        return []

    indexed: dict[str, float] = {}
    for line in index_path.read_text(encoding="utf-8").splitlines():
        try:
            record = json.loads(line)
            session_id = record["id"]
            updated_at = parse_time(record["updated_at"])
        except (json.JSONDecodeError, KeyError, TypeError):
            continue
        if updated_at is not None and updated_at >= cutoff:
            indexed[session_id] = max(updated_at, indexed.get(session_id, 0.0))

    by_id: dict[str, Path] = {}
    for root in [codex_home / "sessions", codex_home / "archived_sessions"]:
        if not root.exists():
            continue
        for path in root.rglob("*.jsonl"):
            for session_id in indexed:
                if session_id in path.name:
                    by_id[session_id] = path
                    break

    ordered_ids = sorted(indexed, key=indexed.get, reverse=True)
    return [by_id[session_id] for session_id in ordered_ids if session_id in by_id]


def database_codex_sessions(codex_home: Path, cutoff: float) -> list[Path]:
    db_path = codex_home / "state_5.sqlite"
    if not db_path.is_file():
        return []

    connection: sqlite3.Connection | None = None
    try:
        connection = sqlite3.connect(f"file:{db_path}?mode=ro", uri=True)
        rows = connection.execute(
            """
            SELECT rollout_path
            FROM threads
            WHERE updated_at >= ?
              AND source NOT LIKE '%subagent%'
            ORDER BY updated_at DESC
            """,
            (int(cutoff),),
        ).fetchall()
    except sqlite3.Error:
        return []
    finally:
        if connection is not None:
            connection.close()

    return [Path(row[0]) for row in rows if row[0] and Path(row[0]).is_file()]


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--days", type=int, default=30)
    parser.add_argument("--max-codex", type=int, default=50)
    args = parser.parse_args()

    if args.days < 1 or args.max_codex < 1:
        parser.error("--days and --max-codex must be positive")

    home = Path.home()
    now = datetime.now(timezone.utc)
    cutoff = (now - timedelta(days=args.days)).timestamp()

    claude_reports = recent_files(
        [home / ".claude" / "usage-data"], "report*.html", cutoff
    )
    # report.html and its timestamped copy may be the same run. Keep the newest
    # report only; the analyzer can inspect older reports explicitly when needed.
    latest_claude = claude_reports[:1]

    codex_home = Path(os.environ.get("CODEX_HOME", home / ".codex"))
    codex_sessions = database_codex_sessions(codex_home, cutoff)
    selection_method = "state_db"
    if not codex_sessions:
        codex_sessions = indexed_codex_sessions(codex_home, cutoff)
        selection_method = "session_index"
    if not codex_sessions:
        codex_sessions = recent_files(
            [codex_home / "sessions", codex_home / "archived_sessions"],
            "*.jsonl",
            cutoff,
        )
        selection_method = "mtime_fallback"
    selected_codex = codex_sessions[: args.max_codex]

    result = {
        "generated_at": now.isoformat(),
        "window_days": args.days,
        "claude": {
            "status": "ready" if latest_claude else "missing",
            "reports": [file_record(path) for path in latest_claude],
        },
        "codex": {
            "status": "ready" if selected_codex else "missing",
            "selection_method": selection_method,
            "found_in_window": len(codex_sessions),
            "selected_count": len(selected_codex),
            "selected_bytes": sum(path.stat().st_size for path in selected_codex),
            "summary_first_count": sum(
                path.stat().st_size > 8 * 1024 * 1024 for path in selected_codex
            ),
            "requires_summary_count": sum(
                path.stat().st_size > 50 * 1024 * 1024 for path in selected_codex
            ),
            "sessions": [file_record(path) for path in selected_codex],
        },
    }
    print(json.dumps(result, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
