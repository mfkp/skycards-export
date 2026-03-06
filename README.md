# SkyCards User Data Export

Scripts that log into the SkyCards API and export your user data to a local JSON file, which you can then upload to **[skystats.win](https://skystats.win/)** for a full interactive dashboard with visualizations and search.

This repository includes:

- `skycards_export.sh` for macOS, Linux, and Bash-compatible shells
- `skycards_export.ps1` for native Windows PowerShell

---

## Prerequisites

### macOS / Linux / Git Bash

The Bash script requires **`curl`** and **`jq`**.

macOS with [Homebrew](https://brew.sh/):

```bash
brew install curl jq
```

Debian / Ubuntu:

```bash
sudo apt update && sudo apt install curl jq
```

Fedora / RHEL:

```bash
sudo dnf install curl jq
```

### Windows PowerShell

The PowerShell script uses built-in Windows tooling. No additional dependencies are required beyond Windows PowerShell 5.1 or PowerShell 7+.

---

## Usage

### Download the script directly

macOS / Linux / Git Bash:

```bash
curl -O https://raw.githubusercontent.com/mfkp/skycards-export/main/skycards_export.sh
chmod +x skycards_export.sh
./skycards_export.sh
```

Windows PowerShell:

```powershell
Invoke-WebRequest -Uri https://raw.githubusercontent.com/mfkp/skycards-export/main/skycards_export.ps1 -OutFile skycards_export.ps1
powershell -ExecutionPolicy Bypass -File .\skycards_export.ps1
```

### Or clone the repository

```bash
git clone https://github.com/mfkp/skycards-export.git
cd skycards-export
```

Run the Bash script on macOS, Linux, or Git Bash:

```bash
chmod +x skycards_export.sh
./skycards_export.sh
```

Run the PowerShell script on Windows:

```powershell
powershell -ExecutionPolicy Bypass -File .\skycards_export.ps1
```

Both scripts prompt for your SkyCards **email** and **password**. The password input is hidden as you type.

```text
Email: you@example.com
Password:
Logging in...
Success! User data saved to: skycards_user.json
```

The PowerShell script also supports optional parameters such as `-Email` and `-OutputFile`.

---

## Output

The scripts save your exported data to **`skycards_user.json`** in the current directory. The file contains:

| Field | Description |
|---|---|
| `id` | Your user ID |
| `name` | Display name |
| `xp` | Total experience points |
| `cards` | Your card collection |
| `numAircraftModels` | Number of distinct aircraft models collected |
| `numDestinations` | Number of destinations unlocked |
| `numBattleWins` | Total battle wins |
| `numAchievements` | Number of achievements earned |
| `unlockedAirportIds` | List of unlocked airport IDs |
| `uniqueRegs` | Unique aircraft registrations |

---

## Visualize Your Data

Once you have `skycards_user.json`, head over to **[skystats.win](https://skystats.win/)** and upload the file for a full interactive dashboard, including stats, charts, and searchable card data.

---

## Troubleshooting

**`jq: command not found`** - Install `jq` using the Bash prerequisites above.

**`curl: command not found`** - Install `curl`, or use the PowerShell script on Windows.

**`File cannot be loaded because running scripts is disabled on this system`** - Run the PowerShell script with `powershell -ExecutionPolicy Bypass -File .\skycards_export.ps1`.

**`API Error: ...`** - Double-check your email and password. Make sure your SkyCards account is active.

**`Failed to connect to the API`** - Check your internet connection and try again.
