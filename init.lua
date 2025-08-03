vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.opt.ttyfast = true    -- Optimize for quick connection terminal
vim.opt.number = true     -- Turn on line numbers
vim.opt.lazyredraw = true -- Do not redraw while running macros (much faster)
vim.opt.scrolloff = 5     -- Scroll before the curser reaches top or buttom
vim.opt.sidescrolloff = 2 -- Scroll before the curser reaches left or right side
vim.opt.textwidth = 80    -- Set the line width to 80 characters


-- Visual Cues -----------------------------------------
vim.opt.hidden = true     -- Allow edit buffers to be hidden
-- vim.opt.guioptions = ""   -- Remove menus
vim.opt.mouse = ""        -- Disable mouse support
-- set noerrorbells       -- Turn off beep on error
-- set hlsearch           -- highlight search - show the current search pattern
-- set incsearch          -- Do the search while typing in a search pattern
vim.opt.ignorecase = true -- Ignore case
-- set showmatch          -- Show the matching bracket for the last ')'?
vim.opt.termguicolors = true
vim.cmd.colorscheme('evening')

vim.opt.listchars = {
    tab = "» ",
    trail = "•",
    extends = ">",
    precedes = "<",
    nbsp = "¤",
}

vim.opt.list = true  -- Turn on the display of whitespace
vim.opt.fillchars = {
    foldopen = "",
    foldclose = "",
    -- fold = "⸱",
    -- fold = " ",
    -- foldsep = " ",
    diff = "-",
    eob = "~",
}

-- Text Formatting/Layout ------------------------------------------------------
-- set autoindent      " Auto indent, nice for coding
-- set smartindent     " Do smart autoindenting when starting a new line.
-- autocmd FileType c,cpp setlocal cindent
vim.opt.copyindent = true      -- Mirroring offset with automatic indentation
vim.opt.tabstop = 8            -- Number of spaces that a <Tab> in the file counts for
vim.opt.colorcolumn = '80'     -- Set the colour marker
vim.opt.expandtab = true       -- Expand Tabs (use spaces)?.
vim.opt.formatoptions="tcrqnj" -- See Help (complex)
vim.opt.linebreak = true       -- Insert automatic line breaks while typing
vim.opt.wrap = false           -- No wrap while displaying long lines
vim.opt.cinoptions= "h2,l2,g2,t0,i8,+8,(0,w1,W8,N-s"

-- Number of spaces to use for each insertion of (auto)indent.
vim.opt.shiftwidth = 4
vim.cmd([[
    autocmd FileType javascript setlocal shiftwidth=2
    autocmd FileType ruby setlocal shiftwidth=2
]])

vim.opt.wildmode = "longest,list,full" -- Bash like tab completion

-- Setup Lazy plugin system ----------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end

vim.opt.rtp:prepend(lazypath)
require("lazy").setup("plugins", {
    change_detection = { notify = false, },
    ui = { border = "single" },
})


local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.adoc = {
  install_info = {
    url = "/home/awn/git/tree-sitter-asciidoc/tree-sitter-asciidoc", -- local path or git repo
    files = {"src/parser.c", "src/scanner.c"}, -- note that some parsers also require src/scanner.c or src/scanner.cc
    -- optional entries:
    branch = "main", -- default branch in case of git repo if different from master
    generate_requires_npm = false, -- if stand-alone parser without npm dependencies
    requires_generate_from_grammar = false, -- if folder contains pre-generated src/parser.c
  },
  filetype = "adoc", -- if filetype does not match the parser name
}
