require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'gruvbox-material',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {
        'NvimTree',
        'dashboard',
        'packer',
        'TelescopePrompt',
        'Trouble',
        'alpha',
        'lazy'
      },
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    always_show_tabline = false, -- Changed to false for better performance
    globalstatus = true, -- Enable global status line
    refresh = {
      statusline = 500, -- Increased refresh rate for better performance
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {
      'branch',
      {
        'diff',
        symbols = { added = ' ', modified = ' ', removed = ' ' },
        diff_color = {
          added = { fg = '#98c379' },
          modified = { fg = '#e5c07b' },
          removed = { fg = '#e06c75' },
        }
      },
      {
        'diagnostics',
        symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' },
        diagnostics_color = {
          error = { fg = '#e06c75' },
          warn = { fg = '#e5c07b' },
          info = { fg = '#61afef' },
          hint = { fg = '#9bb048' },
        }
      }
    },
    lualine_c = {
      {
        'filename',
        path = 0, -- Show relative path
        symbols = {
          modified = ' ●',
          readonly = ' ',
          unnamed = ' [No Name]',
          newfile = ' [New]',
        }
      }
    },
    lualine_x = {
      'fileformat',
      'filetype',
      {
        'filesize',
        fmt = function(str)
          local size = tonumber(str)
          if size then
            if size < 1024 then
              return string.format('%.0f B', size)
            elseif size < 1024 * 1024 then
              return string.format('%.1f KB', size / 1024)
            else
              return string.format('%.1f MB', size / (1024 * 1024))
            end
          end
          return str
        end
      }
    },
    lualine_y = {
      'progress',
      {
        'hostname',
        fmt = function(str)
          return string.sub(str, 1, 8) -- Limit hostname length
        end
      }
    },
    lualine_z = {
      'location',
      {
        function()
          return os.date('%H:%M')
        end,
        color = { fg = '#1f1f1f', gui = 'bold' },
      }
    }
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {
      {
        'filename',
        path = 1,
        symbols = {
          modified = ' ●',
          readonly = ' ',
          unnamed = ' [No Name]',
        }
      }
    },
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {
    lualine_a = {
      {
        'tabs',
        mode = 2,
        tabs_color = {
          active = 'lualine_a_normal',
          inactive = 'lualine_a_inactive',
        },
      }
    },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {
      {
        'buffers',
        mode = 4,
        buffers_color = {
          active = 'lualine_z_normal',
          inactive = 'lualine_z_inactive',
        },
        symbols = {
          modified = ' ●',
          alternate_file = '',
          directory = '',
        },
      }
    }
  },
  winbar = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {
      {
        'filename',
        path = 1,
        symbols = {
          modified = ' ●',
          readonly = ' ',
        }
      }
    },
    lualine_x = {},
    lualine_y = {},
    lualine_z = {}
  },
  inactive_winbar = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {
      {
        'filename',
        path = 1,
        symbols = {
          modified = ' ●',
          readonly = ' ',
        }
      }
    },
    lualine_x = {},
    lualine_y = {},
    lualine_z = {}
  },
  extensions = {
    'nvim-tree',
    'toggleterm',
    'fugitive',
    'quickfix',
    'symbols-outline'
  }
}
