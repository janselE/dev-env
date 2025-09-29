return {
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {
    -- optional: tweak the labels and search mode
    labels = "asdfghjklqwertyuiopzxcvbnm", -- similar feel to Hop
    search = {
      multi_window = false,
      forward = true,
      wrap = true,
      mode = "exact",
    },
    jump = {
      nohlsearch = true,
      autojump = true,
    },
  },
  keys = {
    -- behave like hop.nvim’s anywhere jump
    { "<leader>jk", mode = { "n", "x", "o" },
      function() require("flash").jump() end,
      desc = "Flash Jump Anywhere"
    },

    -- optional extras if you want
    { "<leader>s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
    { "<leader>S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    { "<leader>r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
    { "<leader>R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
  },
}

