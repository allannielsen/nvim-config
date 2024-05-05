local enabled = true
local function toggle_diagnostics()
    -- if this Neovim version supports checking if diagnostics are enabled
    -- then use that for the current state
    if vim.diagnostic.is_disabled then
        enabled = not vim.diagnostic.is_disabled()
    end
    enabled = not enabled

    if enabled then
        vim.diagnostic.enable()
    else
        vim.diagnostic.disable()
    end
end

return {
    {
        'folke/neodev.nvim',
        config = function()
            require("neodev").setup({})
        end,
    },

    {
        "artemave/workspace-diagnostics.nvim",
        config = function()
            require("workspace-diagnostics").setup({
                workspace_files = function()
                    local h = io.popen("jq -r '.[]|.file' compile_commands.json")
                    local r = h:read("*a")
                    h:close()

                    return vim.split(vim.trim(r), "\n", true)
                end
            })
        end,
    },

    {
        "neovim/nvim-lspconfig",
        dependencies = {
            'folke/neodev.nvim',
        },
        config = function()
            local lspconfig = require('lspconfig')
            vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "single" })
            vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "single" })

            vim.api.nvim_create_autocmd('LspAttach', {
                callback = function(args)
                    vim.keymap.set({'n', 'v'}, 'gr', '<cmd>lua vim.lsp.buf.references()<CR>',      { noremap = true, buffer = args.buf, silent = true, desc = 'LSP references'})
                    vim.keymap.set({'n', 'v'}, 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>',     { noremap = true, buffer = args.buf, silent = true, desc = 'LSP declaration'})
                    vim.keymap.set({'n', 'v'}, 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>',      { noremap = true, buffer = args.buf, silent = true, desc = 'LSP definition'})
                    vim.keymap.set({'n', 'v'}, 'gT', '<Cmd>lua vim.lsp.buf.type_definition()<CR>', { noremap = true, buffer = args.buf, silent = true, desc = 'LSP type definition'})
                    vim.keymap.set({'n', 'v'}, 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>',  { noremap = true, buffer = args.buf, silent = true, desc = 'LSP implementation'})
                    vim.keymap.set({'n', 'v'}, 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>',            { noremap = true, buffer = args.buf, silent = true, desc = 'LSP information'})
                    vim.keymap.set({'n', 'v'}, '<leader>K', '<cmd>lua vim.lsp.buf.signature_help()<CR>', { noremap = true, buffer = args.buf, silent = true, desc = 'LSP signature help'})
                    vim.keymap.set({'i'}, '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', { noremap = true, buffer = args.buf, silent = true, desc = 'LSP signature help'})
                    vim.keymap.set({'n', 'v'}, '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', { noremap = true, buffer = args.buf, silent = true, desc = 'LSP add workspace folder'})
                    vim.keymap.set({'n', 'v'}, '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', { noremap = true, buffer = args.buf, silent = true, desc = 'LSP remove workspace folder'})
                    vim.keymap.set({'n', 'v'}, '<leader>wl', '<cmd>lua print(vim.inspect(vimhlsp.buf.list_workspace_folders()))<CR>', { noremap = true, buffer = args.buf, silent = true, desc = 'LSP list workspace folders'})
                    vim.keymap.set({'n', 'v'}, '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', { noremap = true, buffer = args.buf, silent = true, desc = 'LSP type definition'})
                    vim.keymap.set({'n', 'v'}, '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', { noremap = true, buffer = args.buf, silent = true, desc = 'LSP rename symbol'})
                    vim.keymap.set({'n', 'v'}, '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', { noremap = true, buffer = args.buf, silent = true, desc = 'LSP code action'})
                    -- vim.keymap.set({'n', 'v'}, '<leader>ca', vim.lsp.buf.code_action, { noremap = true, buffer = args.buf, silent = true, desc = 'LSP code action' })
                    vim.keymap.set({'n', 'v'}, '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', { noremap = true, buffer = args.buf, silent = true, desc = 'LSP show line diagnostics'})
                    vim.keymap.set({'n', 'v'}, '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', { noremap = true, buffer = args.buf, silent = true, desc = 'LSP goto prev diagnostics'})
                    vim.keymap.set({'n', 'v'}, ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', { noremap = true, buffer = args.buf, silent = true, desc = 'LSP goto next diagnostics'})
                    vim.keymap.set({'n', 'v'}, '<leader>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', { noremap = true, buffer = args.buf, silent = true, desc = 'LSP set loclist with diagnostics'})
                    vim.keymap.set({'n', 'v'}, '<leader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', { noremap = true, buffer = args.buf, silent = true, desc = 'LSP formatting'})
                    vim.keymap.set({'n', 'v'}, "<leader>ud", function() toggle_diagnostics() end, { desc = "Toggle diagnostics" })
                end
            })
            -- lspconfig.pylsp.setup({
            --   settings = {
            --     pylsp = {
            --       plugins = {
            --         pycodestyle = {
            --           ignore = {'W391'},
            --           maxLineLength = 120
            --         }
            --       }
            --     }
            --   }
            -- })

            -- lspconfig.yamlls.setup({
            --   settings = {
            --     yaml = {
            --       keyOrdering = false
            --     }
            --   }
            -- })

            -- lspconfig.ccls.setup({})
            -- lspconfig.lua_ls.setup({
            --   settings = {
            --     Lua = {
            --       diagnostics = {
            --         globals = {'vim', 'it', 'describe'}
            --       },
            --       runtime = {
            --         version = "LuaJIT",
            --         path = vim.split(package.path, ';')
            --       },
            --       telemetry = {
            --         enable = false,
            --       },
            --     }
            --   }
            -- })
            -- lspconfig.bashls.setup({})
            -- lspconfig.solargraph.setup({})
            -- lspconfig.tsserver.setup({})
            lspconfig.rust_analyzer.setup({})
            lspconfig.clangd.setup({
                on_attach = function(client, bufnr)
                    -- require("workspace-diagnostics").populate_workspace_diagnostics(vim.lsp.buf_get_clients()[1], 1)
                    -- require("workspace-diagnostics").populate_workspace_diagnostics(client, bufnr)
                end
            })
            -- lspconfig.vimls.setup({})
        end,
    },

    {
        "hrsh7th/nvim-cmp",
        version = false, -- last release is way too old
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
        },
        config = function()
            local cmp = require('cmp')

            cmp.setup({
                mapping = {
                    ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
                    ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                    ["<S-CR>"] = cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = true,
                    }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                    ["<C-CR>"] = function(fallback)
                        cmp.abort()
                        fallback()
                    end,
                },
                sources = {
                    -- { name = "buffer" },
                    { name = "nvim_lsp" },
                    -- { name = "treesitter" },
                    { name = "path" },
                },

                completion = {
                    autocomplete = false
                }
            })
        end,
        ---@param opts cmp.ConfigSchema
    },
}
