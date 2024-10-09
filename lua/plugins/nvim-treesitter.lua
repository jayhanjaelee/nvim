return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		local configs = require("nvim-treesitter.configs")

		configs.setup({
			ensure_installed = {
				"php",
				"phpdoc",
				"c",
        "cpp",
        "bash",
				"lua",
				"python",
				"vim",
				"vimdoc",
				"query",
				"javascript",
				"html",
        "css",
        "asm",
        "disassembly",
        "markdown",
        "rust",
        "sql",
        "make",
        "java"
			},
			sync_install = false,
			highlight = { enable = true },
			indent = { enable = true },
		})
	end,
}
