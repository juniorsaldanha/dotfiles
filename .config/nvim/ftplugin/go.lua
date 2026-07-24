-- Set the column guide
vim.opt_local.colorcolumn = "120"

-- Go-specific indentation (Standard Go uses tabs, not spaces)
vim.opt_local.expandtab = false
vim.opt_local.shiftwidth = 4
vim.opt_local.tabstop = 4

-- Optional: Auto-format on save using LSP
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.go",
    callback = function()
        -- This calls the LSP formatting sync
        vim.lsp.buf.format({ async = false })

        -- Optional: If you use 'goimports', you can add logic here
        -- to organize imports automatically.
    end,
})

-- :GoTest              -> go test ./...
-- :GoTest buf|buffer   -> run the Test* funcs of the current buffer's file
--                         (warns if it is not a _test.go file).
-- :GoTest file_test.go -> run only the Test* funcs declared in that file,
--                         scoped to the file's package directory.
vim.api.nvim_buf_create_user_command(0, "GoTest", function(opts)
    -- Run in a bottom terminal split with live output.
    local function run(cmd)
        vim.cmd("botright new")
        vim.fn.jobstart(cmd, { term = true })
        vim.cmd("startinsert")
    end

    -- Whole module.
    if opts.args == "" then
        run({ "go", "test", "./..." })
        return
    end

    -- Resolve the target file: the current buffer, or a path argument.
    local file
    if opts.args == "buf" or opts.args == "buffer" then
        file = vim.fn.expand("%:p")
        if not file:match("_test%.go$") then
            vim.notify("GoTest: current buffer is not a _test.go file", vim.log.levels.WARN)
            return
        end
    else
        -- Try the argument as given, then relative to the current buffer's
        -- directory (so `:GoTest foo_test.go` works from the file you're in).
        file = opts.args
        if vim.fn.filereadable(file) == 0 then
            local candidate = vim.fn.expand("%:p:h") .. "/" .. opts.args
            if vim.fn.filereadable(candidate) == 1 then
                file = candidate
            end
        end
        if vim.fn.filereadable(file) == 0 then
            vim.notify("GoTest: file not found: " .. opts.args, vim.log.levels.ERROR)
            return
        end
    end

    -- go test works on packages, not files, so collect the test function
    -- names and run just those within the file's package.
    local names = {}
    for _, line in ipairs(vim.fn.readfile(file)) do
        local name = line:match("^func%s+(Test%w+)")
        if name then
            table.insert(names, name)
        end
    end
    if #names == 0 then
        vim.notify("GoTest: no Test functions found in " .. vim.fn.fnamemodify(file, ":t"), vim.log.levels.WARN)
        return
    end

    -- Make the package dir relative with a ./ prefix for module mode.
    local dir = vim.fn.fnamemodify(file, ":h")
    local reldir = vim.fn.fnamemodify(dir, ":.")
    if reldir == "" or reldir == "." then
        reldir = "."
    elseif not reldir:match("^/") then
        reldir = "./" .. reldir
    end

    run({ "go", "test", reldir, "-run", "^(" .. table.concat(names, "|") .. ")$" })
end, {
    nargs = "?",
    complete = function(arglead)
        local items = {}
        for _, kw in ipairs({ "buf", "buffer" }) do
            if kw:find(arglead, 1, true) == 1 then
                table.insert(items, kw)
            end
        end
        vim.list_extend(items, vim.fn.getcompletion(arglead, "file"))
        return items
    end,
    desc = "Run go test (whole module, current buffer, or a specific test file)",
})
