# Lisää tämä ~/.bashrc tai ~/.zshrc -tiedostoon:
# source ~/.config/dotfiles/scripts/copilot-docker-function.sh

cpd() {
    local project_name="${1:-.}"
    local repo_path="${2:-.}"
    
    # Etsitään script
    local script_path
    if [[ -f "$HOME/checkout/dotFiles/scripts/copilot-docker.sh" ]]; then
        script_path="$HOME/checkout/dotFiles/scripts/copilot-docker.sh"
    elif [[ -f "./copilot-docker.sh" ]]; then
        script_path="./copilot-docker.sh"
    else
        echo "Virhe: copilot-docker.sh ei löytynyt"
        return 1
    fi
    
    # Aja script
    "$script_path" "$project_name" "$repo_path"
}

# Completion for bash
if [[ -n "$BASH_VERSION" ]]; then
    _cpd_completion() {
        local cur="${COMP_WORDS[COMP_CWORD]}"
        local repos=$(ls -d ~/checkout/*/ 2>/dev/null | xargs -n1 basename | tr '\n' ' ')
        COMPREPLY=($(compgen -W ". $repos" -- "$cur"))
    }
    complete -F _cpd_completion cpd
fi
