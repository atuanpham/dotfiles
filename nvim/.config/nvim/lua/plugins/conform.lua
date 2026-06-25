return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  config = function()
    require("conform").setup({

      formatters_by_ft = {
        python = { "ruff_organize_imports", "ruff_format" },
        c = { "clang-format" },
        cpp = { "clang-format" },
      },

      format_after_save = {
        timeout_ms = 5000,
        lsp_fallback = false,
      },

    })

    vim.keymap.set("n", "<leader>=", function()
      require("conform").format({ async = false, lsp_fallback = false })
    end, { desc = "Format file" })
  end,
}
