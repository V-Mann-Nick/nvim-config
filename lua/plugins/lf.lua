-- Neovim integraiton of the lf file manager
return {
    "lmburns/lf.nvim",
    dependencies = {
        {
            "akinsho/toggleterm.nvim",
            opts = {
                size = 20,
                shade_terminals = true,
                shading_factor = 1,
                shell = "zsh",
                direction = "float",
            },
        },
    },
    config = function()
        require("lf").setup({
            winblend = 0,
            border = "rounded",
            default_file_manager = true,
            highlights = {
                NormalFloat = { link = "Normal" },
            },
        })
        vim.keymap.set("n", "<leader>r", "<Cmd>Lf<CR>", { nowait = true, desc = "[R]anger it was once upon a time" })
    end,
}
