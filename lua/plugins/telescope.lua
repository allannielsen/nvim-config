function telescope_config_files()
    return require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
end

return {
    {
        "nvim-telescope/telescope.nvim",
        cmd = "Telescope",
        version = false, -- telescope did only one release, so use HEAD for now
        dependencies = {
            { 'nvim-lua/plenary.nvim' },
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
            },
        },

        keys = {
            { "<leader>,", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>", desc = "Switch Buffer", },
            { "<leader>/", "<cmd>Telescope live_grep<cr>", desc = "Grep (cwd)" },
            { "<leader>:", "<cmd>Telescope command_history<cr>", desc = "Command History" },
            { "<leader><space>", "<cmd>Telescope find_files<cr>", desc = "Find Files (cwd)" },

            -- -- find
            { "<leader>fb", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>", desc = "Buffers" },
            -- { "<leader>fc", Util.telescope.config_files(), desc = "Find Config File" },
            { "<leader>fc", telescope_config_files, desc = "Find Config File" },
            { "<leader>fg", "<cmd>Telescope git_files<cr>", desc = "Find Files (git-files)" },
            { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent" },
            --{ "<leader>fR", Util.telescope("oldfiles", { cwd = vim.loop.cwd() }), desc = "Recent (cwd)" },

            -- -- git
            { "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "commits" },
            { "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "status" },

            -- -- search
            { '<leader>s"', "<cmd>Telescope registers<cr>", desc = "Registers" },
            { "<leader>sa", "<cmd>Telescope autocommands<cr>", desc = "Auto Commands" },
            { "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer" },
            { "<leader>sc", "<cmd>Telescope command_history<cr>", desc = "Command History" },
            { "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Commands" },
            { "<leader>sd", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Document diagnostics" },
            { "<leader>sD", "<cmd>Telescope diagnostics<cr>", desc = "Workspace diagnostics" },
            { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
            { "<leader>sH", "<cmd>Telescope highlights<cr>", desc = "Search Highlight Groups" },
            { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Key Maps" },
            { "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
            { "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Jump to Mark" },
            { "<leader>so", "<cmd>Telescope vim_options<cr>", desc = "Options" },
            { "<leader>sR", "<cmd>Telescope resume<cr>", desc = "Resume" },


            { "<leader>sw", "<cmd>Telescope grep_string word_match=-w<cr>",             desc = "Word (cwd) with -w" },
            { "<leader>sW", "<cmd>Telescope grep_string<cr>",                           desc = "Word (cwd) without -w" },
            { "<leader>sw", "<cmd>Telescope grep_string word_match=-w<cr>", mode = "v", desc = "Word (cwd) with -w" },
            { "<leader>sw", "<cmd>Telescope grep_string<cr>",               mode = "v", desc = "Word (cwd) without -w" },

            { "<leader>uC", "<cmd>Telescope colorscheme enable_preview=true<cr>", desc = "Colorscheme with preview" },


            -- {
            --   "<leader>ss",
            --   function()
            --     require("telescope.builtin").lsp_document_symbols({
            --       symbols = require("lazyvim.config").get_kind_filter(),
            --     })
            --   end,
            --   desc = "Goto Symbol",
            -- },
            -- {
            --   "<leader>sS",
            --   function()
            --     require("telescope.builtin").lsp_dynamic_workspace_symbols({
            --       symbols = require("lazyvim.config").get_kind_filter(),
            --     })
            --   end,
            --   desc = "Goto Symbol (Workspace)",
            -- },
        },

        opts = function()
            local actions = require("telescope.actions")

            local open_with_trouble = function(...)
                return require("trouble.providers.telescope").open_with_trouble(...)
            end
            local open_selected_with_trouble = function(...)
                return require("trouble.providers.telescope").open_selected_with_trouble(...)
            end
            local find_files_no_ignore = function()
                local action_state = require("telescope.actions.state")
                local line = action_state.get_current_line()
                require("telescope.builtin").find_files({ no_ignore = true, default_text = line })
            end
            local find_files_with_hidden = function()
                local action_state = require("telescope.actions.state")
                local line = action_state.get_current_line()
                require("telescope.builtin").find_files({ hidden = true, default_text = line })
            end

            return {
                defaults = {
                    prompt_prefix = " ",
                    selection_caret = " ",
                    -- open files in the first window that is an actual file.
                    -- use the current window if no other window is available.
                    get_selection_window = function()
                        local wins = vim.api.nvim_list_wins()
                        table.insert(wins, 1, vim.api.nvim_get_current_win())
                        for _, win in ipairs(wins) do
                            local buf = vim.api.nvim_win_get_buf(win)
                            if vim.bo[buf].buftype == "" then
                                return win
                            end
                        end
                        return 0
                    end,
                    mappings = {
                        i = {
                            ["<c-t>"] = open_with_trouble,
                            ["<a-t>"] = open_selected_with_trouble,
                            ["<a-i>"] = find_files_no_ignore,
                            ["<a-h>"] = find_files_with_hidden,
                            ["<C-Down>"] = actions.cycle_history_next,
                            ["<C-Up>"] = actions.cycle_history_prev,
                            ["<C-f>"] = actions.preview_scrolling_down,
                            ["<C-b>"] = actions.preview_scrolling_up,
                        },
                        n = {
                            ["q"] = actions.close,
                        },
                    },
                },
            }
        end,
    },
}

