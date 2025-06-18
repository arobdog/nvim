-- Lazy.nvim installation
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

-- Plugin list for Lazy.nvim
local plugins = {
  -- Lua functions that many plugins use
  { "nvim-lua/plenary.nvim" },

  -- Colour Schemes
  { "rose-pine/neovim", name = "rose-pine" },
  { "EdenEast/nightfox.nvim" },
  { "rebelot/kanagawa.nvim" },

  -- Swap between files fast
  { "theprimeagen/harpoon", config = function() require("arob.plugins.harpoon") end },

  -- Practice Nvim with Games
  { "theprimeagen/vim-be-good" },

  -- Undo history tree
  { "mbbill/undotree", config = function() require("arob.plugins.undotree") end },

  -- Git integration
  { "tpope/vim-fugitive", config = function() require("arob.plugins.fugitive") end },

  -- Tmux & split window navigation
  { "christoomey/vim-tmux-navigator" },

  -- Maximizes and restores current window
  { "szw/vim-maximizer" },

  -- Essential plugins
  { "tpope/vim-surround" },
  { "vim-scripts/ReplaceWithRegister" },

  -- Commenting with gc
  { "numToStr/Comment.nvim", config = function() require("arob.plugins.comment") end },

  -- Toggle Terminal
  { "akinsho/toggleterm.nvim", config = function() require("arob.plugins.toggleterm") end },

  -- File explorer
  { "nvim-tree/nvim-tree.lua", dependencies = { "nvim-tree/nvim-web-devicons" }, config = function() require("arob.plugins.nvim-tree") end },

  -- Fuzzy finding w/ Telescope
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope-fzf-native.nvim" }, config = function() require("arob.plugins.telescope") end },

  -- Treesitter configuration
  { "nvim-treesitter/nvim-treesitter", build = function() pcall(require("nvim-treesitter.install").update({ with_sync = true })) end, config = function() require("arob.plugins.treesitter") end },
  { "nvim-treesitter/playground" },

  -- Autocompletion
  { "hrsh7th/nvim-cmp", config = function() require("arob.plugins.nvim-cmp") end },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },

  -- Snippets
  { "L3MON4D3/LuaSnip" },
  { "saadparwaiz1/cmp_luasnip" },
  { "rafamadriz/friendly-snippets" },

  -- Managing & installing LSP servers, linters & formatters
  { "williamboman/mason.nvim", config = function() require("arob.plugins.lsp.mason") end },
  { "williamboman/mason-lspconfig.nvim" },

  -- Configuring LSP servers
  { "neovim/nvim-lspconfig", config = function() require("arob.plugins.lsp.lspconfig") end },
  { "hrsh7th/cmp-nvim-lsp" },
  { "nvimdev/lspsaga.nvim", dependencies = { "neovim/nvim-lspconfig" }, config = function() require("arob.plugins.lsp.lspsaga") end },

  -- Enhanced LSP UIs
  { "pmizio/typescript-tools.nvim", dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" } },
  { "onsails/lspkind.nvim" },

  -- Formatting & linting
  { "nvimtools/none-ls.nvim", dependencies = { "nvim-lua/plenary.nvim", "nvimtools/none-ls-extras.nvim"}, config = function() require("arob.plugins.lsp.null-ls") end },
  { "jayp0521/mason-null-ls.nvim" },

  -- Auto closing
  { "windwp/nvim-autopairs", config = function() require("arob.plugins.autopairs") end },
  { "windwp/nvim-ts-autotag" },

  -- Git signs plugin
  { "lewis6991/gitsigns.nvim", config = function() require("arob.plugins.gitsigns") end },

  -- Diffview
  { "sindrets/diffview.nvim", dependencies = { "nvim-lua/plenary.nvim" }, config = function() require("arob.plugins.diffview") end },

  -- Git blame
  { "f-person/git-blame.nvim", config = function() require("arob.plugins.gitblame") end },

  -- Indent blankline
  { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {}, config = function() require("arob.plugins.indent-blankline") end },

  -- Statusline
  --{ "feline-nvim/feline.nvim", config = function() require("arob.plugins.feline") end },
  { "rebelot/heirline.nvim", config = function() require("arob.plugins.heirline") end },
}

-- Setup Lazy.nvim with the plugin list
require("lazy").setup(plugins)
