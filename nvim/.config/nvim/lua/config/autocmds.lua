local autocmd = vim.api.nvim_create_autocmd

autocmd("FileType", {
  pattern = "lua",
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true
  end,
})

-- remove whitespace when buffer is written
local strip_ws = vim.api.nvim_create_augroup("StripTrailingWhitespace", { clear = true })

autocmd({ "BufWritePre" }, {
  group = strip_ws,
  pattern = "*",
  command = [[%s/\s\+$//e]],
})
