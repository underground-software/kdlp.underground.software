---
layout: article
title: Introduction to Git
---
* We used [this](/slides/git.html) slide deck

* Git is distributed [version control](https://en.wikipedia.org/wiki/Version_control) software

* [Git](https://git-scm.com/) is not [GitHub](https://github.com)

    * GitHub is one implementation of an interface for git

    * There are variously featured alternatives, such as [GitLab](https://gitlab.com/), [Bitbucket](https://bitbucket.org/), and [cgit](https://git.zx2c4.com/cgit/)

    * The KDLP team maintain a custom-themed cgit instance [here](https://kdlp.underground.software/cgit)

* Git is built on a [tree-like data structure](https://en.wikipedia.org/wiki/Tree_(data_structure)) that contains the entire change history of a project

* **Git proficiency is of the most useful and valuable software engineering skills a computer science student can learn in preparation to enter the industry**

* Charlie did a demo in the terminal. Here's a rough outline of the various git commands he covered:

    * `git clone`: Cloning the [ILKD_assignments](https://kdlp.underground.software/cgit/ILKD_assignments/) repository

    * `git commit`: Committing new local changes to the repository

    * `git merge`: Combining two change histories into one

    * `git reset`: Undoing previous changes, and going nuclear with `--hard`

    * `git rebase`: Rewriting the git history

    * (single commit rewrite cases can be handled with `git commit -amend`)

    * When things don't go right, you may have to resolve merge conflicts by manually editing source files and re-committing

    * This should not be something you have to do for this course, however for anyone who is interested, here is an article on [merge conflicts](https://css-tricks.com/merge-conflicts-what-they-are-and-how-to-deal-with-them/)
