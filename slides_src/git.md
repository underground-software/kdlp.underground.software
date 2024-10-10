---
theme: white
---

# Git
An open source version control system

---

# Version Control & Git vs. GitHub
- The management of changes to a project
- Git is specifically designed for version control of programming projects, provides a log of changes to your project. You can access previous instances of the project to help with collaboration, bug fixes, etc.
- Git is not GitHub
- GitHub is a website which can host your repositories to be available to the public. This is useful for group work and open source projects.

---

# More Git
- Git allows you to keep track of the previous states of your or someone else’s repo
- Each saved state of your repo has a hash identifier with which you can access said state
- A repo that is managed with Git will have a .git directory which will have information about all saved changes
- ls -a → To check hidden files not displayed by ls by default

---

# Visualization
We will use a tree structure to illustrate the behavior of how saved states of a repository behave when manipulated with git commands. E.g. Below is a repository which has three commits to the main branch and one commit to the X branch. The blue pointer indicates that we are viewing the first commit of the X branch.
![git tree](/images/Git/git_slide4.png)

---

# Diagram Key
![diagram key](/images/Git/git_slide5.png)

---

# Git Commands: git init
- Initialize the cwd as a git repository
- In order to use most other git commands, you will need to be in a folder containing an initialized repo first


---

# Git Commands: git clone
![git clone diagram](/images/Git/git_slide7.png)
Copies a repository that is hosted on GitHub, or similar website, to your local directory

---

# Git Commands: git add
- Adds a change, which was made to the repository, to a list of changes to be committed later on. This accounts for changes to an existing file or adding a new directory or file to the repo.
- 'git add .' adds all new files and changes to existing files in current directory to the index

---

# Git Commands: git commit
![git commit diagram](/images/Git/git_slide9.png)
- Saves the current state of your repository in Git. Changes are not live, need to push 
- git commit -m “somemessage” to add a short message to your commit and avoid opening your editor

---

# Git Commands: git status
Shows which changes are tracked by Git and which changes still need to be committed.

---

# SSH Keys
- To push your changes to your GitHub you need to link your local machine to your Github account.
- Generate SSH key
$ ssh-keygen -t rsa -b 4096 -C “your github email”
- Cat your public key file and highlight and copy it
$ cat ~/.ssh/id_rsa.pub
- On GH go to Settings/SSH and GPG keys/New SSH key
- Name your key and paste the public key in the key field
- Now you can push to GitHub

---

# Additional Details
- If you your local repo was created by cloning a remote repo, your local repo will already be linked with that remote.
- If you want to publish a repo you made locally on github, you will need to make an empty GitHub repo and find it’s link and set a remote to that link manually
$ git remote add origin git@github.com:whoever/whatever.git
$ git push origin main
- To set a default remote branch for future push operations on a given local branch do
$ git push -u origin main 
- And next time you push you can just do
$ git push


---

# Git Commands: git push
![git push diagram](/images/Git/git_slide13.png)
Uploads new Git commits to a remote repository. e.g. to GitHub

---

# Git Commands: git pull
![ git pull diagram](/images/Git/git_slide14.png)
Opposite of git push. Download changes locally from remote repository 

---

# Branching: uses
- The main stem of the repo is the main branch, in a group project main will be the ‘final’ version of the project.
- Branching is useful when group members have separate responsibilities to the project. 
- You can branch from main and work on your part of the project without disrupting main. 
- When you’re done and your code has been approved, your changes can be merged back into the main branch.
- Delete a branch with git branch -d name

---

# Branching
![git branching d1](/images/Git/git_slide16.png)
$ git branch
\* main
  feature1
- Use git branch to check which branches exist and which one you are currently working in

---

![git branching d2](/images/Git/git_slide17.png)
$ git checkout feature1
(switch to an existing branch)
$ git branch
  main
\* feature1

---

![git branching d3](/images/Git/git_slide18.png)
$ git checkout main; git branch
\* main
  feature1
