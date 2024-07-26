-- Plugin managers
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  'rose-pine/neovim',
  'stevearc/aerial.nvim',
  'echasnovski/mini.move',
  'echasnovski/mini.animate',
  {
    "folke/trouble.nvim",
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = "Trouble",
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
  },
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
        require("nvim-surround").setup({})
    end
  },
  'pocco81/auto-save.nvim',
  {
    "kevinhwang91/nvim-ufo",
    enabled = true,
    dependencies = { "kevinhwang91/promise-async" },
    event = "BufRead",
    keys = {
      {
        "zR",
        function()
          require("ufo").openAllFolds()
        end,
      },
      {
        "zM",
        function()
          require("ufo").closeAllFolds()
        end,
      },
      {
        "zp",
        function()
          local winid = require("ufo").peekFoldedLinesUnderCursor()
          if not winid then
            vim.lsp.buf.hover()
          end
        end,
      },
    },
    config = function()
      vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
      vim.o.foldcolumn = "0"
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 100
      vim.o.foldenable = true
      local handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = (" 󰁂 %d "):format(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            -- str width returned from truncate() may less than 2nd argument, need padding
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, { suffix, "MoreMsg" })
        return newVirtText
      end
  
      require("ufo").setup({
        open_fold_hl_timeout = 0,
        fold_virt_text_handler = handler,
      })
    end,
  },
  'lervag/vimtex',
  'rmagatti/auto-session',
  'luckasRanarison/nvim-devdocs',
  {
    'nvim-telescope/telescope.nvim',
    dependencies =
    {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter'
    }
  },
  {
    "folke/flash.nvim",
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "flash" },
      { "f", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "flash treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "remote flash" }
    }
  },
  'nvim-telescope/telescope-file-browser.nvim',
  'dstein64/vim-startuptime',
  'williamboman/mason.nvim',
  'neovim/nvim-lspconfig',
  'williamboman/mason-lspconfig.nvim',
  'mfussenegger/nvim-dap',
  'mfussenegger/nvim-dap-python',
  'neogitorg/neogit',
  'sindrets/diffview.nvim',
  'mbbill/undotree',
  'chentoast/marks.nvim',
  'nvim-lualine/lualine.nvim',
  {
      'goolord/alpha-nvim',
      dependencies = { 'nvim-tree/nvim-web-devicons' },
      config = function ()
          require'alpha'.setup(require'alpha.themes.dashboard'.config)
      end
  },
  {
    "folke/noice.nvim",
    opts={},
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      }
  },
  'rmagatti/goto-preview',
  'sirver/ultisnips',
  {
    'hrsh7th/nvim-cmp',
    dependencies = 
    {
      'quangnguyen30192/cmp-nvim-ultisnips',
    }
  },
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-path',
  'hrsh7th/cmp-nvim-lua',
  'hrsh7th/cmp-nvim-lsp',
  'tzachar/cmp-ai',
})

local map = function(mode, l, r, opts)
  opts = opts or {}
  opts.silent = true
  vim.keymap.set(mode, l, r, opts)
end

local telescope = require("telescope.builtin")

require('mason').setup()

-- Colorschemes

require('rose-pine').setup({
  styles = {
    italic = false,
    transparency = true,
  },
  highlight_groups = {
    Comment = { italic = true },
    Constant = { bold = true },
    Boolean = {bold = true},
  }
})

vim.cmd 'colorscheme rose-pine-moon'

-- Mini
require('mini.move').setup()
require('mini.animate').setup({
    cursor = { enable=true, timing=function(_, n) return 250 / n end, },
    scroll = { enable=false },
    resize = { enable=false },
    open = { enable=false },
    close = { enable=false },
})

-- Flash

require('flash').setup({
    modes = {
        char = { enabled = false, keys = {} }
    }
})

-- Leap

--leap = require('leap')
--vim.keymap.set({'n', 'x', 'o'}, 'f', '<Plug>(leap-forward-to)')
--vim.keymap.set({'n', 'x', 'o'}, 'F', '<Plug>(leap-backward-to)')
--vim.keymap.set({'n', 'x', 'o'}, 't', '<Plug>(leap-forward-till)')
--vim.keymap.set({'n', 'x', 'o'}, 'T', '<Plug>(leap-backward-till)')
--leap.opts.labels = {'e', 'r', 'g', 'v', 'c', 'n', 'm', 'u', 'b', 't', 'y', 's', 'f', 'd'}
--leap.opts.safe_labels = {'e', 'r', 'g', 'v', 'c', 'n', 'm', 'u', 'b', 't', 'y', 's', 'f', 'd'}
--leap.init_highlight(true)

