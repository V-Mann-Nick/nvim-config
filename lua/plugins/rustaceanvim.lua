return {
    "mrcjkb/rustaceanvim",
    lazy = false,
    config = function()
        vim.g.rustaceanvim = {
            server = {
                default_settings = {
                    ["rust-analyzer"] = {
                        checkOnSave = {
                            command = "clippy",
                        },
                        semanticHighlighting = {
                            -- So that SQL injections are highlighted
                            strings = {
                                enable = false,
                            },
                        },
                    },
                },
            },
        }
    end,
}
