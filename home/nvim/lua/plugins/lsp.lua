return {
	{
		"jmbuhr/otter.nvim",
		dependencies = {
			"hrsh7th/nvim-cmp", -- optional, for completion
			"neovim/nvim-lspconfig",
			"nvim-treesitter/nvim-treesitter",
		},
	},
	{
		"saecki/crates.nvim",
		ft = { "rust", "toml" },
		event = { "BufRead Cargo.toml" },
		config = function()
			require("crates").setup()
		end,
	},
	{
		"ray-x/go.nvim",
		dependencies = { -- optional packages
			"ray-x/guihua.lua",
			"neovim/nvim-lspconfig",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("go").setup({
				go = "go",
				verbose = true,
				gocoverage_sign = "█",
				test_runner = "go",
				run_in_floaterm = true,
				icons = { breakpoint = "🔴", currentpos = "⚠️" },
				floaterm = { -- position
					posititon = "bottom", -- one of {`top`, `bottom`, `left`, `right`, `center`, `auto`}
					width = 0.98, -- width of float window if not auto
					height = 0.60, -- height of float window if not auto
					title_colors = "dracula", -- default to nord, one of {'nord', 'tokyo', 'dracula', 'rainbow', 'solarized ', 'monokai'}
					-- can also set to a list of colors to define colors to choose from
					-- e.g {'#D8DEE9', '#5E81AC', '#88C0D0', '#EBCB8B', '#A3BE8C', '#B48EAD'}
					border = "rounded",
				},
				trouble = true,
			})
		end,
		event = { "CmdlineEnter" },
		ft = { "go", "gomod" },
		build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
	},
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPost" },
		cmd = { "LspInfo", "LspInstall", "LspUninstall", "Mason" },
		dependencies = {
			-- Plugin(s) and UI to automatically install LSPs to stdpath
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",

			-- Install lsp autocompletions
			"hrsh7th/cmp-nvim-lsp",

			-- Progress/Status update for LSP
			{ "j-hui/fidget.nvim", opts = {} },
		},
		config = function()
			local map_lsp_keybinds = require("user.keymaps").map_lsp_keybinds -- Has to load keymaps before pluginslsp

			-- Default handlers for LSP
			local default_handlers = {
				["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
				["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" }),
			}

			-- Function to run when neovim connects to a Lsp client
			---@diagnostic disable-next-line: unused-local
			local on_attach = function(_client, buffer_number)
				-- Pass the current buffer to map lsp keybinds
				map_lsp_keybinds(buffer_number)
			end

			-- LSP servers and clients are able to communicate to each other what features they support.
			--  By default, Neovim doesn't support everything that is in the LSP Specification.
			--  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
			--  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

			-- LSP servers to install (see list here: https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers )
			--  Add any additional override configuration in the following tables. Available keys are:
			--  - cmd (table): Override the default command used to start the server
			--  - filetypes (table): Override the default list of associated filetypes for the server
			--  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
			--  - settings (table): Override the default settings passed when initializing the server.
			--        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
			local servers = {
				-- LSP Servers
				bashls = {},
				cssls = {},
				eslint = {},
				html = {},
				jsonls = {},
				lua_ls = {
					settings = {
						Lua = {
							runtime = { version = "LuaJIT" },
							workspace = {
								checkThirdParty = false,
								-- Tells lua_ls where to find all the Lua files that you have loaded
								-- for your neovim configuration.
								library = {
									"${3rd}/luv/library",
									unpack(vim.api.nvim_get_runtime_file("", true)),
								},
							},
							telemetry = { enabled = false },
						},
					},
				},
				marksman = {},
				rust_analyzer = {
					settings = {
						["rust-analyzer"] = {
							-- check = {
							-- 	command = "clippy",
							-- },
							-- diagnostics = {
							-- 	enable = true,
							-- },
							cargo = {
								allFeatures = true,
							},
						},
					},
				},
				-- nixd = {
				-- 	settings = {
				-- 		nixd = {
				-- 			nixpkgs = {
				-- 				expr = "import <nixpkgs> { }",
				-- 			},
				-- 			formatting = {
				-- 				command = { "alejandra" },
				-- 			},
				-- 			-- options = {
				-- 			--     nixos = {
				-- 			--         expr = '(builtins.getFlake "/tmp/NixOS_Home-Manager").nixosConfigurations.hostname.options',
				-- 			--     },
				-- 			--     home_manager = {
				-- 			--         expr = '(builtins.getFlake "/tmp/NixOS_Home-Manager").homeConfigurations."user@hostname".options',
				-- 			--     },
				-- 			--     flake_parts = {
				-- 			--         expr = 'let flake = builtins.getFlake ("/tmp/NixOS_Home-Manager"); in flake.debug.options // flake.currentSystem.options',
				-- 			--     },
				-- 		},
				-- 	},
				-- },
				nil_ls = {},
				pyright = {},
				sqlls = {},
				yamlls = {},
				solargraph = {},
				gopls = {
					flags = { debounce_text_changes = 200 },
					-- gocoverage_sign = "█",
					gocoverage_sign = "|",
					settings = {
						gopls = {
							completeUnimported = true,
							usePlaceholders = true,
							gofumpt = true,
							analyses = {
								nilness = true,
								unusedparams = true,
								unusedwrite = true,
								useany = true,
							},
							codelenses = {
								gc_details = false,
								generate = true,
								regenerate_cgo = true,
								run_govulncheck = true,
								test = true,
								tidy = true,
								upgrade_dependency = true,
								vendor = true,
							},
							experimentalPostfixCompletions = true,
							staticcheck = true,
							directoryFilters = { "-.git", "-node_modules" },
							semanticTokens = true,
							hints = {
								-- assignVariableTypes = true,
								compositeLiteralFields = true,
								-- compositeLiteralTypes = true,
								constantValues = true,
								-- functionTypeParameters = true,
								-- parameterNames = true,
								-- rangeVariableTypes = true,
							},
						},
					},
				},
			}

			local formatters = {
				prettierd = {},
				stylua = {},
			}

			local manually_installed_servers = {}

			local mason_tools_to_install = vim.tbl_keys(vim.tbl_deep_extend("force", {}, servers, formatters))

			local ensure_installed = vim.tbl_filter(function(name)
				return not vim.tbl_contains(manually_installed_servers, name)
			end, mason_tools_to_install)

			require("mason-tool-installer").setup({
				auto_update = true,
				run_on_start = true,
				start_delay = 3000,
				debounce_hours = 12,
				ensure_installed = ensure_installed,
			})

			-- Iterate over our servers and set them up
			for name, config in pairs(servers) do
				require("lspconfig")[name].setup({
					capabilities = capabilities,
					filetypes = config.filetypes,
					handlers = vim.tbl_deep_extend("force", {}, default_handlers, config.handlers or {}),
					on_attach = on_attach,
					settings = config.settings,
				})
			end

			-- Setup mason so it can manage 3rd party LSP servers
			require("mason").setup({
				ui = {
					border = "rounded",
				},
			})

			require("mason-lspconfig").setup()

			-- Configure borderd for LspInfo ui
			require("lspconfig.ui.windows").default_options.border = "rounded"

			-- Configure diagnostics border
			vim.diagnostic.config({
				float = {
					border = "rounded",
				},
			})
		end,
	},
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		opts = {
			notify_on_error = true,
			format_on_save = {
				-- async = true,
				timeout_ms = 500,
				lsp_fallback = true,
			},
			formatters_by_ft = {
				javascript = { "prettierd", "prettier", stop_after_first = true },
				lua = { "stylua" },
				nix = { "alejandra" },
				json = { "prettierd" },
			},
		},
	},
	{
		"mfussenegger/nvim-lint",
		event = {
			"BufReadPre",
			"BufNewFile",
		},
		-- event = { "BufWritePost", "BufNewFile", "InsertLeave" },
		config = function()
			local lint = require("lint")
			lint.linters_by_ft = {
				javascript = { "eslint_d" },
				-- lua = { "luacheck" },
				nix = { "nix" },
				json = { "jsonlint" },
				-- go = { "golangci-lint" },
				go = { "golangcilint" },
			}

			local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
				group = lint_augroup,
				callback = function()
					-- try_lint without arguments runs the linters defined in `linters_by_ft`
					-- for the current filetype
					lint.try_lint()
				end,
			})
		end,
	},
}
