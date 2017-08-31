* [Marketplace download](https://marketplace.visualstudio.com/items?itemName=jarrio.hxmanager)
# Features and improvements
#### 0.3.9
* [Bugfix] Don't add `isBuildCommand` if the task file doesn't originally contain it

#### 0.3.8
* [x] Added the following snippets
	* Basic haxe types including abstract enums
	* Conditionals
		* if
		* ifelse
		* ifelseif
		* else		
	* Function overrides
	* Added a new placeholder for functions to define `static` and `inline`
* [x] Updated Flixel's `tasks.json` file
* [x] Updated Kha's `tasks.json` file
* [x] Added a task switcher at the bottom left


#### 0.3.7
* [x] Auto-completion for Kha is now available!
* [x] Bugfix: Flash application will now open when run from the debugger

#### 0.3.6
* [x] Bugfix: Fixed Kha launch.json

#### 0.3.5
* [x] Bugfix: Being asked to setup kha for non-kha projects
* [x] Added more output messages
* [x] Added more info messages
* [x] Project folders will be created when going through initial setup

#### 0.3.4
* [x] Added Kha support. Debugging works on Flash and HTML5, check the wiki for more information


#### 0.3.3
* [x] Added some snippets

#### 0.3.2
* [x] Code cleanup
* [x] Bug Fix - Package handling is now done properly


#### 0.3.1
* [x] Added some standard imports to flixel class templates

## 0.3.0
* [x] Started some code clean up
* [x] Started documenting the code
* [x] Added a quick pick selector for creating projects. A neater way of presenting the option 
* [x] Added a new setting `templatePath` to allow people to define a different local directory for templates 
* [x] Updated the flixel `.vscode` folder with up to date templates 
* [x] Fixed file has new content bug 
* [x] Fixed launch config not filling out application name 

---
#### 0.2.1
* [x] Bug fix: No longer need to reload vscode when setting the source directory
* [x] Bug fix: Fixed the `FlxSprite` template file. Forgot to add the `elapsed` call to the update loop.

## 0.2.0

* [x] Added an input prompt for setting the initial project root directory on first launch
* [x] Added a basic Project Manager based on the above directory! Command is listed when searching for `Project Manager`.

---
##### 0.1.2
* [x] Restructured some code, files and folders
* [x] Changed the way class template files are parsed
* [x] Template suggestions when file is created now work as intended!
* [x] Cleaned up `Constants` file
* [x] Updated the project templates `tasks.json` file
* [x] Request filepath prompt for project root directory

##### 0.1.1
* [x] Generate a base haxe cpp project
* [x] Rudimentry `package` auto-fill. Requires project files to be stored in a `source` or `src` directory
* [x] Setting to open new projects in a new window or in the current 

## 0.1.0

* [x] Generate a base haxeflixel project
* [x] Auto-fill standard haxe class when creating a new haxe file