$ git checkout -b feature2 (creates a new feature2 branch and brings you to it)
$ git branch
  main
  feature1
\* feature2

---

# Merging and pull requests(PR)
- If you are working on your own project you will use git merge to merge your branches into main.
- If you are merging a feature branch on to main you are creating a new commit to main where all previous main and feature commits are combined.
$ git branch
  main
\* other
$ git checkout main; git merge other; git diff other
- They will be the same if there are no conflicts

---

# Git Commands: git diff
- To compare the changes between the current branch and the feature branch
$ git diff feature
- To see what changes have been made to file.txt
$ git diff file.txt (if file.txt is staged)
- To see changes of all staged files
$ git diff
- For more advanced features
$ git diff --help

---

# Merging and pull requests
- When working on a group project, you will want to open a pull request to make sure that your group is satisfied with merging your branch to main
- First you will need to push your branch to GH
$ git push -u origin PRbranch
- Here you are setting origin for your local branch PRbranch to be your GH PRbranch. So your local PRbranch will only push to the same GH PRbranch
- Then, you can go on your GH and open a new pull request. You are requesting that your team review your proposed changes to main and then pull PRbranch into the main branch.

---

# Merging and pull requests
![merging d1](/images/Git/git_slide20_1.png)
$ git branch
\* main
  feature1
  feature2

---

![merging d2](/images/Git/git_slide20_2.png)
$ git merge feature1
- If you use the '--squash' tag, it will merge but stop before making the merge commit
$ git merge --squash feature1
\# Make some changes
$ git add . && git commit -m "some message"
- This allows you to make some more changes before you commit your merge

---

![merging d3](/images/Git/git_slide20_3.png)
$ git merge feature2

---

# Group project note
When new changes are pushed to main by other people in your group, in order to keep your branch up to date pull changes from your GH to your local machine and then merge local main into your branch. Just step one in the example.
![group project note diagram](/images/Git/git_slide21.png)

---

# Merge conflicts
You and your group members might modify the same file in the repo, if two people modify the same line of code and then you try to merge, git will not know how to handle the conflict. You will need to resolve that manually.

---

# Git Commands: git log
- Allows you to see all commit history in your local git repo. Each commit will have a hash associated with it, so you could git checkout a particular commit down the tree if you wanted to.
- The log is a good example of why you want to add descriptive messages when you commit, otherwise you will have no information about previous commits and will have to check each one individually to get any insight on them.
- You can unstage a particular commit with git reset commitname/hash
- Or fully remove the commit and set the new HEAD of the tree to the previous commit with git reset --hard commitname/hash

---

# Forking a repository
You might not have direct access to working with someone else’s repo online, so to gain access to it you can fork it to your GH and then clone it to your local machine. This allows you to work on the same project and add new features, when you’re ready you can open a pull request against the original repo.

---

# Advanced Git: git rebase
![rebase 1](/images/Git/git_slide25_1.png) ![rebase 2](/images/Git/git_slide25_2.png)
$ git branch
\* main
  feature1
$ git rebase feature1

---

# Advanced Git: git cherry-pick
You use this to pick one particular commit to merge with main->HEAD
![cherrypick 1](/images/Git/git_slide26_1.png) ![cherrypick 2](/images/Git/git_slide26_2.png)
$ git branch
\* main
  feature1
$ git cherry-pick \#hash\#
Note: you can use -n to merge the commit with HEAD without committing


---

# Advanced Git: git tag
- The ways to reference commits are by checking out a branch, which will bring you to branchname -> HEAD, or by referencing the hash of a particular commit
- But if we have an interesting commit which we want easy access to later, we can tag it so we don’t have to look up it’s hash
![git tag](/images/Git/git_slide27.png)

---

# Advanced Git: git log
- Like with any git command you can add flags to it to fine tune what you want the command to achieve
- git log --help to check the flags. This applies to all git commands e.g. git cherry-pick --help
- A useful variation on git log is
$ git log --graph --oneline --decorate
- (--graph) shows a log in a graph format distinguishing the different active branches
- (--oneline) compacts each commit to one line

