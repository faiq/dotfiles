-- General settings
vim.o.background = 'dark'
vim.o.encoding = 'utf-8'
vim.o.backspace = 'indent,eol,start'
require('plugins')
require('snippets')
local lspconfig = require('lspconfig')
local mason = require('mason')
local mason_lspconfig = require('mason-lspconfig')

mason.setup()
mason_lspconfig.setup({
  ensure_installed = { 'pyright', 'ts_ls', 'gopls', 'lua_ls'},
  automatic_installation = true,
})

lspconfig.pyright.setup({})
lspconfig.ts_ls.setup({})
lspconfig.gopls.setup({})
lspconfig.lua_ls.setup {
  on_init = function(client)
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if path ~= vim.fn.stdpath('config') and (vim.uv.fs_stat(path..'/.luarc.json') or vim.uv.fs_stat(path..'/.luarc.jsonc')) then
        return
      end
    end

    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      runtime = {
        version = 'LuaJIT'
      },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME
        }
      }
    })
  end,
  settings = {
    Lua = {}
  }
}

-- Filetype and syntax
vim.cmd('filetype plugin indent on')
vim.cmd('syntax on')

-- Colorscheme
vim.cmd('colorscheme tokyonight-storm')

-- Indentation settings
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.autoindent = true
vim.o.smarttab = true
vim.o.ruler = true

-- Filetype specific settings
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'html',
  command = 'setlocal ts=4 sw=4 noexpandtab'
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = {'javascript', 'bash'},
  command = 'setlocal ts=2 sw=2 expandtab'
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'python',
  command = 'setlocal ts=4 sw=4 sts=0 expandtab'
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'go',
  command = 'setlocal ts=8 sw=8 sts=0 noexpandtab'
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'make',
  command = 'setlocal noexpandtab'
})

vim.api.nvim_create_autocmd({'BufNewFile', 'BufFilePre', 'BufRead'}, {
  pattern = '*.md',
  command = 'set filetype=markdown.pandoc'
})

-- General editor settings
vim.o.autoread = true
vim.o.hlsearch = true
vim.o.ignorecase = true
vim.o.number = true
vim.o.clipboard = 'unnamedplus'

-- Whitespace highlighting
vim.cmd('highlight ExtraWhitespace ctermbg=red guibg=red')
vim.cmd('match ExtraWhitespace /\\s\\+$/')

-- Key mappings
vim.api.nvim_set_keymap('n', ';', ':', {noremap = true})
vim.api.nvim_set_keymap('v', '<C-r>', '"hy:%s/<C-r>h//gc<left><left><left>', {noremap = true})
vim.api.nvim_set_keymap('n', '<C-c>', '<C-z>', {noremap = true})
vim.api.nvim_set_keymap('n', 'nh', ':nohl<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<F5>', ':let _s=@/<Bar>:%s/\\s\\+$//e<Bar>:let @/=_s<Bar><CR>', {noremap = true})
vim.api.nvim_set_keymap('n', 'Y', 'Y', {noremap = true})

-- Leader key
vim.g.mapleader = ','
vim.g.maplocalleader = '.'

-- Go specific mappings
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'go',
  callback = function()
    vim.api.nvim_buf_set_keymap(0, 'n', '<Leader>ds', '<Plug>(go-def-split)', {noremap = true})
    vim.api.nvim_buf_set_keymap(0, 'n', '<Leader>dv', '<Plug>(go-def-vertical)', {noremap = true})
    vim.api.nvim_buf_set_keymap(0, 'n', '<Leader>dt', '<Plug>(go-def-tab)', {noremap = true})

    vim.api.nvim_buf_set_keymap(0, 'n', '<Leader>dos', '<Plug>(go-doc-split)', {noremap = true})
    vim.api.nvim_buf_set_keymap(0, 'n', '<Leader>dov', '<Plug>(go-doc-vertical)', {noremap = true})
    vim.api.nvim_buf_set_keymap(0, 'n', '<Leader>dot', '<Plug>(go-doc-tab)', {noremap = true})

    vim.api.nvim_buf_set_keymap(0, 'n', '<Leader>r', '<Plug>(go-run)', {noremap = true})
    vim.api.nvim_buf_set_keymap(0, 'n', '<Leader>b', '<Plug>(go-build)', {noremap = true})
    vim.api.nvim_buf_set_keymap(0, 'n', '<Leader>t', '<Plug>(go-test)', {noremap = true})
    vim.api.nvim_buf_set_keymap(0, 'n', '<Leader>c', '<Plug>(go-coverage)', {noremap = true})
  end
})

-- Kotlin filetype
vim.api.nvim_create_autocmd({'BufNewFile', 'BufRead'}, {
  pattern = '*.kt',
  command = 'set filetype=kotlin'
})

-- NERDTree settings
vim.g.NERDTreeDirArrows = 0

-- Folding settings
vim.o.foldmethod = 'syntax'
vim.api.nvim_create_autocmd('InsertEnter', {
  callback = function()
    vim.w.last_fdm = vim.o.foldmethod
    vim.o.foldmethod = 'manual'
  end
})

vim.api.nvim_create_autocmd('InsertLeave', {
  callback = function()
    vim.o.foldmethod = vim.w.last_fdm
  end
})

vim.api.nvim_set_keymap('n', '<Leader>', '<Plug>(easymotion-prefix)', {})

if not vim.g.yamllint_command then
  vim.g.yamllint_command = "yamllint"
end

function _G.Yamllint()
  vim.cmd('silent !clear')
  vim.cmd('!' .. vim.g.yamllint_command .. ' ' .. vim.fn.bufname('%'))
end

vim.cmd('command! Yamllint call v:lua.Yamllint()')

vim.api.nvim_buf_set_keymap(0, 'n', 'dv', '<Cmd>lua vim.lsp.buf.definition({ open_cmd = "vsplit" })<CR>', { noremap = true, silent = true })
vim.api.nvim_buf_set_keymap(0, 'n', 'ds', '<Cmd>lua vim.lsp.buf.definition({ open_cmd = "split" })<CR>', { noremap = true, silent = true })

vim.cmd[[set completeopt+=menuone,noselect,popup]]

-- LLM Chat
local ok, chat = pcall(require, 'llm-chat')
if not ok then
  vim.notify("Chat plugin not found!", vim.log.levels.ERROR)
end

vim.api.nvim_set_keymap('n', '<leader>cc', '<cmd>lua require("llm-chat").open_chat()<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>cq', '<cmd>lua require("llm-chat").close_chat()<CR>', {noremap = true})
