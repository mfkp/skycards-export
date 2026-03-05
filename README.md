# SkyCards User Data Export

A shell script that logs into the SkyCards API and exports your user data to a local JSON file — which you can then upload to **[skystats.win](https://skystats.win/)** for a full interactive dashboard with visualizations and search.

---

## Prerequisites

The script requires **`curl`** and **`jq`** to be installed.

### macOS

Both tools can be installed via [Homebrew](https://brew.sh/):

```bash
brew install curl jq
```

`curl` is also pre-installed on most modern macOS versions.

### Linux (Debian/Ubuntu)

```bash
sudo apt update && sudo apt install curl jq
```

For Fedora/RHEL:

```bash
sudo dnf install curl jq
```

### Windows

The script is a Bash script and requires a Unix-like shell environment on Windows. The easiest option is **Git Bash**, which comes bundled with [Git for Windows](https://git-scm.com/downloads).

1. Install [Git for Windows](https://git-scm.com/downloads) — Git Bash is included automatically.
2. Install `jq`:
   - Download the latest `jq` Windows binary from [jq releases](https://github.com/jqlang/jq/releases).
   - Rename the downloaded file to `jq.exe` and place it somewhere on your PATH (e.g., `C:\Program Files\Git\usr\bin\`).

Alternatively, you can use [WSL (Windows Subsystem for Linux)](https://learn.microsoft.com/en-us/windows/wsl/install) and follow the Linux instructions above.

---

## Usage

### 1. Download the script

```bash
curl -O https://raw.githubusercontent.com/mfkp/skycards-export/main/skycards_export.sh
```

Or clone the repository:

```bash
git clone https://github.com/mfkp/skycards-export.git
cd skycards-export
```

### 2. Make the script executable

**macOS / Linux / Git Bash (Windows):**

```bash
chmod +x skycards_export.sh
```

### 3. Run the script

```bash
./skycards_export.sh
```

You will be prompted for your SkyCards **email** and **password**. The password input is hidden as you type.

```
Email: you@example.com
Password:
Logging in...
Success! User data saved to: skycards_user.json
```

---

## Output

The script saves your exported data to **`skycards_user.json`** in the current directory. The file contains:

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

Once you have `skycards_user.json`, head over to **[skystats.win](https://skystats.win/)** and upload the file for a full interactive dashboard — including stats, charts, and searchable card data.

---

## Troubleshooting

**`jq: command not found`** — Install `jq` using the instructions in the Prerequisites section above.

**`curl: command not found`** — Install `curl` or use Git Bash / WSL on Windows.

**`API Error: ...`** — Double-check your email and password. Make sure your SkyCards account is active.

**`Failed to connect to the API`** — Check your internet connection and try again.