---

# Advanced Git: git bisect
Useful tool for finding the first commit which introduced a bug
Steps:
1. git bisect start
2. git bisect good hash
3. git bisect bad (you can leave fourth arg blank to start from current commit)
Bisect will run a binary search based on your input, after step 3 bisect will drop you on a commit half way between the known good and bad commits
4. git bisect good/bad (depending on whether your test passed/failed)
5. Repeat step 4 until bisect finds the first bad commit
6. Fix the bug
7. git bisect reset (to get back to the commit where you ran step 1)

---

# Git Strategies: commit messages
- When staging a commit, try to organize each commit by topic. Do not cram unrelated changes into one commit
- If you have modified a file for multiple different topics you can stage parts of the file with partial staging, use
- git add -p file.txt
- Terminal will prompt you which parts you would like to stage (y/n)

---

# Commit Message Conventions
Formulating a commit message
1. The subject should be a concise summary of your changes
Write this on the first line of the git editor that pops up after a commit
2. The body can be more detailed
Write this on line 3 of the git editor
  - How did the file change
  - Why did you make the change
  - Any key notes on the change

---

# Advanced Git: git rev-list
- Use this to show a custom view of the tree of commits
$ git rev-list feature1 feature2 main
- Shows commits from feature1 and feature2 but not main
$ git rev-list --not feature1 feature2 ^main
- Does the opposite
$ git-rev-list --help

---

# Advanced Git: formatting and applying a patchset
- Another way to merge two branches is by applying a patchset
- A patchset contains patches which is essentially a diff file in an email format
- Gives your group the ability to review the patch before merging
![format patch d1](/images/Git/git_slide33.png)

---

# Advanced Git: formatting and applying a patchset
- You can apply individual patches by patch name in the patches directory
- If you do this, make sure that the parent of the commit that is to be applied as a patch is already in the branch you are applying to
![format patch d2](/images/Git/git_slide34.png)

---

# git send-email
Follow [this](https://stackoverflow.com/questions/68238912/how-to-configure-and-use-git-send-email-to-work-with-gmail-to-email-patches-to) to configure your system to send email patches with your gmail address.
Then you will need to create a patch set and run
$ git send-email --to=address1,address2,etc ./path/to/patch(es)

---

# Git Cheat Sheet
[https://phoenixnap.com/kb/git-commands-cheat-sheet#ftoc-heading-10](https://phoenixnap.com/kb/git-commands-cheat-sheet#ftoc-heading-10) 
Useful Commands:
rm -rf directory (to delete a directory and everything in it)
--abort (to abort any git process)
e.g. git merge --abort

---

# References
- man git
- https://www.youtube.com/watch?v=RGOj5yH7evk 
- [https://www.youtube.com/watch?v=_UZEXUrj-Ds](https://www.youtube.com/watch?v=_UZEXUrj-Ds) git rebase
- [https://www.youtube.com/watch?v=CRlGDDprdOQ](https://www.youtube.com/watch?v=CRlGDDprdOQ) git rebase vs git merge
- [https://www.youtube.com/watch?v=wIY824wWpu4](https://www.youtube.com/watch?v=wIY824wWpu4) git cherry-pick
- [https://www.youtube.com/watch?v=QtXj9tt-RUE](https://www.youtube.com/watch?v=QtXj9tt-RUE) Creating and applying git patches
- [https://www.youtube.com/watch?v=vSsypsDRiMU](https://www.youtube.com/watch?v=vSsypsDRiMU) Tags
- [https://www.youtube.com/watch?v=ecK3EnyGD8o](https://www.youtube.com/watch?v=ecK3EnyGD8o) useful techniques
- [https://www.youtube.com/watch?v=P3ZR_s3NFvM](https://www.youtube.com/watch?v=P3ZR_s3NFvM) git bisect
