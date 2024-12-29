return {
    'tpope/vim-fugitive',          -- GIT support

    { -- Allow to eveluate lua lines from buffer, and show result in buffer
        'bfredl/nvim-luadev',
        cmd = "Luadev",
    },

    { -- Color schema framework with live feedback
        'rktjmp/lush.nvim', lazy = true
    },

    { -- Simple Color schema framework
        'tjdevries/colorbuddy.nvim', lazy = true
    },

    { -- Run async tasks
        'stevearc/overseer.nvim',
        config = function(_, opts)
            require("overseer").setup()
        end,
    },

    { "nvim-tree/nvim-web-devicons", lazy = true },
    { 'echasnovski/mini.icons', version = '*' },

    { -- Color preview
        'norcalli/nvim-colorizer.lua',
        cmd = {"ColorizerAttachToBuffer", "ColorizerDetachFromBuffer", "ColorizerReloadAllBuffers", "ColorizerToggle"},
    },

    'Pocco81/HighStr.nvim', -- Allow to manually highlight something

    'windwp/nvim-projectconfig',  -- Per project settings

    -- Color schema's
    { "bluz71/vim-moonfly-colors", name = "moonfly", lazy = true, priority = 1000 },
    { "bluz71/vim-nightfly-colors", name = "nightfly", lazy = true, priority = 1000 },
    { "catppuccin/nvim", name = "catppuccin", priority = 1000, lazy = true },
    { "folke/tokyonight.nvim", lazy = true, priority = 1000, opts = {}, },
    { 'ray-x/aurora', lazy = true },
    { 'rebelot/kanagawa.nvim', lazy = true },
    { 'ribru17/bamboo.nvim', lazy = true },

    { -- Toggle various options
        'tummetott/unimpaired.nvim',
        config = function(_, opts)
            require('unimpaired').setup {
                -- add any options here or leave empty
            }
        end,
    },

    { -- file explorer ---------------------------------------------------------
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        cmd = "Neotree",
        dependencies = {
            'nvim-lua/plenary.nvim',
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
        },
        keys = {
            {
                "<leader>fe",
                function()
                    require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd() })
                end,
                desc = "Explorer NeoTree (cwd)",
            },
            { "<leader>e", "<leader>fe", desc = "Explorer NeoTree", remap = true },
            {
                "<leader>ge",
                function()
                    require("neo-tree.command").execute({ source = "git_status", toggle = true })
                end,
                desc = "Git explorer",
            },
            {
                "<leader>be",
                function()
                    require("neo-tree.command").execute({ source = "buffers", toggle = true })
                end,
                desc = "Buffer explorer",
            },
        },
        deactivate = function()
            vim.cmd([[Neotree close]])
        end,
    },

    {  -- Diagnostics ----------------------------------------------------------
        "folke/trouble.nvim",
        keys = {
            { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)", },
            { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)", },
            { "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols (Trouble)", },
            { "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP Definitions / references / ... (Trouble)", },
            { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)", },
            { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)", },
        },
        opts = {}, -- for default options, refer to the configuration section for custom setup.
    },

    {  -- Show pop-up menu with relevant key-bindings
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            -- plugins = { spelling = true },
        },
        keys = {
            {
                "<leader>?",
                function()
                    require("which-key").show({ global = false })
                end,
                desc = "Buffer Local Keymaps (which-key)",
            },
        },
        config = function(_, opts)
            local wk = require("which-key")
            wk.setup(opts)
            wk.add(
                {
                    mode = { "n", "v" },
                    { "g", group = "goto" },
                    { "gs", group = "surround" },
                    { "z", group = "fold" },
                    { "]", group = "next" },
                    { "[", group = "prev" },
                    { "<leader><tab>", group = "tabs" },
                    { "<leader>b", group = "buffer" },
                    --{ "<leader>b", group = "buffers", expand = function()
                    --    return require("which-key.extras").expand.buf()
                    --end
                    --},
                    { "<leader>c", group = "code" },
                    { "<leader>f", group = "file/find" },
                    { "<leader>g", group = "git" },
                    { "<leader>gh", group = "hunks" },
                    { "<leader>q", group = "quit/session" },
                    { "<leader>s", group = "search" },
                    { "<leader>u", group = "ui" },
                    { "<leader>w", group = "windows" },
                    { "<leader>x", group = "diagnostics/quickfix" },
                }
            )
        end,
    },

    { -- Tree Sitter and friends --------------------------------------------
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        dependencies = {
            "andymass/vim-matchup"
        },
        config = function(_, opts)
            require 'nvim-treesitter'.setup()
            require 'nvim-treesitter.configs'.setup {
                highlight = { enable = false },
                indent = { enable = true },
                ensure_installed = { "awk", "bash", "c", "cpp", "cmake", "css", "devicetree", "diff",
                    "dockerfile", "html", "javascript", "jsdoc", "json", "jsonc", "lua", "luadoc", "luap",
                    "markdown", "markdown_inline", "python", "query", "regex", "ruby", "rust", "toml",
                    "tsx", "typescript", "vim", "vimdoc", "xml", "yaml", "yang" },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "<C-space>",
                        node_incremental = "<C-space>",
                        scope_incremental = false,
                        node_decremental = "<bs>",
                    },
                },
                matchup = {
                    enable = true,  -- mandatory, false will disable the whole extension
                    disable = { },  -- optional, list of language that will be disabled
                    -- [options]
                },
            }
        end,
    },

    { -- Show current scope with a nice animation
        "echasnovski/mini.indentscope",
        version = false, -- wait till new 0.7.0 release to put it back on semver
        opts = {
            symbol = "│",
            options = { try_as_border = true },
        },
        init = function()
            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "trouble", "lazy", "mason", "notify", "toggleterm", "lazyterm", },
                callback = function()
                    vim.b.miniindentscope_disable = true
                end,
            })
        end,
    },


    { -- Show context of the current function
        "nvim-treesitter/nvim-treesitter-context",
        lazy = false,
        enabled = true,
        opts = {
            mode = "cursor",
            max_lines = 6
        },
        keys = {
            { "<leader>ut", "<cmd>TSContextToggle<CR>", desc = "Toggle Treesitter Context", },
        },
    },

    { -- Automatically add closing tags for HTML and JSX
        "windwp/nvim-ts-autotag",
        enabled = false,
        opts = {},
    },
}

