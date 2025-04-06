local nnoremap = require("user.keymap_utils").nnoremap
local vnoremap = require("user.keymap_utils").vnoremap
local inoremap = require("user.keymap_utils").inoremap
local tnoremap = require("user.keymap_utils").tnoremap
local xnoremap = require("user.keymap_utils").xnoremap
local conform = require("conform")

local M = {}

local TERM = os.getenv("TERM")

inoremap("fj", "<ESC>", { desc = "Exit insert mode with fj" })

-- Normal --
-- Disable Space bar since it'll be used as the leader key
nnoremap("<space>", "<nop>")

-- window management
nnoremap("<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
nnoremap("<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
nnoremap("<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
nnoremap("<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

-- Window +  better kitty navigation
nnoremap("<C-j>", function()
	if vim.fn.exists(":KittyNavigateDown") ~= 0 and TERM == "xterm-kitty" then
		vim.cmd.KittyNavigateDown()
	elseif vim.fn.exists(":NvimTmuxNavigateDown") ~= 0 then
		vim.cmd.NvimTmuxNavigateDown()
	else
		vim.cmd.wincmd("j")
	end
end)

nnoremap("<C-k>", function()
	if vim.fn.exists(":KittyNavigateUp") ~= 0 and TERM == "xterm-kitty" then
		vim.cmd.KittyNavigateUp()
	elseif vim.fn.exists(":NvimTmuxNavigateUp") ~= 0 then
		vim.cmd.NvimTmuxNavigateUp()
	else
		vim.cmd.wincmd("k")
	end
end)

nnoremap("<C-l>", function()
	if vim.fn.exists(":KittyNavigateRight") ~= 0 and TERM == "xterm-kitty" then
		vim.cmd.KittyNavigateRight()
	elseif vim.fn.exists(":NvimTmuxNavigateRight") ~= 0 then
		vim.cmd.NvimTmuxNavigateRight()
	else
		vim.cmd.wincmd("l")
	end
end)

nnoremap("<C-h>", function()
	if vim.fn.exists(":KittyNavigateLeft") ~= 0 and TERM == "xterm-kitty" then
		vim.cmd.KittyNavigateLeft()
	elseif vim.fn.exists(":NvimTmuxNavigateLeft") ~= 0 then
		vim.cmd.NvimTmuxNavigateLeft()
	else
		vim.cmd.wincmd("h")
	end
end)

-- Center buffer while navigating
-- nnoremap("j", "jzz")
-- nnoremap("k", "kzz")
-- nnoremap("<C-u>", "<C-u>zz")
-- nnoremap("<C-d>", "<C-d>zz")
-- nnoremap("{", "{zz")
-- nnoremap("}", "}zz")
-- nnoremap("N", "Nzz")
-- nnoremap("n", "nzz")
-- nnoremap("G", "Gzz")
-- nnoremap("gg", "ggzz")
-- nnoremap("<C-i>", "<C-i>zz")
-- nnoremap("<C-o>", "<C-o>zz")
-- nnoremap("%", "%zz")
-- nnoremap("*", "*zz")
-- nnoremap("#", "#zz")

-- Press 'H', 'L' to jump to start/end of a line (first/last char)
nnoremap("L", "$")
nnoremap("H", "^")

-- Press 'U' for redo
nnoremap("U", "<C-r>")

-- Turn off highlighted results
nnoremap("<leader>nh", "<cmd>noh<cr>", { desc = "Clear search highlights" })

-- Debugging
-- nnoremap("<leader>db", ":DapToggleBreakpoint<cr>", {})
-- nnoremap("<leader>dc", ":DapContinue<CR>", { desc = "Start/Continue debugging" })
-- nnoremap("<leader>dt", function()
-- 	require("dap-go").debug_test()
-- end, { desc = "Debug Go test under cursor" })
-- nnoremap("<leader>dT", function()
-- 	require("dap-go").debug_last_test()
-- end, { desc = "Debug last Go test" })
-- nnoremap("<leader>di", ":DapStepInto<CR>", { desc = "Step into" })
-- nnoremap("<leader>do", ":DapStepOver<CR>", { desc = "Step over" })
-- nnoremap("<leader>dO", ":DapStepOut<CR>", { desc = "Step out" })
-- nnoremap("<leader>du", ":DapUIToggle<CR>", { desc = "Toggle DAP UI" })
-- nnoremap("<leader>dx", ":DapTerminate<CR>", { desc = "Terminate debugging" })
-- Debugging keybindings
-- Basic operations
nnoremap("<leader>dc", ":DapContinue<CR>", { desc = "Start/Continue debugging" })
nnoremap("<leader>db", ":DapToggleBreakpoint<CR>", { desc = "Toggle breakpoint" })
nnoremap("<leader>dB", function()
	vim.ui.input({ prompt = "Breakpoint condition: " }, function(condition)
		if condition then
			vim.api.nvim_command("DapSetBreakpoint " .. condition)
		end
	end)
end, { desc = "Set conditional breakpoint" })
nnoremap("<leader>dl", function()
	vim.ui.input({ prompt = "Log message: " }, function(message)
		if message then
			vim.api.nvim_command("DapSetLogPoint " .. message)
		end
	end)
end, { desc = "Set log point" })

-- Step commands
nnoremap("<leader>di", ":DapStepInto<CR>", { desc = "Step into" })
nnoremap("<leader>do", ":DapStepOver<CR>", { desc = "Step over" })
nnoremap("<leader>dO", ":DapStepOut<CR>", { desc = "Step out" })

-- Execution control
nnoremap("<leader>dx", ":DapTerminate<CR>", { desc = "Terminate debugging" })
nnoremap("<leader>dr", ":lua require('dap').restart()<CR>", { desc = "Restart debugging" })
nnoremap("<leader>dp", ":lua require('dap').pause()<CR>", { desc = "Pause execution" })

-- UI controls
nnoremap("<leader>du", ":lua require('dapui').toggle()<CR>", { desc = "Toggle DAP UI" })
nnoremap("<leader>de", ":lua require('dapui').eval()<CR>", { desc = "Evaluate expression" })
nnoremap("<leader>df", function()
	local widgets = require("dap.ui.widgets")
	widgets.centered_float(widgets.frames)
end, { desc = "Show frames" })
nnoremap("<leader>ds", function()
	local widgets = require("dap.ui.widgets")
	widgets.centered_float(widgets.scopes)
end, { desc = "Show scopes" })

-- Go-specific debugging
nnoremap("<leader>dt", function()
	require("dap-go").debug_test()
end, { desc = "Debug Go test under cursor" })
nnoremap("<leader>dT", function()
	require("dap-go").debug_last_test()
end, { desc = "Debug last Go test" })
nnoremap("<leader>dA", function()
	require("dap-go").debug_test_file()
end, { desc = "Debug all tests in current file" })

-- Diagnostics

-- Goto next diagnostic of any severity
nnoremap("]d", function()
	vim.diagnostic.goto_next({})
	vim.api.nvim_feedkeys("zz", "n", false)
end)

-- Goto previous diagnostic of any severity
nnoremap("[d", function()
	vim.diagnostic.goto_prev({})
	vim.api.nvim_feedkeys("zz", "n", false)
end)

-- Goto next error diagnostic
nnoremap("]e", function()
	vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
	vim.api.nvim_feedkeys("zz", "n", false)
end)

-- Goto previous error diagnostic
nnoremap("[e", function()
	vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
	vim.api.nvim_feedkeys("zz", "n", false)
end)

-- Goto next warning diagnostic
nnoremap("]w", function()
	vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARN })
	vim.api.nvim_feedkeys("zz", "n", false)
end)

-- Goto previous warning diagnostic
nnoremap("[w", function()
	vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.WARN })
	vim.api.nvim_feedkeys("zz", "n", false)
end)

