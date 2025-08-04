return {
  "bluz71/vim-nightfly-guicolors",
  priority = 1000, -- make sure to load this before other plugins
  config = function()
    -- load the colorscheme
    vim.cmd([[colorscheme nightfly]])
  end,
}
