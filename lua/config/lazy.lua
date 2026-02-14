-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
    {"ellisonleao/gruvbox.nvim", priority = 1000 , config = true, opts = ...},
    {'nvim-treesitter/nvim-treesitter'},
    {'nvim-lua/plenary.nvim'},
    {'nvim-telescope/telescope.nvim', tag = '0.1.8'},
    {"nvim-tree/nvim-web-devicons", opts = {}},
    {'neoclide/coc.nvim', branch = "release"},
    {'christoomey/vim-tmux-navigator'},
    {'terrortylor/nvim-comment'},
    {'jiangmiao/auto-pairs'},
    {'akinsho/toggleterm.nvim', version = "*", config = true},
    {"tanvirtin/vgit.nvim"},
    {"lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {}},
    {'nvim-lualine/lualine.nvim'},
    {
      "supermaven-inc/supermaven-nvim",
    },
{
  "nickjvandyke/opencode.nvim",
  dependencies = {
    -- Recommended for `ask()` and `select()`.
    -- Required for `snacks` provider.
    ---@module 'snacks' <- Loads `snacks.nvim` types for configuration intellisense.
    { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
  },
  config = function()
    ---@type opencode.Opts
    vim.g.opencode_opts = {
      -- Your configuration, if any — see `lua/opencode/config.lua`, or "goto definition" on the type or field.
    }

    -- Required for `opts.events.reload`.
    vim.o.autoread = true

    -- Recommended/example keymaps.
    vim.keymap.set({ "n", "x" }, "<C-a>", function() require("opencode").ask("@this: ", { submit = true }) end, { desc = "Ask opencode…" })
    vim.keymap.set({ "n", "x" }, "<C-x>", function() require("opencode").select() end,                          { desc = "Execute opencode action…" })
    vim.keymap.set({ "n", "t" }, "<C-.>", function() require("opencode").toggle() end,                          { desc = "Toggle opencode" })

    vim.keymap.set({ "n", "x" }, "go",  function() return require("opencode").operator("@this ") end,        { desc = "Add range to opencode", expr = true })
    vim.keymap.set("n",          "goo", function() return require("opencode").operator("@this ") .. "_" end, { desc = "Add line to opencode", expr = true })

    vim.keymap.set("n", "<S-C-u>", function() require("opencode").command("session.half.page.up") end,   { desc = "Scroll opencode up" })
    vim.keymap.set("n", "<S-C-d>", function() require("opencode").command("session.half.page.down") end, { desc = "Scroll opencode down" })

    -- You may want these if you use the opinionated `<C-a>` and `<C-x>` keymaps above — otherwise consider `<leader>o…` (and remove terminal mode from the `toggle` keymap).
    vim.keymap.set("n", "+", "<C-a>", { desc = "Increment under cursor", noremap = true })
    vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement under cursor", noremap = true })
  end,
},
{
  "yetone/avante.nvim",
  build = vim.fn.has("win32") ~= 0
      and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
      or "make",
  event = "VeryLazy",
  version = false,
  ---@module 'avante'
  ---@type avante.Config
  opts = {
    provider = "deepseek",
    instructions_file = "avante.md",
    -- Performance optimizations
    max_concurrent_requests = 2, -- Reduced from 3 to 2 for better resource management
    request_timeout = 25000, -- Reduced from 30s to 25s for faster timeouts
    cache_enabled = true,
    cache_ttl = 1800, -- Reduced from 1 hour to 30 minutes for fresher responses
    cache_max_size = 100, -- Limit cache size to prevent memory bloat
    -- UI optimizations
    show_loading_indicator = true,
    loading_indicator_delay = 300, -- Reduced from 500ms for faster UI response
    -- Provider configuration
    providers = {
      deepseek = {
        __inherited_from = "openai",
        api_key_name = "DEEPSEEK_API_KEY",
        endpoint = "https://api.deepseek.com",
        model = "deepseek-coder",
        -- Performance settings for DeepSeek
        max_tokens = 1024, -- Reduced from 2048 for faster responses
        top_p = 0.9, -- Slightly reduced for faster generation
        frequency_penalty = 0,
        presence_penalty = 0,
        -- Stream responses for better perceived performance
        stream = true,
        extra_request_body = {
            temperature = 0.1,
        }
      },
    },
    -- Command optimizations
    commands = {
      default_timeout = 25000, -- Reduced from 30s to 25s
      enable_autocomplete = true,
      debounce_ms = 150, -- Faster command triggering
    },
    -- File selector optimization
    file_selector = {
      provider = "telescope", -- Use telescope for better performance
      debounce_ms = 200, -- Reduced from 300ms for faster file selection
    },
    -- Input provider optimization
    input = {
      provider = "dressing",
      debounce_ms = 150, -- Reduced from 200ms for faster input
    },
    -- Additional performance settings
    enable_performance_mode = true,
    disable_heavy_features = {
      "syntax_highlighting", -- Disable syntax highlighting for faster rendering
      "complex_animations", -- Disable complex animations
      "token_counting", -- Disable token counting for better performance
    },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    -- Performance-optimized dependencies
    "echasnovski/mini.pick", -- Fast file selector
    "nvim-telescope/telescope.nvim", -- Fast file navigation
    "hrsh7th/nvim-cmp", -- Autocompletion
    -- Remove slower dependencies for better performance
    -- "ibhagwan/fzf-lua", -- Removed: telescope is faster
    "stevearc/dressing.nvim", -- Optimized input UI
    -- "folke/snacks.nvim", -- Removed: dressing is sufficient
    "nvim-tree/nvim-web-devicons",
    -- "zbirenbaum/copilot.lua", -- Removed: conflicts with Avante
    {
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          use_absolute_path = true,
        },
      },
    },
    {
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
  },
}
  
})
