# Neovim Configuration

This is a custom Neovim configuration tailored for efficient coding, with a focus on TypeScript development, Git integration, and a modern, aesthetically pleasing interface. It uses [Packer](https://github.com/wbthomason/packer.nvim) as the plugin manager and organizes settings and plugins in a modular structure under the `arob` namespace.

## Features

### Navigation and File Management

- **[Harpoon](https://github.com/ThePrimeagen/harpoon)**: Quick switching between frequently used files.
- **[Nvim-tree](https://github.com/nvim-tree/nvim-tree.lua)**: File explorer with icon support via `nvim-web-devicons`.
- **[Telescope](https://github.com/nvim-telescope/telescope.nvim)**: Fuzzy finding for files, buffers, and more, enhanced with `telescope-fzf-native.nvim`.

### Coding Enhancements

- **[Treesitter](https://github.com/nvim-treesitter/nvim-treesitter)**: Advanced syntax highlighting and code parsing.
- **LSP Support**: Language server configurations managed by [Mason](https://github.com/williamboman/mason.nvim), with enhanced UI via [Lspsaga](https://github.com/nvimdev/lspsaga.nvim) and additional tools like [Null-ls](https://github.com/jose-elias-alvarez/null-ls.nvim) for linting and formatting.
- **[Typescript-tools.nvim](https://github.com/pmizio/typescript-tools.nvim)**: Specialized tools for TypeScript development.
- **[Autopairs](https://github.com/windwp/nvim-autopairs)** and **[Autotag](https://github.com/windwp/nvim-ts-autotag)**: Automatic closing of brackets and HTML tags.
- **[Nvim-cmp](https://github.com/hrsh7th/nvim-cmp)**: Autocompletion with support for buffers, paths, and snippets via [LuaSnip](https://github.com/L3MON4D3/LuaSnip).

### Git Integration

- **[Fugitive](https://github.com/tpope/vim-fugitive)**: Comprehensive Git commands within Neovim.
- **[Gitsigns](https://github.com/lewis6991/gitsigns.nvim)**: Git status indicators in the gutter.
- **[Diffview](https://github.com/sindrets/diffview.nvim)**: Visual diff comparisons.
- **[Gitblame](https://github.com/f-person/git-blame.nvim)**: Inline Git blame information.

### UI and Aesthetics

- **Color Schemes**:
  - [Rose Pine](https://github.com/rose-pine/neovim) (default)
  - [Nightfox](https://github.com/EdenEast/nightfox.nvim) (not used)
  - [Kanagawa](https://github.com/rebelot/kanagawa.nvim) (not used)
- **Statusline**: [Heirline](https://github.com/rebelot/heirline.nvim) for a customizable statusline (Feline is also available but commented out).
- **[Indent-blankline](https://github.com/lukas-reineke/indent-blankline.nvim)**: Visual indent guides.
- **[Minimap](https://github.com/wfxr/minimap.vim)**: Code minimap for quick navigation.

### Productivity

- **[Undotree](https://github.com/mbbill/undotree)**: Visual undo history.
- **[Comment.nvim](https://github.com/numToStr/Comment.nvim)**: Easy commenting with `gc`.
- **[Toggleterm](https://github.com/akinsho/toggleterm.nvim)**: Integrated terminal within Neovim.
- **[Vim-surround](https://github.com/tpope/vim-surround)** and **[ReplaceWithRegister](https://github.com/vim-scripts/ReplaceWithRegister)**: Enhanced text manipulation.
- **[Vim-maximizer](https://github.com/szw/vim-maximizer)**: Maximize and restore windows.
- **[Vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator)**: Seamless navigation between tmux and Neovim splits.

## Installation

Follow these steps to set up the configuration:

1. **Clone the Repository**:
   Clone this configuration into your Neovim config directory:

   ```bash
   git clone https://github.com/yourusername/your-repo.git ~/.config/nvim
   ```

   Replace `yourusername/your-repo` with your actual repository URL.

2. **Launch Neovim**:
   Open Neovim:

   ```bash
   nvim
   ```

   If Packer is not installed, the `ensure_packer` function in `plugins-setup.lua` will automatically install it.

3. **Install Plugins**:
   Run the following command to install all plugins:

   ```vim
   :PackerSync
   ```

   Alternatively, save the `plugins-setup.lua` file (`:w`), and the autocommand will trigger `:PackerSync` automatically.

4. **Install External Dependencies**:
   Some plugins, like LSP servers, require external tools. Use Mason to manage them:
   ```vim
   :Mason
   ```
   Install the language servers you need (e.g., `tsserver` for TypeScript).

## Configuration Structure

The configuration is organized modularly for clarity and maintainability:

- **`init.lua`**: The entry point that loads all core settings and plugin configurations.
- **`lua/arob/core/`**:
  - `options.lua`: General Neovim settings.
  - `keymaps.lua`: Custom keybindings.
  - `colours.lua`: Color scheme settings.
  - `themes/`: Additional theme-specific configurations (e.g., `rose-pine.lua`).
- **`lua/arob/plugins/`**:
  - Individual plugin configuration files (e.g., `telescope.lua`, `treesitter.lua`).
  - `lsp/`: Subdirectory for LSP-related setups (`mason.lua`, `lspsaga.lua`, `lspconfig.lua`, `null-ls.lua`).
- **`plugins-setup.lua`**: Packer plugin definitions and bootstrap logic.
- **`plugin/packer_compiled.lua`**: Auto-generated by Packer for faster startup.

This structure keeps the configuration organized and easy to extend.

## Customization

To tailor this configuration to your needs:

- **Add or Remove Plugins**:
  Edit `plugins-setup.lua` to modify the plugin list, then run:

  ```vim
  :PackerSync
  ```

- **Adjust Keybindings**:
  Modify `core/keymaps.lua` to change or add custom keymaps.

- **Change Settings**:
  Update `core/options.lua` for general Neovim options.

- **Switch Color Schemes**:
  Edit `core/colours.lua` or uncomment alternative `vim.cmd("colorscheme ...")` lines in `plugins-setup.lua`.

- **Plugin-Specific Tweaks**:
  Adjust settings in the respective files under `lua/arob/plugins/` or `lua/arob/plugins/lsp/`.

## Notes

- The configuration includes an autocommand in `plugins-setup.lua` that syncs plugins whenever the file is saved, ensuring your setup stays up-to-date.
- For TypeScript development, ensure `typescript-tools.nvim` dependencies (like `tsserver`) are installed via Mason or your package manager.
- Some plugins (e.g., `vim-be-good`) are included for learning Neovim but can be removed if not needed.
