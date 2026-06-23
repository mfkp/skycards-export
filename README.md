# SkyCards User Data Export

Scripts that log into the SkyCards API and export your user data to a local JSON file, which you can then upload to **[skystats.win](https://skystats.win/)** for a full interactive dashboard with stats, charts, and searchable card data.

---

## Quick Start

### Windows

1. **Open PowerShell** — press `Win + R`, type `powershell`, and hit Enter
2. **Download and run the script** by pasting this into PowerShell:

```powershell
Invoke-WebRequest -Uri https://raw.githubusercontent.com/mfkp/skycards-export/main/skycards_export.ps1 -OutFile skycards_export.ps1
powershell -ExecutionPolicy Bypass -File .\skycards_export.ps1
```

### macOS

1. **Open Terminal** — press `Cmd + Space`, type `Terminal`, and hit Enter
2. **Download and run the script** by pasting this into Terminal:

```bash
curl -O https://raw.githubusercontent.com/mfkp/skycards-export/main/skycards_export.sh
chmod +x skycards_export.sh
./skycards_export.sh
```

### Linux

```bash
curl -O https://raw.githubusercontent.com/mfkp/skycards-export/main/skycards_export.sh
chmod +x skycards_export.sh
./skycards_export.sh
```

---

## Logging In

When prompted, enter your **SkyCards app email and password** — the same credentials you use to log into the SkyCards mobile app. Your password won't be visible as you type.

```text
Email: you@example.com
Password:
Logging in...
Success! User data saved to: skycards_user.json
```

The file `skycards_user.json` will be saved in the same folder where you ran the script.

---

## Upload to skystats.win

Once you have `skycards_user.json`, go to **[skystats.win](https://skystats.win/)** and drag and drop (or browse for) the file to load your full dashboard.

---

## Prerequisites

### macOS

`curl` is pre-installed. If `jq` is missing, install it with [Homebrew](https://brew.sh/):

```bash
brew install jq
```

### Linux

```bash
# Debian / Ubuntu
sudo apt update && sudo apt install curl jq

# Fedora / RHEL
sudo dnf install curl jq
```

### Windows

No additional software required — the PowerShell script uses built-in Windows tooling (PowerShell 5.1 or newer).

---

## Troubleshooting

**"jq: command not found"**
Install `jq` using the instructions in the Prerequisites section above.

**"File cannot be loaded because running scripts is disabled on this system"**
Make sure you're running the script with `powershell -ExecutionPolicy Bypass -File .\skycards_export.ps1` as shown in the Quick Start section.

**"API Error: Invalid credentials" or similar**
Double-check your email and password. These should be your SkyCards app login details.

**"Failed to connect to the API"**
Check your internet connection and try again. If the problem persists, the SkyCards API may be temporarily unavailable.

---

## Output File Reference

The exported `skycards_user.json` contains the following fields:

| Field | Description |
|---|---|
| `skycardsVersion` | Script version used to generate this file |
| `id` | Your user ID |
| `name` | Display name |
| `xp` | Total experience points |
| `cards` | Your card collection |
| `numAircraftModels` | Number of distinct aircraft models collected |
| `numDestinations` | Number of destinations unlocked |
| `numBattleWins` | Total battle wins |
| `numAchievements` | Number of achievements earned |
| `numFleets` | Number of airline fleets joined |
| `unlockedAirportIds` | List of unlocked airport IDs |
| `uniqueRegs` | Unique aircraft registrations spotted |

---

## Advanced

### Clone the repository

```bash
git clone https://github.com/mfkp/skycards-export.git
cd skycards-export
./skycards_export.sh        # macOS / Linux
```

### PowerShell optional parameters

```powershell
.\skycards_export.ps1 -Email you@example.com -OutputFile my_data.json
```
