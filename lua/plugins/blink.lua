-- Autocompletion
return {
    "saghen/blink.cmp",
    version = "1.*",
    event = "VimEnter",
    dependencies = {
        -- Snippet Engine
        {
            "L3MON4D3/LuaSnip",
            build = (function()
                -- Build Step is needed for regex support in snippets.
                -- This step is not supported in many windows environments.
                -- Remove the below condition to re-enable on windows.
                if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
                    return
                end
                return "make install_jsregexp"
            end)(),
            dependencies = {
                -- `friendly-snippets` contains a variety of premade snippets.
                --    See the README about individual language/framework/plugin snippets:
                --    https://github.com/rafamadriz/friendly-snippets
                -- {
                --   'rafamadriz/friendly-snippets',
                --   config = function()
                --     require('luasnip.loaders.from_vscode').lazy_load()
                --   end,
                -- },
            },
            opts = {},
        },
        "folke/lazydev.nvim",
        { "xzbdmw/colorful-menu.nvim", opts = {} },
        "moyiz/blink-emoji.nvim",
        {
            "fang2hou/blink-copilot",
            dependencies = {
                {
                    "github/copilot.vim",
                    cmd = "Copilot",
                    event = "BufWinEnter",
                    init = function()
                        vim.g.copilot_no_maps = true
                    end,
                    config = function()
                        -- Block the normal Copilot suggestions
                        local group = vim.api.nvim_create_augroup("github_copilot", { clear = true })
                        vim.api.nvim_create_autocmd({ "FileType", "BufUnload" }, {
                            group = group,
                            callback = function(args)
                                vim.fn["copilot#On" .. args.event]()
                            end,
                        })
                        vim.fn["copilot#OnFileType"]()

                        vim.cmd([[let g:copilot_enabled = v:false]])
                        vim.keymap.set("n", "<leader>tc", function()
                            vim.cmd([[
                                    if exists("g:copilot_enabled") && g:copilot_enabled
                                        let g:copilot_enabled = v:false
                                        Copilot disable
                                        echo "Copilot disabled"
                                    else
                                        let g:copilot_enabled = v:true
                                        Copilot enable
                                        echo "Copilot enabled"
                                    endif
                                ]])
                        end, { desc = "[T]oggle [C]opilot" })
                    end,
                },
            },
            opts = {
                max_completions = 2,
            },
        },
    },
    --- @module 'blink.cmp'
    --- @type blink.cmp.Config
    opts = {
        keymap = {
            preset = "default",

            ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
            ["<C-e>"] = { "hide" },
            ["<Enter>"] = { "select_and_accept", "fallback" },

            ["<Up>"] = { "select_prev", "fallback" },
            ["<Down>"] = { "select_next", "fallback" },

            ["<C-p>"] = { "scroll_documentation_up", "fallback" },
            ["<C-n>"] = { "scroll_documentation_down", "fallback" },

            ["<Tab>"] = { "select_next", "fallback" },
            ["<S-Tab>"] = { "select_prev", "fallback" },

            ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },

            -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
            --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
        },

        appearance = {
            -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
            -- Adjusts spacing to ensure icons are aligned
            nerd_font_variant = "mono",
        },

        completion = {
            documentation = { auto_show = true, auto_show_delay_ms = 0 },
            list = {
                selection = {
                    preselect = false,
                },
            },
            menu = {
                draw = {
                    -- We don't need label_description now because label and label_description are already
                    -- combined together in label by colorful-menu.nvim.
                    columns = { { "kind_icon" }, { "label", gap = 1 } },
                    components = {
                        label = {
                            text = function(ctx)
                                return require("colorful-menu").blink_components_text(ctx)
                            end,
                            highlight = function(ctx)
                                return require("colorful-menu").blink_components_highlight(ctx)
                            end,
                        },
                    },
                },
            },
        },

        sources = {
            default = {
                "copilot",
                "lsp",
                "path",
                "lazydev",
                "emoji",
                "buffer",
            },
            providers = {
                lsp = {
                    async = true,
                },
                lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
                emoji = {
                    module = "blink-emoji",
                    name = "Emoji",
                    score_offset = 15, -- Tune by preference
                    opts = {
                        insert = true, -- Insert emoji (default) or complete its name
                        ---@type string|table|fun():table
                        trigger = function()
                            return { ":" }
                        end,
                    },
                },
                copilot = {
                    name = "copilot",
                    module = "blink-copilot",
                    score_offset = 100,
                    async = true,
                },
            },
        },

        snippets = { preset = "luasnip" },

        -- Blink.cmp includes an optional, recommended rust fuzzy matcher,
        -- which automatically downloads a prebuilt binary when enabled.
        --
        -- By default, we use the Lua implementation instead, but you may enable
        -- the rust implementation via `'prefer_rust_with_warning'`
        --
        -- See :h blink-cmp-config-fuzzy for more information
        fuzzy = { implementation = "prefer_rust_with_warning" },

        -- Shows a signature help window while you type arguments for a function
        signature = { enabled = true },
    },
}
