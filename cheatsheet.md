##Cheat sheet:

####Heroku:
- To push develop to heroku

  `git push heroku develop:master`

- To migrate database: 

  `heroku run rake db:migrate`

- To restart your app:
  
  `heroku restart`

- To run rails console:
  
  `heroku run rails c`

- Add a remote to heroku repo url

  `heroku git:remote -a appname`

- run bash in heroku

  `heroku run bash`

- Run postgresql console on heroku:

  `heroku pg:psql`

- Get a local dump for a pg database on heroku: 

  `curl -o latest.dump $(heroku pgbackups:url)`

- Get pgbackup url

  `heroku pgbackups:url`


- Restore pg database from a url: 
  - NOTE: If you are going to restore a whole database from a dump, it makes sense to first clobber the existing one using heroku pg:reset. You can potentially hit some migratino problems otherwise.  

  `heroku pgbackups:restore CRIMSON 'http://s3.url.com' --remote staging`

- To drop / reset the database
  
   `heroku pg:reset DATABASE`

- Set config variable 

  `heroku config:set GITHUB_USERNAME=joesmith`

- Deleting precompiled assets to force all assets to get precompiled again
  
  `heroku repo:purge_cache -a appname` 

    - you need the [heroku repo plugin](https://github.com/heroku/heroku-repo) to do that

####Brew
- To find out if brew is outdated:

  `brew outdated`

- To update the formula and Homebrew itself:

  `brew update`

- To upgrade everything:

  `brew upgrade`

- To upgrade some recipe:

  `brew upgrade something`

####RVM

- To get the information about all possibilities of using the rvm command:

  `rvm`

- To see a list of installed rubies:

  `rvm list; #My terminal does not show the system installed ruby with this command`

- Install ruby version 1.9.1:

  `rvm install 1.9.1` or `rvm install 1.9.3-p0`

- To use version 1.9.1

  `rvm use 1.9.1`

- To use version 1.9.1 in current shell

  `rvm 1.9.1` #I do not know how it is different from ruby use 1.9.1

- To make version 1.9.1 default over all terminals use

  `rvm 1.9.1 --default` `rvm --default use 1.9.1` # if the above command does not work, try this one. 


- To go to the system installed version of rvm

  `rvm system`

- To make system version of ruby default , 
  
  `rvm system --default`

- To uninstall ruby: 
  
 `rvm uninstall  ruby-1.9.3-p194`

- to uninstall rvm

  `rvm implode` apparently


####Git
- Version of git

  `git --version`

- View user name and email for current user:

  `git config user.name`

  `git config user.email`

 
- Change user name and email for current repository:

  `git config user.name "Gagan"`

  `git config user.email "blah@blah.com"`

- Change user name and email for all repositories:

  `git config --global user.name "Gagan"`

  `git config --global user.email "blah@blah.com"`

- Set the colors for git:

  `git config --global color.ui true`

- Set default pager for git

  ```
  #Default is less. Setting to '' will stop the use of pager
  git config --global core.pager ''
  ```

#####Remote 
- Add a git remote:

  `git remote add remote_name gt@giturl.git`

- Remove a git remote:

  `git remote rm remote_name`

- View git remotes: 
  `git remote -v`

#####Pulling, adding, committing and related commands

- To add the same file in patches, so that they can be committed under different commits:

  `git add filename -p`

- To stage all the files that are delete locally:

  `git rm $(git ls-files --deleted)`

- To see the difference of files that are staged

  `git diff --cached` or `git diff --staged`

- To change your last commit message do

  `git commit --amend`

- To push from a branch to github do

  `git push origin <local-branchname>(:<remote-branchname>)`
  I think this creates a remote branch if one is not already created. 

- Dry run your push
  
  `git push --dry-run origin <local-branchname>(:<remote-branchname>)` 
  
  It is often better to test out what changes will happen with you push. The options to use to do that is --dry-run

- Forcing a push if you change the commit history

  `git push --dry-run origin <local-branchname>(:<remote-branchname>) -f` 

- To pull from the branch

  `git pull --rebase origin branchname`
  
- To push specific commit to remote rbanch 

  `git push orign <sha-of-commit>:<remote-branch-name>`



#####Listing files

- deleted files: 
  
  `git ls-files --deleted`

- all untracked files: 

  `git ls-files -o`

- all files that git has ignored: 

  `git ls-files --exclude-standard`

- untracked files that git doesn't ignore (i.e. all new files): 

  `git ls-files --other --exclude-standard`

- Files that match a pattern: 
  
  `git ls-files vendor*`

- Removing ignored file from the repository: 

  To delete a file from the repository but keep it in your working directory (this might come in handy when the file has been ignored)

  `git rm --cached <file>`


#####Clean

Remove untracked files dry run:
`git clean -n `

clean untacked files

`git clean -f `

OR
`rm $(git ls-files --other --exclude-standard)`

clean untracked files and directories

`git clean -f -d`

git clean untraced files including ignored files

`git clean -f -x`

options -d removes directory -n dry-run, -f force, -x remove files ignored by .gitignore

#####Resetting
- To uncommit last commit  and bring the committed files to the staging area do

  `git reset --soft HEAD^`

- To uncommit all commits until a particular commit say with sha= sha 1 do a:

  `git reset --soft <sha1> `
  NOTE the commit with the sha does not get uncommitted. And all the file changes stay in the staging area

- To uncommit and get rid of changes done until a particular commit say with sha = sha1 do a: 

  `git reset --hard <sha1>`
  NOTE the commit with the sha does not get uncommitted. And all the file changes stay in the staging area

- To see what changes a particular commit makes
  `git show <sha-of-commit>`

- To revert changes done to a particular commit you can use the command. 

  `git revert <sha-of-commit>`
  It leaves the old commit in the history and will create a new commit that cancels the old change out. 
  (there are other ways to release that branch as though that commit never happened)

- To revert changes done to a particular file in a particular commit you can use the command. 

  `git checkout <sha-of-commit> <path-to-file>`
  NOTE: Try this one out - I never got it to work


#####checkout
- If the local master branch gets deleted I have to do the following to restore it from the repository: 

  ```
  git fetch origin
  git checkout origin/master -b master
  ```
  
- When in the middle of conflict while merging branches

  And you want to keep the changes in a file as the were in the trunk:

  `git checkout --ours index.html`

  or you want to keep changes in a file as they were in the branch: 

  `git checkout --theirs layouts/default.html`


- Deleting all untracked files
  
  `rm -r  $(git ls-files --other --exclude-standard)`

- To remove a particular commit from the history 

  First do a

  `git rebase -i <sha-of-commit>^`

  Then you will have an editor opened. The first line should be the commit you want to remove from history. Delete that first line. Then save and exit if you do that, what happens is that git jumps back in time to just before that commit was created, then it starts taking instructions from the text file that was shown in the editor. the default behavior is to "cherry-pick" every commit that has been made; ie. the work tree will end up identical to when you started. you can reorder, change messages, squash commits, etc etc


#####tagging
- Adding a tag
  `git tag -a '<tag-number>' -m 'tag-message'`

- push all tags
  `git push --tags`

- delete tag locally
  `git tag -d <tag-number>`

- delete a tag in the repository that has been remove locally
  `git push origin :refs/tags/<tag-number>`

- add a tag to the sha
  `git tag <tag-number> <sha-of-commit> -m "message of tag"`


#####branching & merging
- To see a list of local branches :

  `git branch`

- To see all branches including all branches (ie local and remote): 

  `git branch -a`

- To create a new branch:
  
  `git branch branchname`

- To create a new branch and to switch to it. Note that the '-b' tells git that it is a new branch
  
  `git checkout -b branchname`

- To create a new branch from a particular commit that exists in the log of current branch

  `git branch branchname sha-of-commit`

- Delete a branch locally

  `git branch -d branchname`

- Delete a branch in repository that is deleted locally

  `git push origin :feature/sass`
   i.e. add colon before the branch name

-  To switch between existing branches 

  `git checkout branchname`


- Instead of merging you want to cherry pick changes, so that you can avoid some commits that you do not want, 

  `git cherry-pick SHA-of-the-commit`

   the sha should exist locally on any branch 

- Create a branch from a previous commit:
  `git branch branchname <sha1-of-commit>`

- List existing remote branches: 
  `git ls-remote --heads`

- Use a mergetool to help resolve conflicts
  `git mergetool`

##### gui

- Git's Graphical user interface 
    `git gui`

##### bisect

- Find the commit that introduces a bug using git bisect. See http://robots.thoughtbot.com/git-bisect
  `git bisect start`

  `git bisect good <sha-of-good-commit>`

  `git bisect bad <sha-of-bad-commit>`

  `git bisect run rspec spec/features/my_broken_spec.rb #To automate the bisect feature. `

##### Log
- To view recent commits on the current branch
  `git log`

- To view recent commit on the current branch with each commit on one line
  `git log --pretty=oneline`

  `git ref log`

- View changes in one branch that do not exist in the other
  `git log branch1 --not branch2`


####RSpec

- to run a particular spec in a particular line of a file
  `rspec spec/controllers/home_controller_spec.rb:12`


####Cucumber
- To create the database for cucumber
  `rake db:create RAILS_ENV=cucumber` (this might need an empty /config/settings/cucumber.rb file)
  `rake db:cucumber:prepare`

- To run cucumber
  `bundle exec cucumber`

- To run a scenario on line number 7 of book_room.feature file
  `cucumber features/book_room.feature:7 `

- To run cucumber for the --wip profile
  `bundle exec cucumber --profile wip`

- To run cucumber with a full backtrace
  `cucumber -b`




####Bundler

- Install bundle 

  `bundle install` or `bundle`

- Install bundler:

  `gem install bundler`

- Upgrade bundler:

  `gem update bundler`


- Edit installed gem in bundler

  `export BUNDLER_EDITOR=mvim && bundle open gemname`

- List out all the gems that will be updated if you run the bundle update command:
  `bundle outdated`

- clean out all the unrequired gems under certain conditions. 

  `bundle clean`

To read more about it you can try:  http://patshaughnessy.net/2011/11/5/besides-being-faster-what-else-is-new-in-bundler-1-1

####Capistrano
List all capistrano tasks

`cap -T`

Go back one deploy

`cap production deploy:rollback`


####Rake
- List all possible rake tasks
  rake -T

- To see routes: 
  bundle exec rake routes

- To list all the middleware
  bundle exec rake middleware


####Rails

- Make a new project named 'example' using database sqlite: 
  
  `rails new example`

- Make a new project named 'example' using database mysql: 

  `rails new example -d=mysql`

- Start the rails server 

  `rails server` or `rails s`

- Start the rails server with debugger options

  `rails server --debugger`

- Start the rails console for the project

  `rails console` or `rails c`

- To test out some code without changing any data: 

  `rails console --sandbox`
  Any modifications that are made will be rolled back on exit. 

- Get the database command line for the 

  `rails dbconsole`

#####Rails Generators

Model
  `rails generate model address line_1:string line_2:string city:string state:string zip:integer`

To create a model HomepageAd along with its spec and table:

  `rails generate rspec_model my_model attribute:type attribute:type`

Destroy Model
  
  `rails destroy model  ModelName`


Migrations:

- To migrate:

  `rake db:migrate`

- To go back one migration:

  `rake db:rollback`

- To go back two migrations: 

  `rake db:rollback STEP=2`

- Adding a column 

  `rails generate migration AddActiveToNews active:boolean `


- Adding paperclip columns: 

  `rails generate migration add_paperclip_columns_to_my_model image_file_name:string image_content_type:string image_file_size:integer image_updated_at:datetime`


- Mailers:

To automatically generate mailer and associated directories 

`rails generate mailer MyMailer`




####Unix

#####Grep

Excluding directories in your grep

When it is in the current directory: 

 `grep -r -F "Date" .  --exclude-dir={.git,tmp,log,vendor}`

When it is in the tree but not the current directory

  `grep -r -F "Date" .  --exclude="*spec/cassettes*"`
 


#####Curl

Only get headers from the url

  `curl -s -D - http://www.desiringgod.org -o /dev/null`
  
  
#####Bash
Run command multiple times: 
  `for i in {1..10}; do commandNameHere; done`
  http://www.cyberciti.biz/faq/bsd-appleosx-linux-bash-shell-run-command-n-times/


##### find and replace
  find and replace recursively within a folder: 

  ``perl -p -i -e 's/oldstring/newstring/g' `find ./ -name '*.rb'` `` or 
  
  
  `` perl -p -i -e 's/oldstring/newstring/g' `grep -ril oldstring *` ``
  
  Replace backreference with lower case: 
  \l change the case
  \L also changes the case
  \Following script changes ResourceType.find('Article), or ResourceType.find('Books') to ResourceType.find('articles') ResourceType.find('books') 

  `perl -p -i -e "s/ResourceType.find\('(.)/ResourceType.find('\l\$1/g" spec/redirectors/v_2014/resource_library_spec.rb`