-- Filesystem

-- Telescope File Browser

local select_one_or_multi = function(prompt_bufnr)
  local picker = require('telescope.actions.state').get_current_picker(prompt_bufnr)
  local multi = picker:get_multi_selection()
  if not vim.tbl_isempty(multi) then
    require('telescope.actions').close(prompt_bufnr)
    for _, j in pairs(multi) do
      if j.path ~= nil then
        vim.cmd(string.format('%s %s', 'edit', j.path))
      end
    end
  else
    require('telescope.actions').select_default(prompt_bufnr)
  end
end

local fb_actions = require('telescope').extensions.file_browser.actions
require('telescope').setup {
  defaults = {
    layout_strategy = 'flex',
    mappings = {
      i = {
        ['<S-CR>'] = select_one_or_multi,
      },
      n = {
        ['<S-CR>'] = select_one_or_multi,
        ['l'] = require('telescope.actions').toggle_selection
      }
    },
  }
}

-- Session manager

require("auto-session").setup({
    auto_session_suppress_dirs = { "~/", "~/Documents", "~/Downloads", "/" },
    auto_session_create_enabled = false,
})

-- Bufferline

--require('bufferline').setup()

-- Lualine

require('lualine').setup ({
  options = {
--    component_separators = { left = '', right = '' },
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
  },
  tabline = {
    lualine_a =
    {
        {
            'branch'
        }
    },
    lualine_b =
    {
        {
            'buffers',
            use_mode_colors = true,
            max_length = vim.o.columns,
            
        }
    },
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z ={},
  },
  sections = {}
})

-- Commands
--vim.cmd 'set number'
--vim.cmd 'set rnu'

-- Treesitter
require('nvim-treesitter.configs').setup {
  highlight = {
    enable = true
  },
  indent = {
    enable = false
  }
}

vim.cmd 'syntax enable'


-- Python Debugger
local dap = require('dap') 
dap.defaults.switchbuf = 'v'

