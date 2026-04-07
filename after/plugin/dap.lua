-- Configuración completa de nvim-dap para JavaScript/TypeScript
-- con la ruta exacta de tu js-debug-adapter

local dap = require("dap")
local js_debug_path = "/home/spyro/.local/share/nvim/mason/packages/js-debug-adapter"

-- 1. Configurar el ADAPTADOR
dap.adapters["pwa-node"] = {
    type = "server",
    host = "localhost",
    port = "${port}",
    executable = {
        command = "node",
        args = { js_debug_path .. "/js-debug/src/dapDebugServer.js", "${port}" },
    },
}

-- También configuramos pwa-chrome por si quieres debuggear en el navegador
dap.adapters["pwa-chrome"] = {
    type = "server",
    host = "localhost",
    port = "${port}",
    executable = {
        command = "node",
        args = { js_debug_path .. "/js-debug/src/dapDebugServer.js", "${port}" },
    },
}

-- 2. Configurar los LANZAMIENTOS para diferentes lenguajes
local js_based_languages = { 
    "typescript", 
    "javascript", 
    "typescriptreact", 
    "javascriptreact",
    "vue",        -- Si usas Vue
    "svelte"      -- Si usas Svelte
}

for _, language in ipairs(js_based_languages) do
    dap.configurations[language] = {
        {
            -- Para archivos Node.js individuales (ej. script.ts)
            name = "Launch Current File (Node)",
            type = "pwa-node",
            request = "launch",
            program = "${file}",
            cwd = "${workspaceFolder}",
            sourceMaps = true,
            skipFiles = { "<node_internals>/**" },
            resolveSourceMapLocations = {
                "${workspaceFolder}/**",
                "!**/node_modules/**",
            },
        },
        {
            -- Para atachar a un proceso Node que ya está corriendo
            name = "Attach to Process",
            type = "pwa-node",
            request = "attach",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
            sourceMaps = true,
        },
        {
            -- Para aplicaciones Next.js (conectarse al servidor)
            name = "Next.js: Attach (Server)",
            type = "pwa-node",
            request = "attach",
            port = 9231,  -- Puerto por defecto de Next.js para debugging
            skipFiles = { "<node_internals>/**", "node_modules/**" },
            cwd = "${workspaceFolder}",
            sourceMaps = true,
        },
        {
            -- Para debuggear en Chrome
            name = "Launch Chrome",
            type = "pwa-chrome",
            request = "launch",
            url = "http://localhost:3000",  -- Cambia según tu proyecto
            webRoot = "${workspaceFolder}",
            sourceMaps = true,
            userDataDir = "${workspaceFolder}/.vscode/chrome-profile",
        },
    }
end

-- 3. Configuración específica para TypeScript cuando se compila
-- Esto ayuda a que los breakpoints funcionen con archivos .ts compilados
dap.configurations.typescript = dap.configurations.typescript or {}
table.insert(dap.configurations.typescript, {
    name = "Launch Compiled TypeScript",
    type = "pwa-node",
    request = "launch",
    program = "${workspaceFolder}/dist/index.js",  -- Ajusta según tu estructura
    cwd = "${workspaceFolder}",
    sourceMaps = true,
    outFiles = { "${workspaceFolder}/dist/**/*.js" },
    skipFiles = { "<node_internals>/**" },
})

-- 4. (Opcional) Comandos para facilitar el debug
-- Crea comandos personalizados
vim.api.nvim_create_user_command("DapContinue", function()
    dap.continue()
end, { desc = "Continue execution" })

vim.api.nvim_create_user_command("DapToggleBreakpoint", function()
    dap.toggle_breakpoint()
end, { desc = "Toggle breakpoint" })

-- 5. Atajos de teclado recomendados
vim.keymap.set("n", "<leader>dc", function() dap.continue() end, { desc = "Start/Continue debugging" })
vim.keymap.set("n", "<F10>", function() dap.step_over() end, { desc = "Step over" })
vim.keymap.set("n", "<F11>", function() dap.step_into() end, { desc = "Step into" })
vim.keymap.set("n", "<F12>", function() dap.step_out() end, { desc = "Step out" })
vim.keymap.set("n", "<leader>db", function() dap.toggle_breakpoint() end, { desc = "Toggle breakpoint" })
vim.keymap.set("n", "<leader>dr", function() dap.repl.open() end, { desc = "Open REPL" })
vim.keymap.set("n", "<leader>dl", function() dap.run_last() end, { desc = "Run last configuration" })

