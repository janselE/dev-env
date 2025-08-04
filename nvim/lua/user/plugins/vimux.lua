return {
	"preservim/vimux",
	vim.keymap.set("n", "<leader>vp", ":VimuxPromptCommand<cr>"),
	vim.keymap.set("n", "<leader>vl", ":VimuxRunLastCommand<cr>"),
	vim.keymap.set("n", "<leader>vi", ":VimuxInspectRunner<cr>"),
	vim.keymap.set("n", "<leader>vz", ":VimuxZoomRunner<cr>"),
}
