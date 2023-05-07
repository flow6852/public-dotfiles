set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

let g:vimsyn_embed = 'lPr'
set completeopt=menuone,noinsert,noselect
set shortmess+=c

lua << EOF
-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float) -- quickfix表示
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev) -- 前の指摘へのジャンプ
vim.keymap.set('n', ']d', vim.diagnostic.goto_next) -- 後ろの指摘へのジャンプ
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist) -- setloclist

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts) -- 宣言ジャンプ
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts) -- 定義ジャンプ
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts) -- ヒント表示
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts) -- 実装ジャンプ
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts) -- 引数情報
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts) -- workspace追加
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts) -- workspace削除
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts) -- workspace list表示
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts) -- 型定義へのジャンプ
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts) -- rename
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts) -- 指摘に対するアクション
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts) -- 参照ジャンプ
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts) -- フォーマッタ
  end,
})

local mason = require('mason')
mason.setup()

local nvim_lsp = require('lspconfig')
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
local mason_lspconfig = require('mason-lspconfig')
mason_lspconfig.setup()
mason_lspconfig.setup_handlers({ function(server_name)
    nvim_lsp[server_name].setup{on_attach = on_attach, capabilities = capabilities}
end })

require'lspconfig'.denols.setup{}

-- local lsp_installer = require("nvim-lsp-installer")
-- lsp_installer.on_server_ready(function(server)
--     local opts = {}
--     opts.on_attach = on_attach
-- 
--     server:setup(opts)
-- end)

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, { virtual_text = false }
)

-- vim.api.nvim_create_autocmd('FileWritePost', {
--   callback = function() vim.diagnostic.setqflist({open=false}) end
-- })
EOF
