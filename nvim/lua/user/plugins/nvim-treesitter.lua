return {
	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPre", "BufNewFile" },
		build = ":TSUpdate",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
			"windwp/nvim-ts-autotag",
		},
		config = function()
			require("nvim-treesitter.config").setup({
				highlight = { enable = true },
				indent = { enable = true },
				autotag = { enable = true },
			})

			-- Install parsers if missing
			local parsers = {
				"python",
				"json",
				"javascript",
				"typescript",
				"tsx",
				"yaml",
				"html",
				"css",
				"prisma",
				"markdown",
				"markdown_inline",
				"svelte",
				"graphql",
				"bash",
				"lua",
				"vim",
				"dockerfile",
				"gitignore",
				"query",
			}
			vim.api.nvim_create_autocmd("User", {
				pattern = "LazyDone",
				once = true,
				callback = function()
					local installed = {}
					for _, p in ipairs(vim.api.nvim_get_runtime_file("parser/*.so", true)) do
						installed[vim.fn.fnamemodify(p, ":t:r")] = true
					end
					local to_install = {}
					for _, lang in ipairs(parsers) do
						if not installed[lang] then
							table.insert(to_install, lang)
						end
					end
					if #to_install > 0 then
						vim.cmd("TSInstall " .. table.concat(to_install, " "))
					end
				end,
			})

			-- enable nvim-ts-context-commentstring without the deprecated module
			require("ts_context_commentstring").setup({
				enable = true,
				enable_autocmd = false,
			})

			-- Set the global variable to skip the deprecated module
			vim.g.skip_ts_context_commentstring_module = true
		end,
	},
}
