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
            -- Borders for hover/signature
            vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "single" })
            vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "single" })

            -- Common LSP keymaps
            vim.api.nvim_create_autocmd('LspAttach', {
                callback = function(args)
                    vim.keymap.set({'n', 'v'}, 'gr', vim.lsp.buf.references, { buffer = args.buf, desc = 'LSP references'})
                    vim.keymap.set({'n', 'v'}, 'gD', vim.lsp.buf.declaration, { buffer = args.buf, desc = 'LSP declaration'})
                    vim.keymap.set({'n', 'v'}, 'gd', vim.lsp.buf.definition, { buffer = args.buf, desc = 'LSP definition'})
                    vim.keymap.set({'n', 'v'}, 'gT', vim.lsp.buf.type_definition, { buffer = args.buf, desc = 'LSP type definition'})
                    vim.keymap.set({'n', 'v'}, 'gi', vim.lsp.buf.implementation, { buffer = args.buf, desc = 'LSP implementation'})
                    vim.keymap.set({'n', 'v'}, 'K', vim.lsp.buf.hover, { buffer = args.buf, desc = 'LSP information'})
                    vim.keymap.set({'n', 'v'}, '<leader>K', vim.lsp.buf.signature_help, { buffer = args.buf, desc = 'LSP signature help'})
                    vim.keymap.set({'i'}, '<C-k>', vim.lsp.buf.signature_help, { buffer = args.buf, desc = 'LSP signature help'})
                    vim.keymap.set({'n', 'v'}, '<leader>wa', vim.lsp.buf.add_workspace_folder, { buffer = args.buf, desc = 'LSP add workspace folder'})
                    vim.keymap.set({'n', 'v'}, '<leader>wr', vim.lsp.buf.remove_workspace_folder, { buffer = args.buf, desc = 'LSP remove workspace folder'})
                    vim.keymap.set({'n', 'v'}, '<leader>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, { buffer = args.buf, desc = 'LSP list workspace folders'})
                    vim.keymap.set({'n', 'v'}, '<leader>D', vim.lsp.buf.type_definition, { buffer = args.buf, desc = 'LSP type definition'})
                    vim.keymap.set({'n', 'v'}, '<leader>rn', vim.lsp.buf.rename, { buffer = args.buf, desc = 'LSP rename symbol'})
                    vim.keymap.set({'n', 'v'}, '<leader>ca', vim.lsp.buf.code_action, { buffer = args.buf, desc = 'LSP code action'})
                    vim.keymap.set({'n', 'v'}, '<leader>e', vim.diagnostic.open_float, { buffer = args.buf, desc = 'LSP show line diagnostics'})
                    vim.keymap.set({'n', 'v'}, '[d', vim.diagnostic.goto_prev, { buffer = args.buf, desc = 'LSP goto prev diagnostics'})
                    vim.keymap.set({'n', 'v'}, ']d', vim.diagnostic.goto_next, { buffer = args.buf, desc = 'LSP goto next diagnostics'})
                    vim.keymap.set({'n', 'v'}, '<leader>q', vim.diagnostic.setloclist, { buffer = args.buf, desc = 'LSP set loclist with diagnostics'})
                    vim.keymap.set({'n', 'v'}, '<leader>f', function() vim.lsp.buf.format { async = true } end, { buffer = args.buf, desc = 'LSP formatting'})
                    vim.keymap.set({'n', 'v'}, "<leader>ud", function() toggle_diagnostics() end, { desc = "Toggle diagnostics" })
                end
            })

            ------------------------------------------------------------------------
            -- Server configs
            ------------------------------------------------------------------------
            vim.lsp.config["ts_ls"] = {}
            vim.lsp.config["rust_analyzer"] = {}
            vim.lsp.config["clangd"] = {
                on_attach = function(client, bufnr)
                    client.server_capabilities.semanticTokensProvider = nil
                end,
                keys = {
                    { "<leader>cR", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "Switch Source/Header (C/C++)" },
                },
                root_dir = function(fname)
                    require("lspconfig.util").root_pattern("compile_commands.json", "compile_flags.txt")(fname)
                end,
                capabilities = {
                    offsetEncoding = { "utf-16" },
                },
                cmd = {
                    "clangd",
                    "--background-index",
                    "--clang-tidy",
                    "--completion-style=detailed",
                    "--function-arg-placeholders",
                    "--fallback-style=llvm",
                },
                init_options = {
                    usePlaceholders = true,
                    completeUnimported = true,
                    clangdFileStatus = true,
                },
            }

            ------------------------------------------------------------------------
            -- Autocmds to start servers
            ------------------------------------------------------------------------
            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "typescript", "typescriptreact" },
                callback = function() vim.lsp.start(vim.lsp.config["ts_ls"]) end,
            })

            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "rust" },
                callback = function() vim.lsp.start(vim.lsp.config["rust_analyzer"]) end,
            })

            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "c", "cpp" },
                callback = function() vim.lsp.start(vim.lsp.config["clangd"]) end,
            })
        end,
    },

    {
        "p00f/clangd_extensions.nvim",
        --lazy = true,
        config = function() end,
        opts = {
            inlay_hints = {
                inline = false,
            },
            ast = {
                --These require codicons (https://github.com/microsoft/vscode-codicons)
                role_icons = {
                    type = "",
                    declaration = "",
                    expression = "",
                    specifier = "",
                    statement = "",
                    ["template argument"] = "",
                },
                kind_icons = {
                    Compound = "",
                    Recovery = "",
                    TranslationUnit = "",
                    PackExpansion = "",
                    TemplateTypeParm = "",
                    TemplateTemplateParm = "",
                    TemplateParamObject = "",
                },
            },
        },
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
