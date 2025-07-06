# vim-xtract

A lightweight Vim plugin that automates the tedious task of extracting object properties into JavaScript/TypeScript destructuring assignments.

## Problem

When working with large JavaScript/TypeScript objects, manually typing out destructuring assignments is repetitive and error-prone:

```javascript
// You have this object
const person = {
    name: "Jessica",
    age: 12,
    city: "CA",
    email: "jessica@example.com",
    phone: "555-1234",
    address: "123 Main St",
};

// And you need to manually type this in your function
function childFunction(args) {
    const { name, age, city, email, phone, address } = args;

    return "";
}
```

## Solution

vim-xtract automates this process! Simply select the object properties and let the plugin generate the destructuring code for you.

## Installation

### Neovim Plugin Managers

#### Using Lazy.nvim

```lua
{
  'caesar003/vim-xtract',
  event = 'VeryLazy',
  config = function()
    -- Optional: Add key mappings
    vim.keymap.set('v', '<leader>x', ':Xtract<CR>', { desc = 'Extract object properties' })
    vim.keymap.set('n', '<leader>x', ':Xtract<CR>', { desc = 'Extract object properties' })
  end,
}
```

#### Using Packer.nvim

```lua
use {
  'caesar003/vim-xtract',
  config = function()
    -- Optional: Add key mappings
    vim.keymap.set('v', '<leader>x', ':Xtract<CR>', { desc = 'Extract object properties' })
    vim.keymap.set('n', '<leader>x', ':Xtract<CR>', { desc = 'Extract object properties' })
  end,
}
```

### Vim Plugin Managers

#### Using vim-plug

```vim
Plug 'caesar003/vim-xtract'
```

#### Using Vundle

```vim
Plugin 'caesar003/vim-xtract'
```

#### Using Pathogen

```bash
cd ~/.vim/bundle
git clone https://github.com/caesar003/vim-xtract.git
```

### Manual Installation

#### For Neovim

1. Download the plugin files
2. Copy `plugin/vim-xtract.vim` to your `~/.config/nvim/plugin/` directory

#### For Vim

1. Download the plugin files
2. Copy `plugin/vim-xtract.vim` to your `~/.vim/plugin/` directory

## Usage

### Basic Usage

1. **Select the object properties**: Use `vi{` to select inside the braces of your object
2. **Extract**: Run `:Xtract` or use the default mapping
3. **Paste**: Navigate to where you want the destructuring code and press `p`

### Example Workflow

```javascript
// 1. Place cursor anywhere inside this object
const person = {
    name: "Jessica",
    age: 12,
    city: "CA",
};

// 2. Press vi{ to select the object contents
// 3. Run :Xtract (or your mapped key)
// 4. Go to your function and paste

function childFunction(args) {
    // 5. Press 'p' here to paste:
    const { name, age, city } = args;

    return "";
}
```

### Key Mappings (Optional)

Add these to your `.vimrc` for quick access:

```vim
" Visual mode mapping
vnoremap <leader>x :Xtract<CR>

" Normal mode mapping (will work on current line)
nnoremap <leader>x :Xtract<CR>
```

## Features

-   **Clipboard Integration**: Extracted destructuring code is automatically copied to both system clipboard (`+`) and unnamed register (`"`)
-   **Smart Property Detection**: Uses regex to accurately identify object properties
-   **Range Support**: Works with visual selections of any size
-   **TypeScript Compatible**: Works with both JavaScript and TypeScript objects
-   **Lightweight**: Minimal overhead, no dependencies

## Advanced Usage

### Working with Nested Objects

```javascript
const config = {
    api: {
        baseUrl: "https://api.example.com",
        timeout: 5000,
    },
    ui: {
        theme: "dark",
        language: "en",
    },
};

// Select just the api object properties
// vi{ on the api object will extract: baseUrl, timeout
```

### Multiple Objects

You can extract properties from multiple objects in the same session - each extraction overwrites the clipboard, so paste immediately after each extraction.

## Troubleshooting

### Properties Not Detected

-   Ensure your object follows standard JavaScript syntax
-   Properties must be in `key: value` format
-   Quoted keys (`"key": value`) are supported

### Clipboard Issues

-   On Linux, ensure `xclip` or `xsel` is installed for system clipboard support
-   The plugin copies to both `+` (system) and `"` (unnamed) registers

## Contributing

Found a bug or have a feature request? Please open an issue or submit a pull request!

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

MIT License - feel free to use this plugin in your projects!

## Author

**caesar003**  
Email: caesarmuksid@gmail.com  
GitHub: [@caesar003](https://github.com/caesar003)

---

_Save time, reduce errors, and focus on what matters - your code logic, not repetitive typing!_
