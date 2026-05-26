vim.cmd [[packadd packer.nvim]]
require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'fatih/vim-go'
  use 'folke/tokyonight.nvim'
  use 'easymotion/vim-easymotion'
  use 'belltoy/vim-protobuf'
  use 'tpope/vim-fugitive'
  use 'godlygeek/csapprox'
  use 'scrooloose/nerdtree'
  use 'flazz/vim-colorschemes'
  use 'mattn/emmet-vim'
  use 'elzr/vim-json'
  use 'kien/ctrlp.vim'
  use 'ConradIrwin/vim-bracketed-paste'
  use 'udalov/kotlin-vim'
  use 'hashivim/vim-terraform'
  use 'neovim/nvim-lspconfig'
  use 'williamboman/mason.nvim'
  use 'williamboman/mason-lspconfig.nvim'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'L3MON4D3/LuaSnip'
  use 'saadparwaiz1/cmp_luasnip'
  use 'nvim-lua/plenary.nvim'
  use 'MunifTanjim/nui.nvim'
  use 'hrsh7th/nvim-cmp'
  use 'nvim-tree/nvim-web-devicons'
  use 'HakonHarnes/img-clip.nvim'
  use 'stevearc/dressing.nvim' -- for enhanced input UI
  use 'folke/snacks.nvim' -- for modern input UI
  use 'MeanderingProgrammer/render-markdown.nvim'

  use({
    'nvim-treesitter/nvim-treesitter',
    branch = 'master', -- Add this line
    run = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = { "lua", "vim", "vimdoc", "markdown", "markdown_inline" },
        highlight = {
          enable = true,
        },
      })
    end,
  })
end)
