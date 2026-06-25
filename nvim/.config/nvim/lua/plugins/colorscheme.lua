-- return {
--   "catppuccin/nvim",
--   name = "catppuccin",
--   priority = 1000,
--   config = function()
--     require("catppuccin").setup({
--       flavour = "mocha",
--       transparent_background = false,
--     })
--     vim.cmd.colorscheme("catppuccin")
--   end,
-- }
return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = {},
  config = function()
    require("tokyonight").setup({
      -- use the night style
      style = "night",
      -- disable italic for functions
      -- styles = {
      --   functions = {}
      -- },
      -- Change the "hint" color to the "orange" color, and make the "error" color bright red
      on_colors = function(colors)
        colors.hint = colors.orange
        colors.error = "#ff0000"
      end
    })
    vim.cmd.colorscheme("tokyonight")
  end,
}
