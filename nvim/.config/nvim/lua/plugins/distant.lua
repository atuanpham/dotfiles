return {
    "chipsenkbeil/distant.nvim",
    branch = "v0.3",
    config = function()
        require("distant"):setup()
    end,
    keys = {
        {
            "<leader>rc",
            function()
                -- Prompt for connection details
                local host = vim.fn.input("Host (e.g., localhost): ", "localhost")
                if host == "" then return end

                local port = vim.fn.input("Port: ", "2222")
                if port == "" then return end

                local user = vim.fn.input("User: ", vim.fn.getenv("USER") or "")
                if user == "" then return end

                local destination = string.format("ssh://%s@%s:%s", user, host, port)

                -- Use the CLI method via shell command
                vim.cmd("DistantConnect " .. destination)
            end,
            desc = "Connect to remote via distant",
        },
        {
            "<leader>ro",
            function()
                local path = vim.fn.input("Remote path: ", "~/", "file")
                if path == "" then return end

                -- Change directory to the remote path
                vim.cmd("DistantOpen " .. path)

                -- Wait a moment for the connection to establish, then open Neo-tree
                vim.defer_fn(function()
                    vim.cmd("Neotree filesystem")
                end, 500)
            end,
            desc = "Open remote directory in Neo-tree",
        },
        {
            "<leader>rs",
            "<cmd>DistantSessionInfo<cr>",
            desc = "Show distant session info",
        },
    },
}
