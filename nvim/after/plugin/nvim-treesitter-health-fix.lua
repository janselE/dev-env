-- Upstream bug fix: nvim-treesitter health check normalizes rtp entries but not
-- installdir, causing a false "not in runtimepath" error (trailing slash mismatch).
-- Fixed here via after/plugin so the plugin files stay unmodified for lazy updates.
local ok, health = pcall(require, "nvim-treesitter.health")
if not ok then return end

local orig = health.check
health.check = function()
  local orig_list_contains = vim.list_contains
  vim.list_contains = function(t, val)
    return orig_list_contains(t, vim.fs.normalize(val))
  end
  local result = orig()
  vim.list_contains = orig_list_contains
  return result
end
