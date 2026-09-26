vim.pack.add({ { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' } })

-- Highlighting is started per buffer and parsers are kept in sync on update
-- by config/autocmds.lua.
---The function will verify if a parser is present for a language and will launch the highlight for the language
local function attach(buf, language)
	if not vim.treesitter.language.add(language) then
		return false
	end
	
	vim.treesitter.start(buf, language)
	return true
end

vim.api.nvim_create_autocmd({"FileType"}, {
	callback = function(args)
		local buf, filetype = args.buf, args.match
		local language = vim.treesitter.language.get_lang(filetype)
		
		if not language then
			return
		end

		if attach(buf, language) then
			return
		end
		-- attempt to start highlighter after installing missing language
		require('nvim-treesitter').install(language):await(function()
			attach(buf, language)
		end)
	end,
})
