-- Nice status line
return {
    "nvim-lualine/lualine.nvim",
    opts = {
        options = {
            extensions = { "fzf", "nvim-tree", "fugitive" },
            globalstatus = true,
            section_separators = { left = "", right = "" },
            component_separators = { left = "|", right = "|" },
        },
    },
}
