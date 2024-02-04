-- LAZY
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

if not vim.loop.fs_stat(lazypath) then
	print('Installing lazy.nvim...')
	vim.fn.system({
		'git',
		'clone',
		'--filter=blob:none',
		'https://github.com/folke/lazy.nvim.git',
		'--branch=stable',
		lazypath,
	})
end



vim.g.mapleader = " "
vim.keymap.set("n", "<Space>", "<Nop>", { silent = true, remap = false })
vim.keymap.set("n", "<leader>cs", ":nohlsearch<cr>", { desc = 'Clear search highlighting' })

vim.keymap.set("i", "<C-h>", "<Left>", { noremap = true, silent = true })
vim.keymap.set("i", "<C-j>", "<Down>", { noremap = true, silent = true })
vim.keymap.set("i", "<C-k>", "<Up>", { noremap = true, silent = true })
vim.keymap.set("i", "<C-l>", "<Right>", { noremap = true, silent = true })

vim.opt.rtp:prepend(lazypath)

local lazy = require('lazy')

lazy.setup({
	{
		"navarasu/onedark.nvim",
		priority = 1000, -- Ensure it loads first
	},
	{ 'VonHeikemen/lsp-zero.nvim',        branch = 'v3.x' },
	{ 'williamboman/mason.nvim' },
	{ 'williamboman/mason-lspconfig.nvim' },
	{ 'nvim-treesitter/nvim-treesitter' },
	{ 'neovim/nvim-lspconfig' },
	{ 'hrsh7th/nvim-cmp' },
	{ 'hrsh7th/cmp-nvim-lsp' },
	{ 'L3MON4D3/LuaSnip' },
	{ 'nvim-tree/nvim-tree.lua' },
	{ 'nvim-tree/nvim-web-devicons' },
	{ 'Raimondi/delimitMate' },
	{
		'nvim-telescope/telescope.nvim',
		dependencies = {
			'nvim-lua/plenary.nvim'
		}
	},
	{ 'folke/which-key.nvim', event = 'VeryLazy' },
	{
		'zbirenbaum/copilot.lua',
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			require('copilot').setup({
				suggestion = { enabled = false },
				panel = { enabled = false }
			})
		end
	},
	{
		'zbirenbaum/copilot-cmp',
		config = function()
			require('copilot_cmp').setup()
		end
	},
	{
		'onsails/lspkind.nvim'
	},
	{
		'akinsho/toggleterm.nvim'
	},
	{
		'windwp/nvim-ts-autotag'
	}
})


-- VIM OPTIONS
vim.opt.termguicolors = true
vim.opt.relativenumber = true
vim.opt.number = true
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
local onedark_theme = require('onedark')
onedark_theme.setup {
	style = 'deep'
}

onedark_theme.load()

-- LSP
local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(
	function(client, bufnr)
		local opts = { buffer = bufnr, remap = false }
		local function add_description(desc)
			return vim.tbl_extend('force', opts, { desc = desc })
		end
		vim.keymap.set('n', "gd", function() vim.lsp.buf.definition() end, add_description('Go to definition'))
		vim.keymap.set('n', 'K', function() vim.lsp.buf.hover() end, add_description('Hover'))
		vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end,
			add_description('View usages in Workspace'))
		vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end,
			add_description('View errors'))
		vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, add_description('Go to next error'))
		vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end,
			add_description('Go to previous error'))
		vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end,
			add_description('Summon code action'))
		vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end,
			add_description('View references'))
		vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, add_description('Rename'))
		vim.keymap.set("n", "<C-h>", function() vim.lsp.buf.signature_help() end,
			add_description('Signature help'))
		vim.keymap.set('i', '<C-M-l>', function()
			vim.lsp.buf.format()
		end, add_description('Format document'))
	end
)

lsp_zero.format_on_save({
	format_opts = {
		async = false,
		timeout_ms = 10000
	}
})

local mason = require('mason')

mason.setup({})

require('mason-lspconfig').setup({
	handlers = {
		lsp_zero.default_setup,
		lua_ls = function()
			local lua_opts = lsp_zero.nvim_lua_ls()
			require('lspconfig').lua_ls.setup(lua_opts)
		end,
	}
})

local cmp = require('cmp')
local cmp_action = lsp_zero.cmp_action()

-- this is the function that loads the extra snippets
-- from rafamadriz/friendly-snippets
require('luasnip.loaders.from_vscode').lazy_load()
local lspkind = require('lspkind')
cmp.setup({
	-- if you don't know what is a "source" in nvim-cmp read this:
	-- https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/autocomplete.md#adding-a-source
	sources = {
		{ name = 'copilot', group_index = 2 },
		{ name = 'path' },
		{ name = 'nvim_lsp' },
		{ name = 'luasnip', keyword_length = 2 },
		{ name = 'buffer',  keyword_length = 3 },
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	-- default keybindings for nvim-cmp are here:
	-- https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/README.md#keybindings-1
	mapping = cmp.mapping.preset.insert({
		-- confirm completion item
		['<Enter>'] = cmp.mapping.confirm({ select = true }),

		-- trigger completion menu
		['<C-Space>'] = cmp.mapping.complete(),

		-- scroll up and down the documentation window
		['<C-u>'] = cmp.mapping.scroll_docs(-4),
		['<C-d>'] = cmp.mapping.scroll_docs(4),

		-- navigate between snippet placeholders
		['<C-f>'] = cmp_action.luasnip_jump_forward(),
		['<C-b>'] = cmp_action.luasnip_jump_backward(),
	}),
	-- note: if you are going to use lsp-kind (another plugin)
	-- replace the line below with the function from lsp-kind
	formatting = {
		format = lspkind.cmp_format({
			mode = 'symbol',
			max_width = 50,
			symbol_map = { Copilot = "" }
		}),
	}
})

require('plugins.nvim-tree')

require('plugins.telescope')

require('plugins.delimitMate')

require('plugins.which-key')

require('plugins.toggleterm')

require('plugins.ts-autotag')
