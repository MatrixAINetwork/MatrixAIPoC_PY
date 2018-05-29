# How to Contribute To Matrix Project




## Introduction

This is a tutorial to help first-time contributors to participate in a simple and easy project.

### Objectives

+ Make a contribution to an open source project.
+ Get more comfortable using GitHub.

### Who is this for?

+ This is for absolute beginners. If you are interested in blockchain, and have necessary coding skills, then you should be able to do it.
+ It is for those with a little more experience but who want to make their first open source contribution, or get more contributions for more experience and confidence.

### Why do I need to do this?

Any developer, aspiring or experienced needs to use Git version control, and GitHub is the most popular Git hosting service used by everyone. It is also the heart of the Open Source community. Getting comfortable using GitHub is an essential skill. Making a contribution to a project boosts your confidence and gives you something to show on your GitHub profile.<br>
If you are a new developer and you are wondering if you need to learn Git and GitHUb then here is the answer: [You Should've Learned Git Yesterday](https://codeburst.io/number-one-piece-of-advice-for-new-developers-ddd08abc8bfa "New Developer? You should’ve learned Git yesterday. by Brandon Morelli, creator of CodeBurst.io").



## Quick Access Index

Contribute: <ul><li>[Step 1: Fork this repository](#step-1-fork-this-repository)</li><li>[Step 2: Clone the repository](#step-2-clone-the-repository)</li><li>[Step 3: Create a new branch](#step-3-create-a-new-branch)</li><li>[Step 6: Apply your changes](#step-4-apply-your-changes)</li><li>[Step 5: Commit your changes](#step-5-commit-your-changes)</li><li>[Step 6: Push your changes to GitHub](#step-6-push-your-changes-to-github)</li><li>[Step 7: Submit a PR](#step-7-submit-a-pr)</li><li>[Step 8: Celebrate!](#step-8-celebrate-)</li></ul> 


## Setup

First let's get setup to do the work

1. Login to your GitHub account. If you don't yet have an account then [join GitHub](https://github.com/join).
1. Download [GitHub Desktop app](https://desktop.github.com/).
    + Alternatively if you are comfortable using Git on the command line you can do so (here's [first-contributions](https://github.com/Syknapse/first-contributions), a similar project that can serve as a guide for the commands needed). OR 
    + If you use [VS Code](https://code.visualstudio.com/ "Visual Studio Code website") it comes with integrated Git and allows you to do what we need straight from the editor.
    + However the simplest and easiest way to follow this tutorial is using GitHub Desktop.

Now that you are all setup let's get on with the business of contributing to the project.

---

---

## Contribute

Become an open source contributor in 10 easy steps.

_Estimated time: Less than 30 minutes_.

### Step 1: Fork this repository

+ The objective here is to make a copy of this project and place it in your account.
+ A repository (repo) is how a project is called on GitHub and a fork is a copy of it.
+ Make sure you are on the main page of this repo.

| <ul><li>Click on the _Fork_ button</li></ul> |
|:---|

+ You now have a complete copy of the project in your own account

---

### Step 2: Clone the repository

+ Now we want to make a local copy of the project. That is a copy saved on your own machine.
+ Open the GitHub desktop app. In the app:

| <ul><li>Click on _File_ then _Clone repository_</li></ul> |
|:---|

| <ul><li>You will see a list of your projects and forks on GitHub.</li><li>Select `<your-github-username>/your-repo`.</li><li>Click _Clone_</li></ul> |
|:---|
|<ul><li>A forked project will have the fork symbol on the left.</li><li>Your fork will have your own GitHub user name.</li></ul> | 

+ This will take a moment as the project is copied to your hard disk. I recommend that you keep the default path which is usually `..\Documents\GitHub`.
+ Now you have a local copy of the project.

---

### Step 3: Create a new branch

+ Once the repo has been cloned and you have it open in GitHub desktop it is time to create a new branch.
+ A branch is a way to keep your changes separate from the main part of the project called `Master`. For example if things go wrong and you are not happy with your changes you can simply delete the branch and the main project won't be affected.

| <ul><li>Click on _Current branch_</li><li>Then click on _New_</li></ul> | 
|:---|

| <ul><li>Give your branch a name</li><li>Click `Create branch`</li></ul> |
|:---|
+ You can name it whatever you want, but since this is a branch to the project, calling it `your-name-project` is good practice because it keeps the intention of this branch clear.

| <ul><li>Publish your new branch to Github</li></ul> |
|:---|

+ Now you have created a new branch separate from the master.
+ For the next steps make sure you are working in this branch. You will see the name of the branch you are on at the top center of the GitHub desktop app where it says _Current branch_.

---

### Step 4: Apply your changes

+ We will now start editing the projects, changing the parts that need to be improved as you think.

| <ul><li>Tell us something about you</li><li>Keep it short and sweet. Think about it more like a tweet than a blog post</li></ul> |
|:---|

+ Make sure you have **saved all your changes**.
+ **Test your changes**. 
+ Great, you have finished editing your code! The next steps will send your changes to GitHub and then submit them to be merged with the main project.

---

### Step 5: Commit your changes

+ Go back to the GitHub desktop app.
+ Your changes will have been added automatically to the staging area.
+ This means that Git has recorded all the **saved** changes.
+ You can see this reflected in the app. Everything you have added to the file will be in green, and deletions will show as red.

| <ul><li>The next step is called _Commit_</li><li>This roughly means "confirm the changes"</li></ul> |
|:---|

| <ul><li>This is what your GitHub desktop header should look like</li><li>Notice the fork symbol next to the project name in `Current repository`</li><li>Your `Current branch` will have the name you gave it in step 3</li></ul> |
|:-----|


| <ul><li>To _Commit_ you must fill in the _Summary_ field</li><li>This is the commit message explaining what you have changed</li><li>In this case "bug XXX fixed" would be a reasonable message</li><li>Optionally you can add a more detailed _Description_</li><li>Click the _Commit_ button. Your button will say something like `Commit to "your-branch-name"`</li></ul> |
|:---|

---

### Step 6: Push your changes to GitHub

+ Your changes are now saved or committed. But they are saved only locally, that is on your computer.
+ Synchronizing local changes with your repository on Github is called a _Push_. You are "pushing" the changes from your local repository to the remote repository on Github.

| <ul><li>Click the _Push_ button</li></ul> |
|:---|

+ After a few seconds the operation is complete and now you have exactly the same copy of this branch on your machine as well as on GitHub.

---

### Step 7: Submit a PR

+ This is the moment you have been waiting for; submitting a _Pull Request_ (PR).
+ So far all the work you have done has been on the fork of the project, which as you remember resides on your own account of GitHub.
+ Now it's time to send your changes to the main project to be merged with it.
+ This is called a [_Pull Request_](https://help.github.com/articles/about-pull-requests/ "About Pull Requests - GitHub Help") because you are asking the original project maintainer to "pull" your changes into their project.
+ Go to the main page of **your fork** on GitHub (it will have the fork icon and your own user name at the top).
+ Towards the top of the repo you will see a highlighted pull request message with a green button.

| <ul><li>Click on the `Compare and pull request`</li></ul> |
|:---|

| <ul><li>REMEMBER _you are trying to merge your branch with the original project not with the `Master` branch on your fork_.</li>


| <ul><li>Create a pull request:</li><li>Write a title</li><li>Add optional information in the description</li><li>Click `Create pull request`</li></ul> |
|:---|

+ Don't be fazed by all the options. You only need to do these three steps for now.
+ Leave the option `Allow edits from maintainers` ticked.
+ Now, a _Pull Request_ will be sent to the project maintainer. As soon as it is reviewed and accepted your changes will appear.

---

### Step 8: Celebrate!

That's it. You have done it! You have now contributed to open source on GitHub.


Your changes **won't be visible immediately**; first they have to be merged by Matrix project maintainer.

I promise I will try to make the merges as soon as possible but a couple of days delay might be expected sometimes.

---

---

## Next Steps

+ Come back in a while to check for your merged Pull Request.
+ You should receive an email from GitHub when your changes have been approved, or if additional changes are requested. And when the PR is finally merged with the master.
+ If you found this project **useful** please give it a :star: star :star: at the top of the page.
+ 
+ **Thanks for contributing to this project**. Now you can go ahead and try contributing to other projects; look for the ![Good First Issue](https://user-images.githubusercontent.com/29199184/33852733-e23b7070-debb-11e7-907b-4e7a03aad436.png) label for beginner-friendly contribution options.


## TOP

[Back to the top &uparrow;](#introduction)
