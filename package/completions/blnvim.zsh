#compdef blnvim
# Zsh completion for blnvim (blackmatter neovim)
# Delegates to nvim completions with blnvim-specific additions

_blnvim() {
  _arguments -s -S \
    '-u+[use this config file]:config file:_files' \
    '--cmd+[execute command before config]:command' \
    '-c+[execute command after config]:command' \
    '-d[diff mode]' \
    '-e[ex mode]' \
    '-es[silent ex mode]' \
    '-h[show help]' \
    '--headless[run without UI]' \
    '-l+[execute Lua script]:lua file:_files -g "*.lua"' \
    '-n[no swap file]' \
    '-o-[open N windows horizontally]:number' \
    '-O-[open N windows vertically]:number' \
    '-p-[open N tab pages]:number' \
    '-r+[recover from swap file]:swap file:_files' \
    '-R[read-only mode]' \
    '-S+[source file after loading]:session file:_files' \
    '--startuptime+[write startup timing to file]:timing file:_files' \
    '-V-[verbose level]:level' \
    '--version[show version]' \
    '--clean[skip config and plugins]' \
    '--noplugin[skip loading plugins]' \
    '*:file:_files'
}

_blnvim "$@"
