-- Warns once when the Lua heap passes 1 GB. A session grew to 13 GB over six
-- idle days (Oct 2026) and was already swapped out and unresponsive by the
-- time anyone noticed, so the cause could not be inspected. This flags it
-- while `:lua` still answers.
local limit_kb = 1024 * 1024

local timer = vim.uv.new_timer()
timer:start(60000, 60000, vim.schedule_wrap(function()
  local heap_kb = collectgarbage("count")
  if heap_kb < limit_kb then return end
  timer:stop()
  vim.notify(
    ("Lua heap is %.1f GB, something is leaking. Inspect before restarting."):format(heap_kb / 1024 / 1024),
    vim.log.levels.WARN
  )
end))
