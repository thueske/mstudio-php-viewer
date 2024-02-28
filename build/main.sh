#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'
BOLD='\033[1m'
LIGHT_CYAN='\033[1;36m'

if [ -z "$MITTWALD_API_TOKEN" ]; then
    echo -e "${RED}Die Umgebungsvariable MITTWALD_API_TOKEN ist nicht gesetzt. Bitte erstellen Sie einen API-Token unter: https://studio.mittwald.de/app/profile/api-tokens und setzen Sie diesen als Umgebungsvariable.${NC}"
    exit 1
fi

projects_json=$(mw project list --output=json)

project_count=$(echo "$projects_json" | jq '. | length')

echo -e "${BOLD}Gefundene Projekte: ${project_count}${NC}\n"

for ((i=0; i<project_count; i++)); do
    project_short_id=$(echo "$projects_json" | jq -r ".[$i].shortId")
    project_description=$(echo "$projects_json" | jq -r ".[$i].description")

    echo -e "${BOLD}${LIGHT_CYAN}Projekt:${NC} ${GREEN}$project_description${NC} (${BOLD}shortId: $project_short_id${NC})"

    app_list_json=$(mw app list --project-id "$project_short_id" --output=json)
    app_count=$(echo "$app_list_json" | jq '. | length')

    if [ "$app_count" -eq 0 ]; then
        echo -e "  ${RED}Keine App installiert.${NC}"
        continue
    fi

    php_app_found=false

    for ((j=0; j<app_count; j++)); do
        app_id=$(echo "$app_list_json" | jq -r ".[$j].id")
        app_description=$(echo "$app_list_json" | jq -r ".[$j].description")
        system_software_count=$(echo "$app_list_json" | jq ".[$j].systemSoftware | length")

        if [ "$system_software_count" -eq 0 ]; then
            continue
        fi

        for ((k=0; k<system_software_count; k++)); do
            system_software_id=$(echo "$app_list_json" | jq -r ".[$j].systemSoftware[$k].systemSoftwareId")

            if [ "$system_software_id" == "c42293f3-c2df-40d9-a5c9-4fa2ffdc36aa" ]; then
                php_app_found=true
                desired_version_id=$(echo "$app_list_json" | jq -r ".[$j].systemSoftware[$k].systemSoftwareVersion.desired")

                php_version_json=$(mw app dependency versions php -o json)
                php_version=$(echo "$php_version_json" | jq -r --arg id "$desired_version_id" '.[] | select(.id == $id) | .externalVersion')

                mstudio_link="https://studio.mittwald.de/app/projects/$project_id/apps/$app_id/general"

                echo -e "  ${BOLD}App:${NC} ${GREEN}$app_description${NC}"
                echo -e "    ${BOLD}PHP-Version:${NC} ${LIGHT_CYAN}$php_version${NC}"
                echo -e "    ${BOLD}mStudio Link:${NC} $mstudio_link"
            fi
        done
    done

    if [ "$php_app_found" == "false" ]; then
        echo -e "  ${RED}Keine App mit Abhängigkeit PHP installiert.${NC}"
    fi

    echo ""
done