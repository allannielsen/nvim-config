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

    { -- Color preview
        'norcalli/nvim-colorizer.lua',
        cmd = {"ColorizerAttachToBuffer", "ColorizerDetachFromBuffer", "ColorizerReloadAllBuffers", "ColorizerToggle"},
    },

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
        branch = "dev", -- IMPORTANT!
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
            plugins = { spelling = true },
            defaults = {
                mode = { "n", "v" },
                ["g"] = { name = "+goto" },
                ["gs"] = { name = "+surround" },
                ["z"] = { name = "+fold" },
                ["]"] = { name = "+next" },
                ["["] = { name = "+prev" },
                ["<leader><tab>"] = { name = "+tabs" },
                ["<leader>b"] = { name = "+buffer" },
                ["<leader>c"] = { name = "+code" },
                ["<leader>f"] = { name = "+file/find" },
                ["<leader>g"] = { name = "+git" },
                ["<leader>gh"] = { name = "+hunks" },
                ["<leader>q"] = { name = "+quit/session" },
                ["<leader>s"] = { name = "+search" },
                ["<leader>u"] = { name = "+ui" },
                ["<leader>w"] = { name = "+windows" },
                ["<leader>x"] = { name = "+diagnostics/quickfix" },
            },
        },
        config = function(_, opts)
            local wk = require("which-key")
            wk.setup(opts)
            wk.register(opts.defaults)
        end,
    },


    { -- Tree Sitter and friends --------------------------------------------
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        dependencies = { },
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
            }
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

