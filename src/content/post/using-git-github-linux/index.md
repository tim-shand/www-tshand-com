---
author: Tim Shand
title: Using Git with GitHub on Linux
date: 2025-03-20
description: Guide to using Git with remote Github repositories on Linux.
image: luca-bravo-XJXWbfSo2f0-unsplash_medium.jpg
categories:
    - guide
tags:
    - gitops
    - linux
---

## Introducing Git

This guide serves to provide a base for getting started using Git on Linux with remote repositories located in GitHub. Git is an important tool for those working in, or interested in DevOps and software development.  

Git provides a version control system for code, providing developers and engineers the ability to store code, and review the history of a project. For more information on Git and how it is used, check out the [Github documentation](https://docs.github.com/en/get-started/using-git/about-git). 

### Concepts

#### Git
A version control system that helps developers and engineers track changes in their code over time. It allows you to save snapshots of your work (commits), so you can review, undo, or compare changes. Git is useful when working within a team as it supports collaboration by letting multiple people work on the same project without interfering with each other’s changes. 

#### Repository (repo)
This is where the project's files and history are stored. Think of it as a folder that not only contains your code but also an audit trail of every change made. Repositories can be stored locally or hosted online (GitHub or GitLab) so others can access and contribute to the project. With Git, you can create branches in a repository to test new features or fix bugs without affecting the main code until you're ready to merge it in.


### Reasons To Use Git

**1. Version Control and Collaboration**  
Git enables developers to track every change in a code base, including configuration files, and infrastructure as code (IaC). 
This is important in relation to DevOps for:

- **Rolling Back Versions** 
  - If bad code is committed to the main branch, it can be rolled back to a previous version, to time before the problematic code was committed. 
- **Ensuring traceability and accountability**
  - Each developer commits changes using their own unique identity, providing transparency on who did what, and when. 
- **Team Involvement** 
  - Multiple developers and other cross-team members (testers, IT Ops) can work on the same code base without overwriting the work done by someone else, using Git features such as pull requests, branches and merging of changes. 

**2. Automation and CI/CD Integration**  
Git integrates with CI/CD tools such as Jenkins, Azure DevOps, GitHub Actions, and GitLab CI. This enables:

- Automatic testing and deployment of code on commits
- Triggering pipelines on pull requests or branch merges
- Infrastructure provisioning using GitOps practices

**3. Infrastructure as Code (IaC)**  
Git is commonly used to manage Terraform, Ansible, Helm, and other IaC tools. 
These tools allow engineers to utilize a declarative software-defined approach to infrastructure deployments. This helps with:

- Allowing for peer-reviews of infrastructure changes
- Ensuring repeatable and consistent environment delpoyments
- Controlled deployment of infrastructure alongside application code

## Requirements

- **An active Github account**
  - Create one for free [here](https://github.com/signup)!
- **Linux operating system**
  - This can be a local or virtual machine, remote server or WSL on Windows. 
- **Basic familiarity with terminal use**
  - Either in Windows or Linux, basic existing knowledge will be helpful. 

## Preparation

### Installing Required Packages

1. Update package repository lists and upgrade installed packages for your chosen Linux distribution.

```bash
# Ubuntu, Debian
sudo apt update && sudo apt upgrade

# Fedora, CentOS, Rocky
sudo dnf upgrade
```

2. Install the Git and GitHub CLI packages from distribution repository.

```bash
# Ubuntu, Debian
sudo apt install git gh

# Fedora, CentOS, Rocky
sudo dnf install git gh
```

3. Confirm installation for both Git and GH packages.

```bash
git --version && gh --version
```

### Initial Configuration and Authentication

**Note:** Git utilizes a 'username' to associate commits with an identity. The Git username is not the same as a GitHub username. 

1. Set the global Git user properties.

```bash
# Set the Git username for all repositories locally.
git config --global user.name "Test User"

# Set the email address used to author commits on GitHub and locally.
git config --global user.email "testuser@mail.com"
```

2. Confirm the global settings are correct.  
`git config user.name && git config user.email`  

3. Authenticate to GitHub.  
`gh auth login`  

4. Follow the prompts in the terminal, selecting the following:
- What account do you want to log into? **GitHub.com**
- What is your preferred protocol for Git operations on this host? **HTTPS**
- How would you like to authenticate GitHub CLI? **Login with a web browser**
- First copy your one-time code: *** - ***

**Output:**
```bash 
Press Enter to open github.com in your browser... 
✓ Authentication complete.
- gh config set -h github.com git_protocol https
✓ Configured git protocol
✓ Logged in as test-user
```

## Using Git with Remote GitHub Repositories

### Scenario 1: Create new local and remote repositories and push local files.
_**Use Case:** New project with no existing files or repositories (starting from scratch)._ 

This method will initialize Git to use a local Git repository with a newly generated remote repository in GitHub. 

1. Create a new project folder "new-repo" in your home directory and change into it.  
`mkdir ~/new-repo && cd ~/new-repo` 

2. Create a new remote repository on GitHub interactively via the terminal.  
`gh repo create` 

3. Follow the prompts provided in the terminal:
- What would you like to do? **Create a new repository on GitHub from scratch**
- Repository name: **new-repo**
- Description: **Test repo for learning Git.**
- Visibility: **Private**
- Would you like to add a README file? **No**
- Would you like to add a .gitignore? **No**
- Would you like to add a license? **No**
- This will create _"new-repo"_ as a private repository on GitHub. Continue? **Yes**
- Clone the new repository locally? **No**

**Output:** 
```bash
✓ Created repository test-user/new-repo on GitHub
https://github.com/test-user/new-repo
```

4. Create a local `README.md` markdown file to provide a description of the project. 
```bash
# Create the file using the 'touch' command.
touch README.md

# Either use your preferred text editor, or simply append a string into the file.
echo "# Test Readme File" > README.md
```

5. Initialize the local directory as a Git repository and set the name of the default branch.  
`git init -b main` 

6. Stage all the files in the project directory, preparing for the first commit.  
`git add .` 

7. Commit the staged files in the project directory to the local Git repository.  
`git commit -m "Initial commit"` 

**Output:** 
```bash
[main (root-commit) bdc8375] Initial commit.
1 file changed, 1 insertion(+)
create mode 100644 README.md
```

8. Add the remote repository URL where the local repository will be pushed.  
`git remote add origin https://github.com/test-user/new-repo.git` 

9. Confirm that the remote repository is configured.  
`git remote -v` 

**Output:**
```bash
origin https://github.com/test-user/new-repo.git (fetch)
origin https://github.com/test-user/new-repo.git (push)
```

10. Push the changes in the local repository to the remote GitHub repository.  
`git push origin main` 

**Output:**
```bash
Enumerating objects: 3, done.
Counting objects: 100% (3/3), done.
Writing objects: 100% (3/3), 229 bytes | 229.00 KiB/s, done.
Total 3 (delta 0), reused 0 (delta 0), pack-reused 0 (from 0)
To https://github.com/test-user/new-repo.git
* [new branch] main -> main
```

11. Check the results in GitHub.  

- Login to GitHub via web browser to view the new repository and the README.md file. 

### Scenario 2: Pull existing GitHub repository into local project directory. 
_**Use Case:** Fresh OS install or operating on another machine without existing project files present._ 

1. Ensure all preparation steps have taken place. 
2. Create a project directory to pull the remote files into, and change into the directory.  
`mkdir ~/new-repo && cd ~/new-repo` 

3. Initialize a local Git repository using the branch name "main".  
`git init -b main` 

4. Add the remote GitHub repository as the remote source.  
`git remote add origin https://github.com/test-user/new-repo.git` 

5. Pull down the remote repository files from GitHub.  
`git pull origin main` 

6. Edit the README.md file and commit to the local Git repository.  
`git add .`  
`git commit -m "Updated the README file."`  

**Output:**
```bash
[main 7838951] Updated README file.
1 file changed, 2 insertions(+)
```

7. Push the changes to the remote GitHub repository. 
`git push origin main` 

**Output:** 
```bash
Enumerating objects: 5, done.
Counting objects: 100% (5/5), done.
Writing objects: 100% (3/3), 286 bytes | 286.00 KiB/s, done.
Total 3 (delta 0), reused 0 (delta 0), pack-reused 0 (from 0)
To https://github.com/test-user/new-repo.git
bdc8375..7838951 main -> main
```

8. Confirm README file is showing updated changes in GitHub via web browser. 

**Complete!**

---

## Commands Cheat Sheet

### Git Configuration
| Command                                            | Purpose             | Example                                             |
| -------------------------------------------------- | ------------------- | --------------------------------------------------- |
| `git config --global user.name "Your Name"`        | Set global username | `git config --global user.name "John Doe"`          |
| `git config --global user.email "you@example.com"` | Set global email    | `git config --global user.email "john@example.com"` |
| `git config --global core.editor nano`             | Set default editor  | `git config --global core.editor nano`              |
| `git config --list`                                | View current config | -                                                   |

### Repository Setup
| Command           | Purpose             | Example                                      |
| ----------------- | ------------------- | -------------------------------------------- |
| `git init`        | Initialize new repo | `git init`                                   |
| `git clone <url>` | Clone existing repo | `git clone https://github.com/user/repo.git` |

### Remote Repositories
| Command                       | Purpose             | Example                                                  |
| ----------------------------- | ------------------- | -------------------------------------------------------- |
| `git remote -v`               | View remotes        | -                                                        |
| `git remote add origin <url>` | Add remote          | `git remote add origin https://github.com/user/repo.git` |
| `git push -u origin main`     | Push + set upstream | -                                                        |
| `git fetch`                   | Fetch updates       | `git fetch origin`                                       |

### Basic Workflow
| Command                   | Purpose                 | Example                          |
| ------------------------- | ----------------------- | -------------------------------- |
| `git status`              | Check changes/status    | `git status`                     |
| `git add <file>`          | Stage file              | `git add index.html`             |
| `git add .`               | Stage all changes       | `git add .`                      |
| `git commit -m "message"` | Commit staged changes   | `git commit -m "Initial commit"` |
| `git push`                | Push to remote          | `git push origin main`           |
| `git pull`                | Pull latest from remote | `git pull origin main`           |

### Branches
| Command                  | Purpose            | Example                     |
| ------------------------ | ------------------ | --------------------------- |
| `git branch`             | List branches      | `git branch`                |
| `git branch <name>`      | Create new branch  | `git branch dev`            |
| `git checkout <branch>`  | Switch branch      | `git checkout dev`          |
| `git checkout -b <name>` | Create + switch    | `git checkout -b feature-x` |
| `git merge <branch>`     | Merge into current | `git merge dev`             |
| `git branch -d <name>`   | Delete branch      | `git branch -d dev`         |

### Undoing Changes
| Command                  | Purpose                  | Example                     |
| ------------------------ | ------------------------ | --------------------------- |
| `git restore <file>`     | Undo uncommitted change  | `git restore index.html`    |
| `git reset HEAD <file>`  | Unstage file             | `git reset HEAD index.html` |
| `git checkout -- <file>` | Discard changes (legacy) | `git checkout -- file.txt`  |
| `git revert <commit>`    | Revert commit (safe)     | `git revert abc123`         |

### Viewing History
| Command             | Purpose              | Example           |
| ------------------- | -------------------- | ----------------- |
| `git log`           | View commit history  | `git log`         |
| `git log --oneline` | Condensed log        | -                 |
| `git diff`          | See unstaged changes | `git diff`        |
| `git show <commit>` | See specific commit  | `git show abc123` |

### Tags
| Command                | Purpose            | Example        |
| ---------------------- | ------------------ | -------------- |
| `git tag`              | List tags          | `git tag`      |
| `git tag v1.0`         | Create tag         | `git tag v1.0` |
| `git push origin v1.0` | Push tag to GitHub | -              |

### Delete Commits 
| Command                   | Purpose                         | Example |
| ------------------------- | ------------------------------- | ------- |
| `git reset --soft HEAD~1` | Undo last commit (keep changes) | -       |
| `git reset --hard HEAD~1` | Delete last commit + changes    | -       |

---

*Cover photo by [Luca Bravo](https://unsplash.com/@lucabravo?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash") on [Unsplash](https://unsplash.com/photos/turned-on-gray-laptop-computer-XJXWbfSo2f0?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash)*

