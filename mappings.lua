-- Mapping data with "desc" stored directly by vim.keymap.set().
--
-- Please use this mappings table to set keyboard mapping since this is the
-- lower level configuration and more robust one. (which-key will
-- automatically pick-up stored data by this setting.)
return {
  -- first key is the mode
  n = {
    -- second key is the lefthand side of the map

    -- navigate buffer tabs with `H` and `L`
    -- L = {
    --   function() require("astronvim.utils.buffer").nav(vim.v.count > 0 and vim.v.count or 1) end,
    --   desc = "Next buffer",
    -- },
    -- H = {
    --   function() require("astronvim.utils.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1)) end,
    --   desc = "Previous buffer",
    -- },

    -- mappings seen under group name "Buffer"
    ["<leader>bD"] = {
      function()
        require("astronvim.utils.status").heirline.buffer_picker(
          function(bufnr) require("astronvim.utils.buffer").close(bufnr) end
        )
      end,
      desc = "Pick to close",
    },
    -- tables with the `name` key will be registered with which-key if it's installed
    -- this is useful for naming menus
    ["<leader>b"] = { name = "Buffers" },
    -- quick save
    -- ["<C-s>"] = { ":w!<cr>", desc = "Save File" },  -- change description but the same command

-- custom keybinding to comple/run cpp and python files
["<leader>rr"] = {
  function()
    local current_file = vim.fn.expand("%:p")
    local root_name = vim.fn.fnamemodify(current_file, ":r")
    local file_extension = vim.fn.expand("%:e")
    local compile_command = ""
    
    if file_extension == "cpp" or file_extension == "c" then
      compile_command = "clang++ " .. current_file .. " -o " .. root_name
    elseif file_extension == "py" then
      compile_command = "python3 " .. current_file
    else
      print("Unsupported file type")
      return
    end
    
    -- Open a vertical split and run the terminal in the directory of the current file
    vim.cmd("vsplit | vertical resize -20 | cd " .. vim.fn.fnameescape(vim.fn.fnamemodify(current_file, ":h")))
    
    -- For C/C++ files, compile and run; for Python files, run directly
    if file_extension == "cpp" or file_extension == "c" then
      local input_file = vim.fn.expand('%:p:h') .. '/input.txt'
      if vim.fn.filereadable(input_file) == 1 and vim.fn.getfsize(input_file) > 0 then
        vim.cmd("term " .. compile_command .. " && " .. root_name .. " <" .. input_file .. " && echo '\\n\\npicked input from input.txt'")
      else
        vim.cmd("term " .. compile_command .. " && " .. root_name)
      end
    elseif file_extension == "py" then
      vim.cmd("term " .. compile_command)
    end
  end,
  desc = "Run C++ or Python file",
},
["<leader>rf"] = {
  function()
    local current_file = vim.fn.expand("%:p")
    local root_name = vim.fn.fnamemodify(current_file, ":r")
    local file_extension = vim.fn.expand("%:e")
    local compile_command = ""
    

    local file_path = vim.fn.getcwd() .. '/run.py'

    if vim.fn.filereadable(file_path) ~= 1 then
        -- Prompt the user for the filename
        local user_input = vim.fn.input('Enter the filename: ')
        
        -- Check if the user input is not empty
        if user_input ~= '' then
            file_path = user_input
        else
            print("Invalid filename. Aborting.")
            return
        end
    end
    -- Search for a virtual environment and activate it
    local venv_activate = vim.fn.findfile('activate', vim.fn.getcwd())
    if venv_activate ~= '' then
        compile_command = 'source ' .. venv_activate .. ' && python3 ' .. file_path
    else
        compile_command = 'python3 ' .. file_path
    end
    
    -- Open a vertical split and run the terminal in the directory of the current file
    vim.cmd("vsplit | vertical resize -20 | cd " .. vim.fn.fnameescape(vim.fn.fnamemodify(current_file, ":h")))
    
    vim.cmd("term " .. compile_command)
  end,
  desc = "Run a flask webserver with gunicorn",
},
    ["<leader>r"] = { name = "Run" },
  },
  t = {
    -- setting a mapping to false will disable it
    -- ["<esc>"] = false,
  },
}
