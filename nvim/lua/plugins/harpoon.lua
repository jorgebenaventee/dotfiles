local harpoon = require('harpoon')
harpoon:setup({})

local conf = require("telescope.config").values
local function toggle_telescope(harpoon_files)
	local file_paths = {}
	for _, item in ipairs(harpoon_files.items) do
		table.insert(file_paths, item.value)
	end

	require("telescope.pickers").new({}, {
		prompt_title = "Harpoon",
		finder = require("telescope.finders").new_table({
			results = file_paths,
		}),
		previewer = conf.file_previewer({}),
		sorter = conf.generic_sorter({}),
	}):find()
end

vim.keymap.set("n", "<C-e>", function() toggle_telescope(harpoon:list()) end,
	{ desc = "Open harpoon window" })

vim.keymap.set('n', '<leader>a', function()
	harpoon:list():append()
end, { desc = 'Append buffer to harpoon' })

vim.keymap.set("n", "<sc-1>", function() harpoon:list():select(1) end, { desc = "Select harpoon window" })
vim.keymap.set("n", "<sc-2>", function() harpoon:list():select(2) end, { desc = "Select harpoon window" })
vim.keymap.set("n", "<sc-3>", function() harpoon:list():select(3) end, { desc = "Select harpoon window" })
vim.keymap.set("n", "<sc-4>", function() harpoon:list():select(4) end, { desc = "Select harpoon window" })
vim.keymap.set("n", "<sc-P>", function() harpoon:list():prev() end, {desc = "Go to previous buffer"})
vim.keymap.set("n", "<sc-N>", function() harpoon:list():next() end, {desc = "Go to next buffer"})
