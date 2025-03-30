require('nvim_comment').setup()
vim.keymap.set('n', '<leader>lc', '<cmd>CommentToggle<cr>', {desc = "Comment a line"})
vim.keymap.set('n', '<leader>vc', "<cmd>'<,'>CommentToggle<cr>", {desc = "Comment a selected section"})
