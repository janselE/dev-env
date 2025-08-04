vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

-- general keymaps

keymap.set("i", "jk", "<ESC>")
keymap.set("n", "<leader>nh", ":nohl<CR>")

-- increase and decrease numbers
keymap.set("n", "<leader>+", "<C-a>")
keymap.set("n", "<leader>-", "<C-x>")

-- split management
keymap.set("n", "vv", "<C-w>v") -- split vertically
keymap.set("n", "vh", "<C-w>s") -- split horizontally
keymap.set("n", "<leader>se", "<C-w>=") -- make split windows equal width
keymap.set("n", "<leader>sx", ":close<CR>") -- close current split

-- tab management
keymap.set("n", "<leader>to", ":tabnew<CR>") -- opens a new tab
keymap.set("n", "<leader>tx", ":tabclose<CR>") -- close the current tab
keymap.set("n", "<leader>tn", ":tabn<CR>") -- move to the next tab
keymap.set("n", "<leader>tp", ":tabp<CR>") -- move to the previous tab

-- plugins
keymap.set("n", "<leader>gg", ":LazyGit<CR>") -- move to the previous tab
