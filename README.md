# 🎬 MacOS Jellyfin Anime4K Upscaler

A smart, lightweight, and bilingual (EN/FR) terminal utility to instantly install and toggle [Anime4K](https://github.com/bloc97/Anime4K) shaders on **Jellyfin Media Player** for macOS. 

Perfectly optimized for Apple Silicon (M1/M2/M3/M4/M5) Macs, including fanless models like the MacBook Air.

## ✨ Features
* **1-Click Install:** Automatically downloads the latest Anime4K shaders and places them in the correct macOS directories.
* **Auto-Restart:** Automatically kills and restarts Jellyfin to apply shaders instantly.
* **Smart Toggles:** Switch between profiles depending on your Mac's thermal capacity.
* **Bilingual:** Choose English or French during installation.
* **Shell Support:** Native aliases created for both `zsh` (macOS default) and `fish`.

## 🚀 Installation

Open your macOS Terminal and paste this single command:

    curl -sL https://raw.githubusercontent.com/Louka2b/MacOS_anime_jellyfin_upscale/main/install.sh | bash

*The installer will ask you to choose your language (FR/EN) and automatically configure the `up` and `upscale` commands for your terminal.*

*(Note: After installation, restart your terminal or open a new tab for the commands to load).*

## 🎮 Usage

Make sure Jellyfin Media Player is installed on your Mac. Then, type one of these commands anywhere in your terminal:

* `up` : View the currently active shader mode.
* `up --max` : **Ultimate Quality.** Best for desktop Macs or MacBook Pros with active cooling. (Warning: May cause thermal throttling on fanless MacBook Airs).
* `up --mid` : **Air Optimized.** A perfectly balanced preset. Keeps the sharp Anime4K lines without overheating your fanless Mac.
* `up --low` : **Battery Saver.** Disables all shaders and runs Jellyfin in its native state.
* `up --wipe` : **Factory Reset.** Deletes all shaders, caches, and Jellyfin configurations if you encounter a persistent bug.

*(You can also use the word `upscale` instead of `up`)*.

## 🙏 Credits
* Shaders powered by the incredible [Anime4K project by bloc97](https://github.com/bloc97/Anime4K).
