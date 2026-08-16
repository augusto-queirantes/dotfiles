return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "mason-org/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "saghen/blink.cmp",
    },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      -- LSP servers to run, by lspconfig name.
      -- rails: ruby_lsp (drives .rb and .erb), nodejs/ts/react: vtsls + eslint,
      -- with jsonls/cssls/html covering the rest of a React tree. go: gopls.
      local servers = {
        "lua_ls",
        "ruby_lsp",
        "vtsls",
        "eslint",
        "gopls",
        "jsonls",
        "cssls",
        "html",
      }

      -- Everything mason installs, by mason package name, pinned. One list for
      -- servers and tools alike: mason-lspconfig's ensure_installed cannot pin
      -- a version, mason-tool-installer's can, and an unpinned toolchain drifts
      -- per machine. Bump these deliberately -- `:Mason` shows what is behind.
      --
      -- ruby-lsp and rubocop are deliberately absent: mason bakes one ruby into
      -- the gem shebang, so they die with Bundler::RubyVersionMismatch in any
      -- project pinned to a different ruby. They run through mise instead; see
      -- lua/config/ruby_lsp_cmd.lua and install/post.sh.
      local mason_packages = {
        -- servers
        "lua-language-server@3.19.1",
        "vtsls@0.3.0",
        "eslint-lsp@4.10.0",
        "gopls@v0.23.0",
        "json-lsp@4.10.0",
        "css-lsp@4.10.0",
        "html-lsp@4.10.0",
        -- formatters and linters
        "stylua@v2.5.2",
        "erb-formatter@0.7.3",
        "prettierd@0.29.0",
        "gofumpt@v0.11.0",
        "goimports@v0.49.0",
        "eslint_d@15.0.3",
        "golangci-lint@v2.12.2",
      }

      require("mason-lspconfig").setup({
        -- Installation is mason-tool-installer's job (it can pin versions).
        ensure_installed = {},
        -- Enabling every mason-installed server drags in whatever is left over
        -- from past experiments. Enable only what is declared above.
        automatic_enable = false,
      })

      require("mason-tool-installer").setup({
        ensure_installed = mason_packages,
        run_on_start = true,
      })

      -- Must come after mason-lspconfig and before enable: nvim-lspconfig's own
      -- lsp/ruby_lsp.lua overrides a cmd set in ours, but not one set here.
      vim.lsp.config("ruby_lsp", { cmd = require("config.ruby_lsp_cmd").cmd })

      vim.lsp.enable(servers)

      vim.diagnostic.config({
        severity_sort = true,
        underline = true,
        update_in_insert = false,
        virtual_text = { spacing = 4, prefix = "●", source = "if_many" },
        float = { border = "rounded", source = "if_many" },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.INFO] = "",
            [vim.diagnostic.severity.HINT] = "",
          },
        },
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("user_lsp_attach", { clear = true }),
        callback = function(args)
          local map = function(keys, func, desc, mode)
            vim.keymap.set(mode or "n", keys, func, { buffer = args.buf, desc = "LSP: " .. desc })
          end

          map("gd", vim.lsp.buf.definition, "Goto definition")
          map("gD", vim.lsp.buf.declaration, "Goto declaration")
          map("gr", vim.lsp.buf.references, "References")
          map("gI", vim.lsp.buf.implementation, "Goto implementation")
          map("gy", vim.lsp.buf.type_definition, "Type definition")
          map("K", vim.lsp.buf.hover, "Hover")
          map("<C-k>", vim.lsp.buf.signature_help, "Signature help", "i")
          map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
          map("<leader>ca", vim.lsp.buf.code_action, "Code action", { "n", "v" })
          map("<leader>cd", vim.diagnostic.open_float, "Line diagnostics")
          map("[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, "Prev diagnostic")
          map("]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, "Next diagnostic")

          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client:supports_method("textDocument/inlayHint") then
            vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
            map("<leader>uh", function()
              vim.lsp.inlay_hint.enable(
                not vim.lsp.inlay_hint.is_enabled({ bufnr = args.buf }),
                { bufnr = args.buf }
              )
            end, "Toggle inlay hints")
          end

          if client and client:supports_method("textDocument/documentHighlight") then
            local hl_group = vim.api.nvim_create_augroup("user_lsp_highlight", { clear = false })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = args.buf,
              group = hl_group,
              callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = args.buf,
              group = hl_group,
              callback = vim.lsp.buf.clear_references,
            })
          end
        end,
      })
    end,
  },
}
