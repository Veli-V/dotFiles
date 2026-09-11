#!/bin/bash

set -e

PROJECT_NAME=""
REPO_PATH=""
CONTAINER_NAME=""

get_project_name() {
    if [[ "$1" == "-" ]]; then
        PROJECT_NAME="copilot-shell"
        echo "Copilot shell (ilman projektia)"
        return
    elif [[ "$1" == "." ]]; then
        PROJECT_NAME=$(basename "$(pwd)")
        echo "Projektin nimi: $PROJECT_NAME"
    else
        read -p "Anna projektin nimi (tai '-' ilman projektia): " PROJECT_NAME
        if [[ -z "$PROJECT_NAME" ]]; then
            echo "Virhe: projektin nimi ei voi olla tyhjä"
            exit 1
        fi
    fi
    CONTAINER_NAME="copilot-$PROJECT_NAME"
}

find_repo_path() {
    local default_repo="$HOME/checkout/$PROJECT_NAME"
    
    # Tarkista onko polku jo annettu argumentissa
    if [[ -n "$1" ]]; then
        if [[ "$1" == "." ]]; then
            # Nykyinen kansio
            REPO_PATH="$(pwd)"
        elif [[ "$1" = /* ]]; then
            # Absoluuttinen polku
            REPO_PATH="$1"
        else
            # Suhteellinen polku
            REPO_PATH="$HOME/$1"
        fi
        
        if [[ ! -d "$REPO_PATH" ]]; then
            echo "Virhe: kansio '$REPO_PATH' ei ole olemassa"
            exit 1
        fi
        echo "Repository: $REPO_PATH"
        return
    fi
    
    # Tarkista oletuspolku
    if [[ -d "$default_repo" ]]; then
        REPO_PATH="$default_repo"
        echo "Löytyi repository: $REPO_PATH"
        return
    fi
    
    # Listaa käytettävissä olevat repot
    echo "Repository ei löytynyt oletuspolusta: $default_repo"
    echo ""
    echo "Käytettävissä olevat repot ~/checkout/ kansiosta:"
    
    if [[ ! -d "$HOME/checkout" ]]; then
        echo "Virhe: ~/checkout kansio ei ole olemassa"
        exit 1
    fi
    
    local repos=()
    while IFS= read -r -d '' dir; do
        repos+=("$(basename "$dir")")
    done < <(find "$HOME/checkout" -maxdepth 1 -type d -not -name "checkout" -print0 2>/dev/null | sort -z)
    
    if [[ ${#repos[@]} -eq 0 ]]; then
        echo "Ei repoja löytynyt. Syötä koko polku:"
        read -p "Polku: " REPO_PATH
        if [[ ! -d "$REPO_PATH" ]]; then
            echo "Virhe: kansio '$REPO_PATH' ei ole olemassa"
            exit 1
        fi
        return
    fi
    
    for i in "${!repos[@]}"; do
        echo "$((i+1)). ${repos[$i]}"
    done
    echo "$((${#repos[@]}+1)). Syötä koko polku"
    
    local choice
    read -p "Valitse: " choice
    
    if [[ "$choice" =~ ^[0-9]+$ ]] && ((choice >= 1 && choice <= ${#repos[@]})); then
        REPO_PATH="$HOME/checkout/${repos[$((choice-1))]}"
    elif ((choice == ${#repos[@]}+1)); then
        read -p "Polku: " REPO_PATH
        if [[ ! -d "$REPO_PATH" ]]; then
            echo "Virhe: kansio '$REPO_PATH' ei ole olemassa"
            exit 1
        fi
    else
        echo "Virheellinen valinta"
        exit 1
    fi
    
    echo "Valittu repository: $REPO_PATH"
}

container_exists() {
    docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"
}

connect_to_container() {
    if docker ps --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
        echo "Kontti $CONTAINER_NAME on käynnissä. Yhdistetään..."
        docker exec -it "$CONTAINER_NAME" /usr/local/bin/entrypoint.sh
    else
        echo "Kontti $CONTAINER_NAME on pysäytetty. Käynnistetään..."
        docker start "$CONTAINER_NAME"
        sleep 1
        echo "Yhdistetään konttiin..."
        docker exec -it "$CONTAINER_NAME" /usr/local/bin/entrypoint.sh
    fi
}

get_copilot_token() {
    local token_file="$HOME/.config/copilot-cli/github_token"
    
    # Tarkista onko token jo tallennettu home-kansioon
    if [[ -f "$token_file" ]]; then
        COPILOT_GITHUB_TOKEN=$(cat "$token_file")
        if [[ -n "$COPILOT_GITHUB_TOKEN" ]]; then
            echo "Token löytyi: ~/.config/copilot-cli/github_token"
            return 0
        fi
    fi
    
    # Kysy token interaktiivisesti
    echo ""
    echo "COPILOT_GITHUB_TOKEN ei löytynyt."
    echo "Vaihtoehdot:"
    echo "1. Syötä token nyt (tallennetaan ~/.config/copilot-cli/github_token)"
    echo "2. Oleta että se on jo asetettu muualla"
    
    read -p "Valinta (1-2): " token_choice
    
    if [[ "$token_choice" == "1" ]]; then
        read -sp "Anna COPILOT_GITHUB_TOKEN: " COPILOT_GITHUB_TOKEN
        echo ""
        
        if [[ -z "$COPILOT_GITHUB_TOKEN" ]]; then
            echo "Virhe: token ei voi olla tyhjä"
            exit 1
        fi
        
        # Tallenna ~/.config/copilot-cli-kansioon
        mkdir -p "$HOME/.config/copilot-cli"
        echo "$COPILOT_GITHUB_TOKEN" > "$token_file"
        chmod 600 "$token_file"
        echo "Token tallennettu: $token_file"
    fi
}

create_container() {
    echo "Luodaan uusi kontti: $CONTAINER_NAME"
    echo "Repository: $REPO_PATH"
    
    get_copilot_token
    
    local docker_opts=(
        "-it"
        "--name" "$CONTAINER_NAME"
        "-v" "$HOME/.config/copilot-cli:/root/.config/copilot-cli"
        "-v" "$REPO_PATH:/workspace"
    )
    
    # Lisää token ympäristömuuttujana jos se on asetettu
    if [[ -n "$COPILOT_GITHUB_TOKEN" ]]; then
        docker_opts+=("-e" "COPILOT_GITHUB_TOKEN=$COPILOT_GITHUB_TOKEN")
    fi
    
    docker run "${docker_opts[@]}" copilot-dev
}

create_container_no_repo() {
    echo "Luodaan copilot shell (ilman projektia)"
    
    get_copilot_token
    
    local docker_opts=(
        "-it"
        "--name" "$CONTAINER_NAME"
        "-v" "$HOME/.config/copilot-cli:/root/.config/copilot-cli"
    )
    
    # Lisää token ympäristömuuttujana jos se on asetettu
    if [[ -n "$COPILOT_GITHUB_TOKEN" ]]; then
        docker_opts+=("-e" "COPILOT_GITHUB_TOKEN=$COPILOT_GITHUB_TOKEN")
    fi
    
    docker run "${docker_opts[@]}" copilot-dev
}

main() {
    get_project_name "$1"
    
    if [[ "$PROJECT_NAME" == "copilot-shell" ]]; then
        # Pelkkä copilot ilman projektia
        find_repo_path ""
        create_container_no_repo
    elif container_exists; then
        echo "Kontti $CONTAINER_NAME on olemassa."
        find_repo_path "$2"
        connect_to_container
    else
        find_repo_path "$2"
        create_container
    fi
}

main "$@"
