# 🛠️ linuxSetup-script

A simple, powerful, and beginner-friendly Bash automation script that sets up a fresh Ubuntu VM like a pro. It configures hostname, timezone, installs core packages, creates users, configures secure SSH, and logs everything — making this a good "Phase 1" learning project for aspiring SysAdmins, DevOps engineers, or for you automation nerds.

---

## 📦 Use Case: Why This Exists

You're setting up a brand-new Ubuntu virtual machine or VPS — and instead of doing the boring stuff manually (changing hostname, installing packages, creating users, configuring SSH), you just want to drop in one script and **let it take over**.

Whether it's for:
- Testing a clean environment
- Automating base server setup
- Learning Bash and Linux internals
- Practicing DevOps workflow

This script saves time, enforces best practices, and gets you used to thinking like a system engineer.

---

## 🖥️ How It Connects to Your VM

- 🔌 The VM is created in **Bridged Adapter** mode so it gets a real IP on your local network.
- 📤 You use `scp` (secure copy) from your host machine to send the script over to the VM via that IP.
- 🔐 The script is then run **inside the VM**, where it:
  - Installs packages like `vim`, `curl`, `ufw`, etc.
  - Sets the hostname and timezone
  - Adds a new user with sudo rights
  - Configures the SSH server securely (no root login, no password auth)
  - Optionally enables a firewall, SSH key login, custom MOTD, and more

This is exactly how you’d bootstrap a new server in the real world.

---

## 📁 Folder Structure

```bash
linuxSetup-script/
├── setup.sh           # 🔧 Main Bash script with all setup logic
├── logs/              # 🗂️ Where setup logs get stored (timestamped)
├── scripts/           # 🔁 For future modular sub-scripts or helpers
├── configs/           # ⚙️ Optional static config files (e.g., SSH banners, envs)
├── validate.sh        # ✅ (Optional) Verifies everything was configured properly
└── README.md          # 📖 This file
