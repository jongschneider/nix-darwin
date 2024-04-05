vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

keymap.set("i", "jf", "<ESC>", { desc = "Exit insert mode with jk" })

keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab

-- Open harpoon ui
keymap.set("n", "<leader>ho", '<cmd>lua require("harpoon.ui").toggle_quick_menu()<CR>', { desc = "Open harpoon ui" })

-- Add current file to harpoon
keymap.set("n", "<leader>ha", '<cmd>lua require("harpoon.mark").add_file()<CR>', { desc = "Add current file to harpoon" })

-- -- Remove current file from harpoon
keymap.set("n", "<leader>hr", '<cmd>lua require("harpoon.mark").rm_file()<CR>', { desc = "Remove current file from harpoon" })

-- -- Remove all files from harpoon
keymap.set("n", "<leader>hc", '<cmd>lua require("harpoon.mark").clear_all()<CR>', { desc = "Remove all files from harpoon" })

-- -- Quickly jump to harpooned files
keymap.set("n", "<leader>1", '<cmd>lua require("harpoon.ui").nav_file(1)<CR>', { desc = "Quickly jump to harpooned file 1"})

keymap.set("n", "<leader>2", '<cmd>lua require("harpoon.ui").nav_file(2)<CR>', { desc = "Quickly jump to harpooned file 2" })

keymap.set("n", "<leader>3", '<cmd>lua require("harpoon.ui").nav_file(3)<CR>', { desc = "Quickly jump to harpooned file 3" })

keymap.set("n", "<leader>4", '<cmd>lua require("harpoon.ui").nav_file(4)<CR>', { desc = "Quickly jump to harpooned file 4" })

keymap.set("n", "<leader>5", '<cmd>lua require("harpoon.ui").nav_file(5)<CR>', { desc = "Quickly jump to harpooned file 5" })

-- TODO: Telescope lsp_document_symbols ignore_symbols=variable