-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use('wbthomason/packer.nvim')

  -- lua funcitons that many plugins use
  use("nvim-lua/plenary.nvim")

  use {
          'nvim-telescope/telescope.nvim', tag = '0.1.1',
          -- or                            , branch = '0.1.x',
          requires = { {'nvim-lua/plenary.nvim'} }
  }

  -- Colour Schemes
  use({ 'rose-pine/neovim', as = 'rose-pine' })
  use "EdenEast/nightfox.nvim"
  use "rebelot/kanagawa.nvim"

  vim.cmd('colorscheme rose-pine')
  --vim.cmd("colorscheme nightfox")
  --vim.cmd("colorscheme kanagawa")

  -- General Plugins
  use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
  use('nvim-treesitter/playground')

  -- Swap between files fast
  use('theprimeagen/harpoon')

  -- Practice Nvim with Games
  use('theprimeagen/vim-be-good')

  -- undo history tree
  use('mbbill/undotree')
  use('tpope/vim-fugitive')

  -- tmux & split window navigation
  use('christoomey/vim-tmux-navigator')

  --maximizes and restores current window
  use('szw/vim-maximizer')

  -- essential plugins
  use("tpope/vim-surround")
  use("vim-scripts/ReplaceWithRegister")

  -- commenting with gc
  use("numToStr/Comment.nvim")

  -- Toggle Terminal
  use {"akinsho/toggleterm.nvim", tag = '*', config = function()
      require("toggleterm").setup()
  end}

  -- file explorer
  use {
      'nvim-tree/nvim-tree.lua',
      requires = {
          'nvim-tree/nvim-web-devicons', -- optional
      },
      config = function()
          require("nvim-tree").setup {}
      end
  }
  -- use('kyazdani42/nvim-web-devicons')

  -- statusline
  -- use("nvim-lualine/lualine.nvim")
  
  -- Toggle Terminal
  use {"akinsho/toggleterm.nvim", tag = '*', config = function()
      require("toggleterm").setup()
  end}

  -- LSP
  use {
          'VonHeikemen/lsp-zero.nvim',
          branch = 'v2.x',
          requires = {
                  -- LSP Support
                  {'neovim/nvim-lspconfig'},             -- Required
                  {                                      -- Optional
                  'williamboman/mason.nvim',
                  run = function()
                          pcall(vim.cmd, 'MasonUpdate')
                  end,
          },
          {'williamboman/mason-lspconfig.nvim'}, -- Optional

          -- Autocompletion
          {'hrsh7th/nvim-cmp'},     -- Required
          {'hrsh7th/cmp-nvim-lsp'}, -- Required
          {'L3MON4D3/LuaSnip'},     -- Required
  }
}

end)
