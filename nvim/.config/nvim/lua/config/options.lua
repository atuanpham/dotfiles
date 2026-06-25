vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt

opt.colorcolumn = "100"

opt.number = true
opt.relativenumber = true
opt.mouse = "a"
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false
opt.wrap = false
opt.breakindent = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.termguicolors = true
opt.signcolumn = "yes"
opt.updatetime = 250
opt.timeoutlen = 300
opt.splitright = true
opt.splitbelow = true
opt.undofile = true
opt.scrolloff = 8

-- Enable autoread option
vim.opt.autoread = true

-- Set up autocommands to check for changes when focus is gained or buffer entered
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
  command = "if mode() != 'c' | checktime | endif",
  pattern = "*",
})

vim.cmd [[syn on]]
vim.g.show_whitespace = 1
if vim.g.show_whitespace then
  vim.opt.list = true
  vim.opt.listchars = { tab = '→ ', leadmultispace = '·', trail = '·' }
  vim.cmd [[highlight Whitespace ctermfg=darkgray guifg=#555555]]
end

-- Disable virtual_text by default
vim.diagnostic.config({ virtual_text = false })
vim.keymap.set('n', '<leader>d', function()
  vim.diagnostic.open_float(nil, {
    scope = 'line',
    wrap = true,
    max_width = 80,
    border = 'rounded',
    focusable = false,
    source = 'always',   -- shows which LSP reported it
  })
end)

-- Terminal
if vim.fn.has("win32") == 1 then
  vim.o.shell = "bash.exe"
  vim.o.shellcmdflag = "-c"
end

-- Keymaps
vim.keymap.set(
  'n',
  '<leader>vt',
  [[<cmd>vsplit | term<cr>A]],
  { desc = 'Open terminal in vertical split' }
)
vim.keymap.set(
  'n',
  '<leader>ht',
  [[<cmd>split | term<cr>A]],
  { desc = 'Open terminal in horizontal split' }
)
vim.keymap.set(
  't',
  'jk',
  '<C-\\><C-n>',
  { desc = 'Use jk to enter in terminal normal mode' }
)

vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

vim.keymap.set("n", "<S-Tab>", "<C-w>p")
vim.keymap.set("n", "<Tab>", "<C-w>w")

-- Resize with Shift + Arrows
vim.keymap.set('n', '<S-Left>', ':vertical resize -2<CR>', { silent = true })
vim.keymap.set('n', '<S-Right>', ':vertical resize +2<CR>', { silent = true })
vim.keymap.set('n', '<S-Up>', ':resize +2<CR>', { silent = true })
vim.keymap.set('n', '<S-Down>', ':resize -2<CR>', { silent = true })

-- File type configs
vim.filetype.add({
  extension = {
    avsc = 'json',
  },
})