vim.keymap.set('n', '<F5>', function() dap.continue() end)
vim.keymap.set('n', '<F8>', function() dap.close() end)
vim.keymap.set('n', '<F9>', function() dap.step_into() end)
vim.keymap.set('n', '<F10>', function() dap.step_over() end)
vim.keymap.set('n', '<F11>', function() dap.step_out() end)
vim.keymap.set('n', '<Leader>b', function() dap.toggle_breakpoint() end)
vim.keymap.set('n', '<Leader>B', function() dap.set_breakpoint() end)
vim.keymap.set('n', '<Leader>lp', function() dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
vim.keymap.set('n', '<Leader>dr', function() dap.repl.open() end)
vim.keymap.set('n', '<Leader>dl', function() dap.run_last() end)
vim.keymap.set({'n', 'v'}, '<Leader>dh', function()
  require('dap.ui.widgets').hover()
end)
vim.keymap.set({'n', 'v'}, '<Leader>dp', function()
  require('dap.ui.widgets').preview()
end)
vim.keymap.set('n', '<Leader>df', function()
  local widgets = require('dap.ui.widgets')
  widgets.centered_float(widgets.frames)
end)
vim.keymap.set('n', '<Leader>ds', function()
  local widgets = require('dap.ui.widgets')
  local sidebar = widgets.sidebar(widgets.scopes)
  sidebar.open()
end)

require('dap-python').setup('~/.venvs/debugpy/bin/python')
table.insert(require('dap').configurations.python, {
    type = 'python',
    justMyCode = false,
    request = 'launch',
    console='integratedTerminal',
    name = 'Base working directory',
    program = '${file}',
    cwd = './'
})
table.insert(require('dap').configurations.python, {
    type = 'python',
    justMyCode = false,
    request = 'launch',
    console='integratedTerminal',
    name = 'Base working directory with arguments',
    program = '${file}',
    cwd = './',
    args = function()
      local args_string = vim.fn.input('Arguments: ')
      return vim.split(args_string, " +")
    end;
})

--Greeter

local dashboard = require("alpha.themes.dashboard")

-- Set header
dashboard.section.header.val = {
"                                                                      ",
"                                                                      ",
"                                                                      ",
"                                                                      ",
"                                                                      ",
"                                                                      ",
"                                                                      ",
"                                                                      ",
"                                                                      ",
"                                                                      ",
"                                                                      ",
"      ███ █████████████████    █████████████████████  ",
"     ███                ████   █  █                       █ ", 
"    ████████     █████████████████████████",
"   ███████████████████████████████████████",
"  ████████     ████████████████████████ ",
" ████ ███     ██  ██████████████████████  ",
"████   ████████ ████████ ████████████████████   ",
"                                                                      ",
"                                                                      ",
"                                                                      ",
"                                                                      ",
"                                                                      ",
"                                                                      ",
}                                                                      
                                                                       
dashboard.section.buttons.val = {
    dashboard.button("o", "   > Recent" , ":Telescope oldfiles<cr>"),
    dashboard.button("f", "   > Find file", ":Telescope find_files<cr>"),
    dashboard.button("e", "   > Explorer", ":Telescope file_browser<cr>"),
    dashboard.button("g", "   > Grep"   , ":Telescope live_grep<cr>"),
    dashboard.button("b", "   > Buffers" , ":Telescope buffers<cr>"),
    dashboard.button("h", "   > Help", ":Telescope help_tags<cr>")
}

local cmp = require('cmp')
local cmp_ultisnips_mappings = require("cmp_nvim_ultisnips.mappings")
cmp.setup {
    mapping = {
        ["J"] = cmp.mapping(
              function(fallback)
                cmp_ultisnips_mappings.expand_or_jump_forwards(fallback)
              end,
              { "i", "s" }
            ),
        ["K"] = cmp.mapping(
              function(fallback)
                cmp_ultisnips_mappings.jump_backwards(fallback)
              end,
              { "i", "s" }
            ),
        ['L'] = cmp.mapping.scroll_docs(4),
        ['H'] = cmp.mapping.scroll_docs(-4),
        ['<leader>c'] = cmp.mapping(
             cmp.mapping.complete({
               config = {
                 sources = cmp.config.sources({
                   { name = 'cmp_ai' },
                 }),
               },
             }),
             { "i", "s" }
        ),
        ['<S-CR>'] = cmp.mapping.confirm({ select = true }),
        ['<leader>e'] = cmp.mapping.abort(),
    },
    sources = {
        { name = "gh_issues" },
        { name = "nvim_lua" },
        { name = "nvim_lsp" },
        { name = "path" },
        { name = "ultisnips" },
--        { name = "cmp_ai" },
        { name = "buffer", keyword_length = 1},
    },
    snippet = {
    expand = function(args)
            vim.fn["UltiSnips#Anon"](args.body)
    end,
    },
}

local capabilities = require('cmp_nvim_lsp').default_capabilities()

require('lspconfig').pyright.setup {
  capabilities = capabilities,
}

-- local cmp_ai = require('cmp_ai.config')
-- cmp_ai:setup({
--   max_lines = 10,
--   provider = 'HF',
--   notify = true,
--   notify_callback = function(msg)
--     vim.notify(msg)
--   end,
--   run_on_every_keystroke = true,
--   ignored_file_types = {
--   },
-- })

local cmp_ai = require('cmp_ai.config')
cmp_ai:setup({
  max_lines = 10,
  provider = 'Ollama',
  provider_options = {
      model = 'codellama:7b-code',
      options = {
          temperature = 0.2,
          num_predict = 15,
          context = "",
--          stop = {""}
      }
  },
  notify = false,
  run_on_every_keystroke = false,
  ignored_file_types = {
  },
})

-- Aerial

require("aerial").setup({
  -- optionally use on_attach to set keymaps when aerial has attached to a buffer
  on_attach = function(bufnr)
    -- Jump forwards/backwards with '{' and '}'
    vim.keymap.set("n", "[", "<cmd>AerialPrev<CR>", { buffer = bufnr })
    vim.keymap.set("n", "]", "<cmd>AerialNext<CR>", { buffer = bufnr })
  end,
})

vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle!<CR>")

-- UltiSnips

vim.cmd "let g:UltiSnipsExpandTrigger = '<tab>'"
vim.cmd "let g:UltiSnipsJumpForwardTrigger = '<tab>'"
vim.cmd "let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'"

-- Git

-- Neogit

require('neogit').setup({
    integrations = { diffview = true }
})

vim.opt.termguicolors = true

map("n", "<c-l>", ":bn!<CR>")
map("n", "<c-h>", ":bp!<CR>")
map("n", "<c-q>", ":bp<bar>bd! #<CR>")

map("n", "<leader>u", "<cmd>UndotreeToggle<cr>")
map("n", "<leader>t", ":enew<CR>")

map("n", "<leader>fo", telescope.oldfiles)
map("n", "<leader>ff", telescope.find_files)
map("n", "<leader>fg", telescope.live_grep)
map("n", "<leader>fb", telescope.buffers)
map("n", "<leader>fh", telescope.help_tags)
map("n", "<leader>fe", "<cmd>Telescope file_browser<cr>")
map("n", "<leader>fc", "<cmd>Telescope file_browser path=%:p:h<cr>")

map("n", "<Esc>", "<Esc>:noh<return>")

map("n", "<c-j>", ":m .+1<cr>==")
map("n", "<c-k>", ":m .-2<cr>==")
map("i", "<c-j>", "<esc>:m .+1<cr>==gi")
map("i", "<c-k>", "<esc>:m .-2<cr>==gi")
map("v", "<c-j>", ":m '>+1<cr>gv=gv")
map("v", "<c-k>", ":m '<-2<cr>gv=gv")

-- Trouble
--map("n", "<leader>xx", function() require("trouble").toggle() end)
--map("n", "<leader>xw", function() require("trouble").toggle("workspace_diagnostics") end)
--map("n", "<leader>xd", function() require("trouble").toggle("document_diagnostics") end)
--map("n", "<leader>xq", function() require("trouble").toggle("quickfix") end)
--map("n", "<leader>xl", function() require("trouble").toggle("loclist") end)
--map("n", "gR", function() require("trouble").toggle("lsp_references") end)

map("n", "<leader>ss", "<cmd>SessionSave<cr>")

vim.cmd "let g:python3_host_prog = '~/.venvs/debugpy/bin/python'"

vim.cmd "set expandtab shiftwidth=4 softtabstop=4 tabstop=4"

vim.opt.fillchars = { eob = ' ' }

-- Documentation

require("nvim-devdocs").setup({
  float_win = {
    relative = "editor",
    height = vim.api.nvim_win_get_height(0) - 20,
    width = vim.api.nvim_win_get_width(0) - 20,
    border = "rounded",
  },
  previewer_cmd = "glow",
--  cmd_args = { "-s", "dracula", "-w", vim.api.nvim_win_get_width(0) - 20 }
})

map("n", "<leader>dd", ":DevdocsOpenFloat<CR>")

-- lsp-config

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts) -- 'K' again to jump into window
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
  end,
})

