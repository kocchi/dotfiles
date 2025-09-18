-- Neovimの設定ファイル (init.lua)
-- lazy.nvimを使用した設定

-- lazy.nvimのブートストラップ
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- 最新の安定版
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- 基本設定
vim.g.mapleader = " " -- スペースをリーダーキーに設定
vim.g.maplocalleader = " "

-- lazy.nvimでプラグインを管理
require("lazy").setup({
  -- カラースキーム
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme "catppuccin-mocha"
    end,
  },

  -- ファイルツリー
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      vim.keymap.set('n', '<leader>e', ':Neotree toggle<CR>', { noremap = true, silent = true })
    end,
  },

  -- ファズィファインダー
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.6",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
      vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
    end,
  },

  -- LSP設定
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "rust_analyzer", "pyright", "ts_ls" },
        automatic_installation = true,
      })
      
      -- 新しいNeovim 0.11の形式でLSPを設定
      vim.lsp.config.lua_ls = {
        cmd = { 'lua-language-server' },
        filetypes = { 'lua' },
        root_markers = { '.luarc.json', '.luarc.jsonc', '.luacheckrc', '.stylua.toml', 'stylua.toml', 'selene.toml', 'selene.yml' },
      }
      
      vim.lsp.config.rust_analyzer = {
        cmd = { 'rust-analyzer' },
        filetypes = { 'rust' },
        root_markers = { 'Cargo.toml', 'rust-project.json' },
      }
      
      vim.lsp.config.pyright = {
        cmd = { 'pyright-langserver', '--stdio' },
        filetypes = { 'python' },
        root_markers = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', 'Pipfile', 'pyrightconfig.json' },
      }
      
      vim.lsp.config.ts_ls = {
        cmd = { 'typescript-language-server', '--stdio' },
        filetypes = { 'javascript', 'javascriptreact', 'javascript.jsx', 'typescript', 'typescriptreact', 'typescript.tsx' },
        root_markers = { 'tsconfig.json', 'package.json', 'jsconfig.json', '.git' },
      }
    end,
  },

  -- 自動補完
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require'cmp'
      
      cmp.setup({
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        }, {
          { name = 'buffer' },
        })
      })
    end,
  },

  -- Treesitter (シンタックスハイライト)
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require'nvim-treesitter.configs'.setup {
        ensure_installed = { "lua", "vim", "vimdoc", "query", "rust", "python", "javascript", "typescript" },
        auto_install = true,
        highlight = {
          enable = true,
        },
        indent = {
          enable = true
        },
      }
    end,
  },

  -- Git統合
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require('gitsigns').setup()
    end,
  },

  -- ステータスライン
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require('lualine').setup({
        options = {
          theme = 'catppuccin'
        }
      })
    end,
  },

  -- Which-key (キーバインドヘルプ)
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    config = function()
      require("which-key").setup()
    end,
  },

  -- コメントアウト
  {
    "numToStr/Comment.nvim",
    config = function()
      require('Comment').setup()
    end,
  },

  -- インデントガイド
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
      require("ibl").setup()
    end,
  },
})

-- 基本設定
vim.opt.number = true          -- 行番号表示
vim.opt.relativenumber = true  -- 相対行番号
vim.opt.tabstop = 4           -- タブ幅
vim.opt.shiftwidth = 4        -- インデント幅
vim.opt.expandtab = true      -- タブをスペースに展開
vim.opt.smartindent = true    -- スマートインデント
vim.opt.wrap = false          -- 行の折り返し無効
vim.opt.swapfile = false      -- スワップファイル無効
vim.opt.backup = false        -- バックアップファイル無効
vim.opt.undodir = os.getenv("HOME") .. "/.local/share/nvim/undo"
vim.opt.undofile = true       -- アンドゥファイル有効
vim.opt.hlsearch = false      -- 検索ハイライト無効
vim.opt.incsearch = true      -- インクリメンタル検索
vim.opt.termguicolors = true  -- 24ビットカラー有効
vim.opt.scrolloff = 8         -- スクロールオフセット
vim.opt.signcolumn = "yes"    -- サインカラム常時表示
vim.opt.isfname:append("@-@") -- ファイル名の@を許可
vim.opt.updatetime = 50       -- 更新時間短縮
vim.opt.colorcolumn = "80"    -- 80文字ライン表示

-- クリップボード連携
vim.opt.clipboard = "unnamedplus"  -- システムクリップボードと連携

-- キーマッピング
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")  -- 選択行を下に移動
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")  -- 選択行を上に移動
vim.keymap.set("n", "J", "mzJ`z")             -- 行結合時にカーソル位置保持
vim.keymap.set("n", "<C-d>", "<C-d>zz")       -- 半ページ下移動時に中央配置
vim.keymap.set("n", "<C-u>", "<C-u>zz")       -- 半ページ上移動時に中央配置
vim.keymap.set("n", "n", "nzzzv")             -- 次の検索結果に移動時に中央配置
vim.keymap.set("n", "N", "Nzzzv")             -- 前の検索結果に移動時に中央配置

-- クリップボード関連のキーマッピング
vim.keymap.set("n", "<leader>y", "\"+y")      -- リーダー+y でクリップボードにコピー
vim.keymap.set("v", "<leader>y", "\"+y")      -- ビジュアルモードでもクリップボードにコピー
vim.keymap.set("n", "<leader>Y", "\"+Y")      -- 行全体をクリップボードにコピー
vim.keymap.set("n", "<leader>p", "\"+p")      -- クリップボードからペースト（カーソル後）
vim.keymap.set("n", "<leader>P", "\"+P")      -- クリップボードからペースト（カーソル前）

-- C言語コンパイル用のキーマッピング（元の設定を保持）
vim.keymap.set("n", "<F6>", function()
  vim.cmd("write")
  vim.cmd("!gcc % -o %.out && ./%.out")
end, { desc = "Compile and run C program" })
