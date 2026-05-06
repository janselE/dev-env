return {
	"nvim-treesitter/nvim-treesitter-textobjects",
	lazy = true,
	config = function()
		local select = require("nvim-treesitter-textobjects.select")
		local swap = require("nvim-treesitter-textobjects.swap")
		local move = require("nvim-treesitter-textobjects.move")

		require("nvim-treesitter-textobjects").setup({
			select = {
				lookahead = true,
			},
			move = {
				set_jumps = true,
			},
		})

		-- Textobject selection keymaps
		local select_maps = {
			["a="] = { query = "@assignment.outer", desc = "Select outer part of an assignment" },
			["i="] = { query = "@assignment.inner", desc = "Select inner part of an assignment" },
			["l="] = { query = "@assignment.lhs", desc = "Select left hand side of an assignment" },
			["r="] = { query = "@assignment.rhs", desc = "Select right hand side of an assignment" },
			["a:"] = { query = "@property.outer", desc = "Select outer part of an object property" },
			["i:"] = { query = "@property.inner", desc = "Select inner part of an object property" },
			["l:"] = { query = "@property.lhs", desc = "Select left part of an object property" },
			["r:"] = { query = "@property.rhs", desc = "Select right part of an object property" },
			["aa"] = { query = "@parameter.outer", desc = "Select outer part of a parameter/argument" },
			["ia"] = { query = "@parameter.inner", desc = "Select inner part of a parameter/argument" },
			["ai"] = { query = "@conditional.outer", desc = "Select outer part of a conditional" },
			["ii"] = { query = "@conditional.inner", desc = "Select inner part of a conditional" },
			["al"] = { query = "@loop.outer", desc = "Select outer part of a loop" },
			["il"] = { query = "@loop.inner", desc = "Select inner part of a loop" },
			["af"] = { query = "@call.outer", desc = "Select outer part of a function call" },
			["if"] = { query = "@call.inner", desc = "Select inner part of a function call" },
			["am"] = { query = "@function.outer", desc = "Select outer part of a method/function definition" },
			["im"] = { query = "@function.inner", desc = "Select inner part of a method/function definition" },
			["ac"] = { query = "@class.outer", desc = "Select outer part of a class" },
			["ic"] = { query = "@class.inner", desc = "Select inner part of a class" },
		}

		for key, opts in pairs(select_maps) do
			vim.keymap.set({ "x", "o" }, key, function()
				select.select_textobject(opts.query)
			end, { desc = opts.desc })
		end

		-- Swap keymaps
		vim.keymap.set("n", "<leader>na", function()
			swap.swap_next("@parameter.inner")
		end, { desc = "Swap parameter with next" })
		vim.keymap.set("n", "<leader>n:", function()
			swap.swap_next("@property.outer")
		end, { desc = "Swap object property with next" })
		vim.keymap.set("n", "<leader>nm", function()
			swap.swap_next("@function.outer")
		end, { desc = "Swap function with next" })
		vim.keymap.set("n", "<leader>pa", function()
			swap.swap_previous("@parameter.inner")
		end, { desc = "Swap parameter with previous" })
		vim.keymap.set("n", "<leader>p:", function()
			swap.swap_previous("@property.outer")
		end, { desc = "Swap object property with previous" })
		vim.keymap.set("n", "<leader>pm", function()
			swap.swap_previous("@function.outer")
		end, { desc = "Swap function with previous" })

		-- Move keymaps
		local move_maps = {
			["]f"] = { fn = "goto_next_start", query = "@call.outer", desc = "Next function call start" },
			["]m"] = { fn = "goto_next_start", query = "@function.outer", desc = "Next method/function def start" },
			["]c"] = { fn = "goto_next_start", query = "@class.outer", desc = "Next class start" },
			["]i"] = { fn = "goto_next_start", query = "@conditional.outer", desc = "Next conditional start" },
			["]l"] = { fn = "goto_next_start", query = "@loop.outer", desc = "Next loop start" },
			["]s"] = { fn = "goto_next_start", query = "@scope", group = "locals", desc = "Next scope" },
			["]z"] = { fn = "goto_next_start", query = "@fold", group = "folds", desc = "Next fold" },
			["]F"] = { fn = "goto_next_end", query = "@call.outer", desc = "Next function call end" },
			["]M"] = { fn = "goto_next_end", query = "@function.outer", desc = "Next method/function def end" },
			["]C"] = { fn = "goto_next_end", query = "@class.outer", desc = "Next class end" },
			["]I"] = { fn = "goto_next_end", query = "@conditional.outer", desc = "Next conditional end" },
			["]L"] = { fn = "goto_next_end", query = "@loop.outer", desc = "Next loop end" },
			["[f"] = { fn = "goto_previous_start", query = "@call.outer", desc = "Prev function call start" },
			["[m"] = { fn = "goto_previous_start", query = "@function.outer", desc = "Prev method/function def start" },
			["[c"] = { fn = "goto_previous_start", query = "@class.outer", desc = "Prev class start" },
			["[i"] = { fn = "goto_previous_start", query = "@conditional.outer", desc = "Prev conditional start" },
			["[l"] = { fn = "goto_previous_start", query = "@loop.outer", desc = "Prev loop start" },
			["[F"] = { fn = "goto_previous_end", query = "@call.outer", desc = "Prev function call end" },
			["[M"] = { fn = "goto_previous_end", query = "@function.outer", desc = "Prev method/function def end" },
			["[C"] = { fn = "goto_previous_end", query = "@class.outer", desc = "Prev class end" },
			["[I"] = { fn = "goto_previous_end", query = "@conditional.outer", desc = "Prev conditional end" },
			["[L"] = { fn = "goto_previous_end", query = "@loop.outer", desc = "Prev loop end" },
		}

		for key, opts in pairs(move_maps) do
			vim.keymap.set({ "n", "x", "o" }, key, function()
				move[opts.fn](opts.query, opts.group)
			end, { desc = opts.desc })
		end

		-- f/F/t/T and ;/, are handled natively by Neovim
	end,
}
