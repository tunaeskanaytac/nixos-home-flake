vim.keymap.set("n", "<leader>fd", "<Cmd>Ex<CR>", { desc = "Netrw" })

vim.keymap.set("n", "<leader>p", "<nop>", { desc = "+Pick" })
vim.keymap.set("n", "<leader>pf", "<Cmd>Pick files<CR>", { desc = "Pick Files" })
vim.keymap.set("n", "<leader>pb", "<Cmd>Pick buffers<CR>", { desc = "Pick Buffers" })
vim.keymap.set("n", "<leader>pg", "<Cmd>Pick grep_live<CR>", { desc = "Pick Grep Live" })

vim.keymap.set("n", "<leader>c", "<nop>", { desc = "+Code" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
vim.keymap.set("n", "<leader>cf", vim.lsp.buf.format, { desc = "Code Format" })

vim.keymap.set("n", "<leader>u", "<nop>", { desc = "+UndoTree" })
vim.keymap.set("n", "<leader>ut", "<Cmd>UndotreeToggle<CR>", { desc = "Toggle Undo Tree" })

vim.keymap.set("n", "<leader>t", "<nop>", { desc = "+Trouble" })
vim.keymap.set("n", "<leader>td", "<Cmd>Trouble diagnostics toggle<CR>", { desc = "Toggle Diagnostics" })
