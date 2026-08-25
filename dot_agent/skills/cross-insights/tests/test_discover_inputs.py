import importlib.util
import sqlite3
import sys
import tempfile
import unittest
from pathlib import Path


MODULE_PATH = Path(__file__).parents[1] / "scripts" / "discover_inputs.py"
SPEC = importlib.util.spec_from_file_location("discover_inputs", MODULE_PATH)
assert SPEC and SPEC.loader
MODULE = importlib.util.module_from_spec(SPEC)
sys.modules[SPEC.name] = MODULE
SPEC.loader.exec_module(MODULE)


class DiscoverInputsTest(unittest.TestCase):
    def test_file_record_does_not_expose_absolute_path(self):
        with tempfile.TemporaryDirectory() as temp_dir:
            path = Path(temp_dir) / "rollout-id.jsonl"
            path.write_text("")
            record = MODULE.file_record(path)

        self.assertEqual(record["ref"], "rollout-id.jsonl")
        self.assertNotIn("path", record)

    def test_database_selection_includes_main_and_excludes_subagents(self):
        with tempfile.TemporaryDirectory() as temp_dir:
            codex_home = Path(temp_dir)
            main_rollout = codex_home / "main.jsonl"
            exec_rollout = codex_home / "exec.jsonl"
            child_rollout = codex_home / "child.jsonl"
            for path in (main_rollout, exec_rollout, child_rollout):
                path.write_text("")

            connection = sqlite3.connect(codex_home / "state_5.sqlite")
            connection.execute(
                "CREATE TABLE threads "
                "(rollout_path TEXT, updated_at INTEGER, source TEXT)"
            )
            connection.executemany(
                "INSERT INTO threads VALUES (?, ?, ?)",
                [
                    (str(main_rollout), 30, "vscode"),
                    (str(exec_rollout), 20, "exec"),
                    (str(child_rollout), 40, '{"subagent":{"depth":1}}'),
                ],
            )
            connection.commit()
            connection.close()

            selected = MODULE.database_codex_sessions(codex_home, cutoff=10)

        self.assertEqual(selected, [main_rollout, exec_rollout])


if __name__ == "__main__":
    unittest.main()
