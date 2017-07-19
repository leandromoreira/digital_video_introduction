## Contributing

First off, thank you for considering contributing to this repo. It's people
like you that make this material such a great tutorial.

### 1. Found a bug, have a question or want to add a new feature

If you've noticed a bug, a feature or have a question go ahead and [open an issue](https://github.com/leandromoreira/digital_video_introduction/issues/new)!

### 2. Fork & create a branch

> * **Ensure the bug was not already reported** by [searching all issues](https://github.com/leandromoreira/digital_video_introduction/issues?q=).

If this is something you think you can fix, then
[fork digital_video_introduction](https://help.github.com/articles/fork-a-repo)
and create a branch with a descriptive name.

A good branch name would be (where issue #325 is the ticket you're working on):

```sh
git checkout -b 325-add-japanese-translations
```

### 3. Implement your fix or feature

At this point, you're ready to make your changes!

### 4. Make a Pull Request

At this point, you should switch back to your master branch and make sure it's
up to date with Active Admin's master branch:

```sh
git remote add upstream git@github.com:leandromoreira/digital_video_introduction.git
git checkout master
git pull upstream master
```

Then update your feature branch from your local copy of master, and push it!

```sh
git checkout 325-add-japanese-translations
git rebase master
git push --set-upstream origin 325-add-japanese-translations
```

Finally, go to GitHub and
[make a Pull Request](https://help.github.com/articles/creating-a-pull-request)
:D

### 5. Merging a PR (maintainers only)

A PR can only be merged into master by a maintainer if:

* It was reviewed.
* It is up to date with current master.

Any maintainer is allowed to merge a PR if all of these conditions are
met.

PS: this contributing text was inspired by active admin contributing.
