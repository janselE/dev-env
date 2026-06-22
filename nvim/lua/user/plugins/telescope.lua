return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")

		telescope.setup({
			defaults = {
				path_display = { "smart" },
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous, -- move to prev result
						["<C-j>"] = actions.move_selection_next, -- move to next result
						["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
					},
				},
			},
		})

		telescope.load_extension("fzf")

		-- Patch for Neovim 0.12+: ft_to_lang and nvim-treesitter.configs were removed.
		-- Remove this once telescope ships a 0.12-compatible release.
		local preview_utils = require("telescope.previewers.utils")
		preview_utils.ts_highlighter = function(bufnr, ft)
			local get_lang = vim.treesitter.language.get_lang
			local lang = get_lang and get_lang(ft) or ft
			if not lang then return false end
			return pcall(vim.treesitter.start, bufnr, lang)
		end

		-- Patch for Neovim 0.12+: make_position_params now strictly requires position_encoding.
		-- Remove this once telescope ships a 0.12-compatible release.
		local orig_make_position_params = vim.lsp.util.make_position_params
		vim.lsp.util.make_position_params = function(window, offset_encoding)
			return orig_make_position_params(window, offset_encoding or "utf-16")
		end

		-- Patch for Neovim 0.12+: jump_to_location was removed; use show_document instead.
		-- Remove this once telescope ships a 0.12-compatible release.
		if not vim.lsp.util.jump_to_location then
			vim.lsp.util.jump_to_location = function(location, offset_encoding, reuse_win)
				return vim.lsp.util.show_document(location, offset_encoding, { reuse_win = reuse_win, focus = true })
			end
		end

		-- set keymaps
		local keymap = vim.keymap -- for conciseness

		keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
		keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
		keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
		keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
	end,
}
