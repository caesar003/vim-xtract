# vim-xtract 🚀

Enhanced Vim plugin for effortless JavaScript/TypeScript object destructuring with template customization.

## The Problem

Manually creating destructuring assignments is tedious and error-prone:

```javascript
// Original object
const apiResponse = {
    status: 200,
    data: {
        /* complex nested data */
    },
    "x-request-id": "abc123",
    "cache-control": "no-cache",
};

// Manual destructuring (easy to miss properties)
const {
    status,
    data,
    "x-request-id": requestId,
    "cache-control": cacheControl,
} = apiResponse;
```

## The Solution

vim-xtract automates destructuring with powerful features:

-   ✨ Smart property detection (supports quoted keys)
-   🎨 Customizable templates (React/Vue/TS ready)
-   📋 Multi-register clipboard support
-   🔔 Smart notifications (Neovim + Vim compatible)

## Installation

### Neovim (Lazy.nvim)

```lua
{
  'caesar003/vim-xtract',
  ft = { 'javascript', 'typescript', 'vue', 'svelte' },
  opts = {
    var_name = 'data',  -- Default destructure variable
    template = [[const { {{keys}} } = {{var}};]],  -- Compact default
    use_notify = true,  -- Neovim notifications
  },
  keys = {
    { '<leader>x', mode = {'n','v'}, ':Xtract<CR>', desc = 'Extract properties' },
    { '<leader>xt', ':XtractTS<CR>', desc = 'TypeScript style' },
    { '<leader>xl', ':XtractLog<CR>', desc = 'Debug log' },
  }
}
```

### Vim (vim-plug)

```vim
Plug 'caesar003/vim-xtract'
let g:vim_xtract_var_name = 'props'
let g:vim_xtract_template = "const { {{keys}} } = {{var}};"

" Key mappings
vnoremap <leader>x :Xtract<CR>
nnoremap <leader>xt :XtractTS<CR>
```

## Features

### 🛠️ Advanced Property Detection

Handles all valid JS/TS syntax:

```javascript
// Detects all these patterns:
const obj = {
    standard: 1,
    "quoted-key": 2,
    "dashed-key": 3,
    [computed]: 4, // Skipped (no destructuring)
    nested: { value: 5 }, // Extracts 'nested'
};
```

### 🎨 Template Customization

Configure output format with placeholders:

```vim
" Vue Composition API example
let g:vim_xtract_template = "const { {{keys}} } = toRefs({{var}});"

" JSDoc annotated output
let g:vim_xtract_template = "/* Extracted from {{var}} */\nconst {\n{{keys}}\n} = {{var}};"
```

### 🔌 Ready-to-Use Templates

| Command       | Output Format                     | Use Case            |
| ------------- | --------------------------------- | ------------------- |
| `:Xtract`     | Standard multi-line destructuring | General purpose     |
| `:XtractTS`   | `const { keys } = obj;`           | TypeScript projects |
| `:XtractLog`  | `console.log({ keys }); // obj`   | Debugging           |
| `:XtractRefs` | `const { keys } = toRefs(obj);`   | Vue composition API |

## Usage

### Basic Workflow

```javascript
// 1. Select object (vi{ for inner object)
const response = {
    'content-type': 'application/json',
    data: { /*...*/ },
    status: 200
};

// 2. Execute command (:.Xtract)
// 3. Paste where needed (p)
const {
  content-type,
  data,
  status,
} = response;
```

### Advanced Workflow

```typescript
// 1. Select config object
const config = {
    apiEndpoint: "https://api.example.com",
    retries: 3,
    timeout: 5000,
};

// 2. Use TypeScript template (:.XtractTS)
// 3. Paste in component
const { apiEndpoint, retries, timeout } = config; // Auto-generated
```

### Custom Templates

Create project-specific templates in your config:

```lua
-- ~/.config/nvim/after/ftplugin/javascript.lua
vim.api.nvim_create_user_command('XtractVue', function()
  vim.g.vim_xtract_template = "const { {{keys}} } = use{{var:upper}}()"
  vim.cmd('Xtract')
end, { range = true })
```

## Configuration

| Option                    | Default Value                       | Description              |
| ------------------------- | ----------------------------------- | ------------------------ |
| `g:vim_xtract_silent`     | `0`                                 | Disable notifications    |
| `g:vim_xtract_use_notify` | `1`                                 | Use Neovim notifications |
| `g:vim_xtract_var_name`   | `'obj'`                             | Default variable name    |
| `g:vim_xtract_template`   | `"const {\n{{keys}}\n} = {{var}};"` | Default template         |

## Real-World Examples

### React Hooks

```javascript
// Before extraction
const { data, error, loading } = useFetch("/api/user");

// Template: "const { {{keys}} } = use{{var:upper}}();"
// :Xtract → const { data, error, loading } = useFetch();
```

### Error Handling

```javascript
try {
    /* ... */
} catch (err) {
    // Select error object
    // :XtractLog → console.log({ message, code, stack }); // err
}
```

## FAQ

**Q: Can I use this with JSON files?**  
A: Yes! Add to your ftplugin:

```vim
autocmd FileType json command! Xtract :call ExtractObjectKeys()
```

**Q: How to handle nested objects?**  
A: Select inner object with `vi{` and extract:

```javascript
config: {
  // vi{ selects this block
  theme: 'dark',
  fontSize: 14
}
```

## Contribution

We welcome contributions! Please see our [contribution guidelines](https://github.com/caesar003/vim-xtract/CONTRIBUTING.md) for details.

## License

MIT © 2025 Caesar Muksid
