# Bash completion for blnvim (blackmatter neovim)

_blnvim() {
  local cur prev opts
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"

  opts="-u --cmd -c -d -e -es -h --headless -l -n -o -O -p -r -R -S --startuptime -V --version --clean --noplugin"

  case "$prev" in
    -u|-l|-r|-S|--startuptime)
      COMPREPLY=($(compgen -f -- "$cur"))
      return 0
      ;;
  esac

  if [[ "$cur" == -* ]]; then
    COMPREPLY=($(compgen -W "$opts" -- "$cur"))
    return 0
  fi

  COMPREPLY=($(compgen -f -- "$cur"))
}

complete -F _blnvim blnvim
