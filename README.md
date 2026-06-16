# Debian Setup Scripts

These Bash scripts automates the setup process for a Debian system. Currently for Debian 12 - Bookworm but will be updated for new versions. 

## Prerequisites

- A fresh installation of Debian.
- Access to a user account with root privileges.

**Important:**  To grant root privileges to your regular user, add the user to the `sudo` group as follows:

1. Install the `sudo` package:
   ```shell
   apt install sudo
   ```

2. Add your user to the `sudo` group:
   ```shell
   usermod -aG sudo <username>
   ```
   Replace `<username>` with your actual username.

## What does it contain
1. General configuration of Debian includes apt and non-apt packages
2. Installing and Configuring GIT
3. Downlaoding latest python from source and setting up Virtual environment
4. Installing and configuring docker and docker compose
## Disclaimer

Please use this script at your own risk. It is recommended to review the script and ensure it aligns with your system requirements before running it. We are not responsible for any damages or data loss caused by the use of this script.

