# mStudio PHP-Version-Viewer

This script automates the process of checking and listing the PHP versions used by apps within projects hosted on mittwald mStudio platform. It iterates through all available projects, lists each app, and displays the PHP version along with a direct link to the app's settings in mittwald mStudio.

## Prerequisites

To run this script, you'll need:

- Docker environment
- Valid `MITTWALD_API_TOKEN`: [Generate API Token](https://studio.mittwald.de/app/profile/api-tokens)

## Installation
`docker run --rm -e MITTWALD_API_TOKEN='INSERTYOURTOKEN' ghcr.io/thueske/mstudio-php-viewer:latest`