-- example keymap set
nnoremap("gl", function()
	vim.diagnostic.open_float()
end, { desc = "Open Diagnostics in Float." })

-- Map MaximizerToggle (szw/vim-maximizer) to leader-m
nnoremap("<leader>mm", ":MaximizerToggle<cr>")

-- Resize split windows to be equal size
nnoremap("<leader>=", "<C-w>=")

-- Press leader rw to rotate open windows
nnoremap("<leader>rw", ":RotateWindows<cr>", { desc = "[R]otate [W]indows" })

-- Go keymaps --
nnoremap("<leader>gc", ":GoCoverage -t<cr>", { desc = "Toggle Test Coverage" })
nnoremap("<leader>gp", ":GoTestPkg -t<cr>")

-- Git keymaps --
nnoremap("<leader>gb", ":Gitsigns toggle_current_line_blame<cr>")

-- Insert --

-- Visual --
-- Disable Space bar since it'll be used as the leader key
vnoremap("<space>", "<nop>")

-- Press 'H', 'L' to jump to start/end of a line (first/last char)
vnoremap("L", "$<left>")
vnoremap("H", "^")

-- Reselect the last visual selection
xnoremap("<<", function()
	-- Move selected text up/down in visual mode
	vim.cmd("normal! <<")
	vim.cmd("normal! gv")
end)

xnoremap(">>", function()
	vim.cmd("normal! >>")
	vim.cmd("normal! gv")
end)

-- Move line up/down
vnoremap("J", ":m '>+1<CR>gv=gv")
vnoremap("K", ":m '<-2<CR>gv=gv")

-- Terminal --
-- Enter normal mode while in a terminal
tnoremap("<esc>", [[<C-\><C-n>]])
tnoremap("fj", "<ESC>", { desc = "Exit term mode with fj" })

-- Window navigation from terminal
tnoremap("<C-h>", [[<Cmd>wincmd h<CR>]])
tnoremap("<C-j>", [[<Cmd>wincmd j<CR>]])
tnoremap("<C-k>", [[<Cmd>wincmd k<CR>]])
tnoremap("<C-l>", [[<Cmd>wincmd l<CR>]])

-- Reenable default <space> functionality to prevent input delay
tnoremap("<space>", "<space>")

return M
