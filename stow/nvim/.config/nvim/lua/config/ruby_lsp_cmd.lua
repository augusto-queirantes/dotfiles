-- Builds the ruby_lsp launch command. Lives here rather than in
-- lsp/ruby_lsp.lua because nvim-lspconfig ships its own lsp/ruby_lsp.lua and
-- wins the runtimepath merge -- a `cmd` set in our file is silently replaced by
-- its plain `{ "ruby-lsp" }`. Applying it through vim.lsp.config() at runtime
-- (see lua/plugins/lsp.lua) takes precedence over both.
--
-- Why not just `ruby-lsp`: mason and a bare PATH lookup both pin one ruby, and
-- RubyGems bakes that interpreter into the gem shebang, so any project on a
-- different .ruby-version dies with `Bundler::RubyVersionMismatch`.
--
-- Everything the child needs is baked into the command string. Neither cwd nor
-- env passed to vim.lsp.rpc.start reaches the process, so the shell sets both
-- itself. PATH matters as much as the interpreter: ruby-lsp re-execs as
-- `bundle exec ruby-lsp`, and bundler takes that executable off PATH.
--
-- Requires the ruby-lsp gem per pinned ruby; install/post.sh installs them.

local M = {}

local function mise_which(tool, root)
  local out = vim.system({ "mise", "exec", "--", "which", tool }, { cwd = root, text = true }):wait()
  if out.code ~= 0 then return nil end
  local path = vim.trim(out.stdout or "")
  return path ~= "" and path or nil
end

function M.cmd(dispatchers, config)
  local root = (config and config.root_dir)
    or vim.fs.root(0, { "Gemfile", ".git" })
    or vim.fn.getcwd()

  local esc = vim.fn.shellescape
  local ruby = mise_which("ruby", root)
  local server = mise_which("ruby-lsp", root)

  local script
  if ruby and server then
    script = ("cd %s && PATH=%s:$PATH exec %s %s"):format(
      esc(root), esc(vim.fs.dirname(ruby)), esc(ruby), esc(server)
    )
  else
    vim.notify("ruby_lsp: could not resolve ruby/ruby-lsp via mise in " .. root, vim.log.levels.WARN)
    script = ("cd %s && exec mise exec -- ruby-lsp"):format(esc(root))
  end

  return vim.lsp.rpc.start({ "/bin/sh", "-c", script }, dispatchers)
end

return M
