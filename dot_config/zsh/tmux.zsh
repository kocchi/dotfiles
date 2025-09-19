# tmux関連の関数

# tmuxセッション管理関数
if command -v tmux >/dev/null 2>&1 && command -v fzf >/dev/null 2>&1; then
    # tmuxセッション選択削除
    function tkill() {
        local sessions session
        sessions=$(tmux list-sessions -F "#{session_name}" 2>/dev/null)
        
        if [ -z "$sessions" ]; then
            echo "アクティブなtmuxセッションがありません"
            return 1
        fi
        
        session=$(echo "$sessions" | fzf --prompt="Kill session: " --height=10 --border)
        
        if [ -n "$session" ]; then
            tmux kill-session -t "$session"
            echo "セッション '$session' を削除しました"
        else
            echo "キャンセルされました"
        fi
    }
    
    # tmuxセッション選択アタッチ
    function tattach() {
        local sessions session
        
        # 既にtmux内にいる場合の処理
        if [ -n "$TMUX" ]; then
            echo "既にtmuxセッション内にいます。セッションを切り替えますか？"
            sessions=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | grep -v "$(tmux display-message -p '#S')")
            
            if [ -z "$sessions" ]; then
                echo "他にアクティブなセッションがありません"
                return 1
            fi
            
            session=$(echo "$sessions" | fzf --prompt="Switch to session: " --height=10 --border)
            
            if [ -n "$session" ]; then
                tmux switch-client -t "$session"
            else
                echo "キャンセルされました"
            fi
        else
            # tmux外からの通常のアタッチ
            sessions=$(tmux list-sessions -F "#{session_name}" 2>/dev/null)
            
            if [ -z "$sessions" ]; then
                echo "アクティブなtmuxセッションがありません"
                return 1
            fi
            
            session=$(echo "$sessions" | fzf --prompt="Attach to session: " --height=10 --border)
            
            if [ -n "$session" ]; then
                tmux attach-session -t "$session"
            else
                echo "キャンセルされました"
            fi
        fi
    }
    
    # tmuxセッション一覧表示（詳細）
    function tlist() {
        if command -v tmux >/dev/null 2>&1; then
            tmux list-sessions 2>/dev/null || echo "アクティブなtmuxセッションがありません"
        else
            echo "tmuxがインストールされていません"
        fi
    }
    
    # 新しいtmuxセッション作成
    function tnew() {
        local session_name="$1"
        
        if [ -z "$session_name" ]; then
            echo -n "セッション名を入力してください: "
            read session_name
        fi
        
        if [ -z "$session_name" ]; then
            echo "セッション名が必要です"
            return 1
        fi
        
        # セッション名の重複チェック
        if tmux has-session -t "$session_name" 2>/dev/null; then
            echo "セッション '$session_name' は既に存在します"
            echo "アタッチしますか？ (y/N)"
            read -r response
            if [[ "$response" =~ ^[Yy]$ ]]; then
                if [ -n "$TMUX" ]; then
                    tmux switch-client -t "$session_name"
                else
                    tmux attach-session -t "$session_name"
                fi
            fi
            return 0
        fi
        
        # 新しいセッションを作成
        if [ -n "$TMUX" ]; then
            # tmux内からの場合は新しいセッションを作成してスイッチ
            tmux new-session -d -s "$session_name"
            tmux switch-client -t "$session_name"
        else
            # tmux外からの場合は作成してアタッチ
            tmux new-session -s "$session_name"
        fi
    }
    
    # tmuxセッション切り替え（tmux内専用）
    function tswitch() {
        if [ -z "$TMUX" ]; then
            echo "tmuxセッション内で実行してください"
            return 1
        fi
        
        local sessions session current_session
        current_session=$(tmux display-message -p '#S')
        sessions=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | grep -v "$current_session")
        
        if [ -z "$sessions" ]; then
            echo "他にアクティブなセッションがありません"
            return 1
        fi
        
        session=$(echo "$sessions" | fzf --prompt="Switch to session: " --height=10 --border)
        
        if [ -n "$session" ]; then
            tmux switch-client -t "$session"
        else
            echo "キャンセルされました"
        fi
    }
    
    # tmux統合管理コマンド - メインエントリーポイント
    function t() {
        local action="$1"
        
        case "$action" in
            ""|"menu"|"m")
                # メニュー表示
                echo "🐚 tmux管理メニュー"
                echo "=================="
                echo ""
                echo "📋 セッション操作:"
                echo "  t l, t list     - セッション一覧表示"
                echo "  t a, t attach   - セッション選択アタッチ/切り替え"
                echo "  t n, t new      - 新しいセッション作成"
                echo "  t s, t switch   - セッション切り替え (tmux内)"
                echo "  t k, t kill     - セッション選択削除"
                echo ""
                echo "🚀 クイック操作:"
                echo "  t               - このメニューを表示"
                echo "  t <name>        - セッション名で直接アタッチ/作成"
                echo ""
                echo "💡 使用例:"
                echo "  t work          # workセッションにアタッチ（なければ作成）"
                echo "  t a             # fzfでセッション選択"
                echo "  t n myproject   # myprojectセッションを作成"
                ;;
            "l"|"list")
                tlist
                ;;
            "a"|"attach")
                tattach
                ;;
            "n"|"new")
                shift
                tnew "$@"
                ;;
            "s"|"switch")
                tswitch
                ;;
            "k"|"kill")
                tkill
                ;;
            *)
                # セッション名として扱う（クイックアタッチ/作成）
                local session_name="$action"
                
                if [ -z "$session_name" ]; then
                    t menu
                    return 0
                fi
                
                # セッションが存在するかチェック
                if tmux has-session -t "$session_name" 2>/dev/null; then
                    echo "セッション '$session_name' にアタッチします"
                    if [ -n "$TMUX" ]; then
                        tmux switch-client -t "$session_name"
                    else
                        tmux attach-session -t "$session_name"
                    fi
                else
                    echo "セッション '$session_name' を作成します"
                    if [ -n "$TMUX" ]; then
                        tmux new-session -d -s "$session_name"
                        tmux switch-client -t "$session_name"
                    else
                        tmux new-session -s "$session_name"
                    fi
                fi
                ;;
        esac
    }
    
    # 補完関数
    function _t_completion() {
        local -a commands sessions
        commands=(
            'l:セッション一覧表示'
            'list:セッション一覧表示'
            'a:セッション選択アタッチ'
            'attach:セッション選択アタッチ'
            'n:新しいセッション作成'
            'new:新しいセッション作成'
            's:セッション切り替え'
            'switch:セッション切り替え'
            'k:セッション選択削除'
            'kill:セッション選択削除'
            'm:メニュー表示'
            'menu:メニュー表示'
        )
        
        # 既存のセッション名も補完候補に追加
        if command -v tmux >/dev/null 2>&1; then
            sessions=($(tmux list-sessions -F "#{session_name}" 2>/dev/null))
        fi
        
        _describe 'commands' commands
        _describe 'sessions' sessions
    }
    
    # zsh補完を登録
    if [[ -n ${ZSH_VERSION-} ]]; then
        compdef _t_completion t
    fi
fi
