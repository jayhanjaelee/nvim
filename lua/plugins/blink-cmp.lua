return {
  'saghen/blink.cmp',
  version = '1.*',
  dependencies = {
    'L3MON4D3/LuaSnip',
  },

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = {
      preset = 'default',
      -- 기본 키맵:
      -- <C-space>: 자동완성 메뉴 열기
      -- <C-e>: 메뉴 닫기
      -- <C-y>: 선택 확정
      -- <C-n>/<C-p> 또는 <Up>/<Down>: 이전/다음 항목
      -- <C-b>/<C-f>: 문서 스크롤
      -- <Tab>/<S-Tab>: 스니펫 점프

      -- Tab으로 자동완성 선택
      ['<Tab>'] = { 'select_and_accept', 'snippet_forward', 'fallback' },
      ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
    },

    appearance = {
      nerd_font_variant = 'mono',
    },

    completion = {
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
      },
      menu = {
        draw = {
          columns = {
            { "kind_icon" },
            { "label",             "label_description", gap = 1 },
            { "kind",              gap = 1 },
            { "label_description", gap = 1 },
            { "source_name",       gap = 1 },
          },
          components = {
            kind_icon = {
              ellipsis = false,
              width = { fill = true },
              text = function(ctx)
                local kind_icons = {
                  Text = '󰉿',
                  Method = '󰊕',
                  Function = '󰊕',
                  Constructor = '󰒓',
                  Field = '󰜢',
                  Variable = '󰆦',
                  Property = '󰖷',
                  Class = '󱡠',
                  Interface = '󱡠',
                  Struct = '󱡠',
                  Module = '󰅩',
                  Unit = '󰪚',
                  Value = '󰦨',
                  Enum = '󰦨',
                  EnumMember = '󰦨',
                  Keyword = '󰻾',
                  Constant = '󰏿',
                  Snippet = '󱄽',
                  Color = '󰏘',
                  File = '󰈔',
                  Reference = '󰬲',
                  Folder = '󰉋',
                  Event = '󱐋',
                  Operator = '󰪚',
                  TypeParameter = '󰬛',
                }

                local icon = kind_icons[ctx.kind]
                if icon == nil then
                  icon = ctx.kind_icon
                end
                return icon
              end,
            },
          },
        },
      },
    },

    snippets = {
      preset = 'luasnip',
    },

    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
    },

    fuzzy = {
      implementation = 'prefer_rust_with_warning',
    },

    cmdline = {
      completion = {
        menu = {
          draw = {
            columns = {
              { "label" },
            },
          },
        },
      },
    },

  },

  opts_extend = { 'sources.default' },
}
