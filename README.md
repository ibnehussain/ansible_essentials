# Ansible Essentials — Lab Index

This repository contains a series of hands-on Ansible labs. Each lab is a standalone Markdown file named `Lab_01.md` through `Lab_10.md`.

Use this index to jump to a lab, review objectives, and follow step-by-step instructions.

## Labs

- [Lab 01 — Installation and Configuration of Ansible](./Lab_01.md)
  - Set up a RHEL 9 control node, install Python/pip, Ansible, AWS CLI, and prepare an inventory.
- [Lab 02 — Exploring Ad-Hoc Commands](./Lab_02.md)
  - Practice ad-hoc modules (command, user, file, copy, lineinfile) and simple inventory edits.
- [Lab 03 — Implementing Ansible Playbook](./Lab_03.md)
  - Create playbooks to install/uninstall Apache and manage files on hosts.
- [Lab 04 — Exploring more on Ansible Playbooks](./Lab_04.md)
  - Tasks to create users, directories, files, and use `blockinfile` and step execution.
- [Lab 05 — Implementing Ansible Variables](./Lab_05.md)
  - Use variables, `--extra-vars`, and separate `vars_files` to parameterize playbooks.
- [Lab 06 — Task Inclusion](./Lab_06.md)
  - Split tasks into included files and conditionally include them with `when`.
- [Lab 07 — Implementing Ansible Vault](./Lab_07.md)
  - Encrypt/decrypt playbooks and secrets using `ansible-vault`.
- [Lab 08 — Working with Ansible Functions](./Lab_08.md)
  - Loops, tags, prompts, `until`, `run_once`, and `block`/`rescue` examples.
- [Lab 09 — Implementing Jinja2 Templates](./Lab_09.md)
  - Use the `template` module and Jinja2 templates to render files like `/etc/motd`.
- [Lab 10 — Implementing Ansible Roles](./Lab_10.md)
  - Build role directory structures, use `roles:` in playbooks and install Galaxy roles.

## Quick ways to view a lab (PowerShell)

Open a file in Notepad:

```powershell
notepad .\Lab_01.md
```

Print the file to the terminal (paged):

```powershell
Get-Content .\Lab_01.md -Raw | Out-Host
```

Or open the folder in VS Code (if installed):

```powershell
code .
```

## Notes

- Sensitive values (API keys, secrets) were removed from the lab files — replace with your own credentials when running commands.
- If you want, I can standardize all lab files to include: Objective, Prerequisites, Steps, Verification, Troubleshooting. Shall I proceed to apply that to Labs 2–10?

---

Last updated: November 4, 2025
