return {
  "linux-cultist/venv-selector.nvim",
  dependencies = {
    "neovim/nvim-lspconfig",
    "nvim-telescope/telescope.nvim",
  },
  opts = {
    name = { "venv", ".venv", "env", ".env" },
  },
  keys = {
    { "<leader>v", "<cmd>VenvSelect<cr>", desc = "Select VirtualEnv" },
  },
}
