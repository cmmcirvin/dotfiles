local plugin = {'stevearc/aerial.nvim'}

function plugin.config()
  require("aerial").setup({
    manage_folds = true,
    filter_knd = false,
      filter_kind = {
        "Class",
        "Constructor",
        "Function",
        "Method",
        "Module",
      },
    on_attach = function(bufnr)
      vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
      vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
    end,
    nav = {
      border = "solid",
      win_opts = {
        cursorline=false,
        winblend=0,
      },
      max_width = 0.8,
      autojump = true,
      keymaps = {
        ["<ESC>"] = "actions.close",
        ["q"] = "actions.jump",
        ["v"] = "actions.jump_vsplit",
        ["s"] = "actions.jump_split",
      },
      override = function(conf, source_winid)
        return { width = "15" }
      end,
    }
  })
  vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle float<CR>")
  vim.keymap.set("n", "<leader>n", "<cmd>AerialNavToggle<CR>")
end

return plugin