-- nvim-ufo

vim.o.foldlevel = 99
--vim.o.foldcolumn = '1'
--vim.o.foldlevelstart = 99
--vim.o.foldenable = true
--
--vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
--vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
--vim.keymap.set('n', 'zp', require('ufo').peekFoldedLinesUnderCursor)
--
--require('ufo').setup({
--    open_fold_hl_timeout = 0,
--    provider_selector = function(bufnr, filetype, buftype)
--        return {'lsp', 'indent'}
--    end
--})

-- marks

require('marks').setup({})

vim.cmd 'nnoremap <Esc> <Esc>:noh<return>'
--vim.cmd 'nnoremap <c-q> :bp<bar>bd #<CR>'

vim.cmd 'set list'
vim.cmd 'set lcs+=space:·'

vim.cmd "let g:vimtex_view_method = 'skim'"
vim.cmd "let g:tex_flavor='latex'"
vim.cmd "let g:vimtex_view_skim_sync = 1"
vim.cmd "let g:vimtex_view_skim_activate = 1"
vim.cmd "let g:vimtex_quickfix_mode=0"
vim.cmd "let g:tex_conceal='abdmg'"
vim.cmd "set conceallevel=1"
--vim.cmd "set foldmethod=expr"
--vim.cmd "set foldexpr=nvim_treesitter#foldexpr()"
--vim.cmd "set nofoldenable"
vim.cmd "set nofixeol"
vim.cmd "set nofixendofline"

map("n", "<space>", "za")
map("v", "<space>", "zf")

vim.cmd "set cursorline"

vim.cmd 'tnoremap <Esc> <C-\\><C-n>'
