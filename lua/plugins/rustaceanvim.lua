return {
    "mrcjkb/rustaceanvim",
    lazy = false,
    config = function()
        -- Read the environment variable `ENABLE_XWIN` to determine the check command to run
        -- when saving files in Rust.
        local check_override_command = os.getenv("ENABLE_XWIN")
                and {
                    "cargo",
                    "xwin",
                    "clippy",
                    "-p",
                    "nelly-connector",
                    "--target",
                    "x86_64-pc-windows-msvc",
                    "--message-format=json",
                }
            or nil

        --- @module 'rustaceanvim'
        --- @type rustaceanvim.Opts
        vim.g.rustaceanvim = {
            server = {
                default_settings = {
                    ["rust-analyzer"] = {
                        check = {
                            overrideCommand = check_override_command,
                            command = "clippy",
                            workspace = false,
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

        local map = function(keys, args, desc, mode)
            mode = mode or "n"
            local func = function()
                vim.cmd.RustLsp(args)
            end
            vim.keymap.set(mode, keys, func, { desc = "RustLSP: " .. desc })
        end

        map("<leader>grd", "openDocs", "[G]oto [R]ust [D]ocs")
        map("<leader>grem", "expandMacro", "[G]oto [R]ust [E]xpand [M]acro")
        map("<leader>gree", "explainError", "[G]oto [R]ust [E]xplain [E]rror")
        map("<leader>grmd", { "moveItem", "down" }, "[G]oto [R]ust [M]ove [D]own")
        map("<leader>grmu", { "moveItem", "up" }, "[G]oto [R]ust [M]ove [U]p")
        map("<leader>grrd", "renderDiagnostic", "[G]oto [R]ust [R]ender [D]iagnostic")
        map("<leader>grc", "openCargo", "[G]oto [R]ust Open [C]argo")
    end,
}
