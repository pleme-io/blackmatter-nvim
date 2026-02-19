local M = {}
function M.setup()
	vim.filetype.add({
		-- pattern matches full filenames
		pattern = {
			[".*%.rockspec"] = "lua",
			[".*%.tpl"] = "gotmpl", -- Helm templates
			[".*%.tf.json"] = "json", -- Terraform JSON
		},
		-- extension matches after the final dot
		extension = {
			tf = "terraform", -- HCL
			nix = "nix",
			hcl = "terraform",
		},
	})
end
return M
