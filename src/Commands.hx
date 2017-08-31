package;

import sys.FileSystem;
import vscode.InputBoxOptions;
import Helpers;
import vscode.OutputChannel;
import vscode.ExtensionContext;
import Vscode.window;
import Vscode.workspace;
import system.commands.CreateProjects;
import system.commands.ProjectManager;
import vscode.Terminal;
import vscode.StatusBarItem;
import haxe.io.Path;
import vscode.WorkspaceConfiguration;

class Commands {

    private var output:OutputChannel;
    private var context:ExtensionContext;
	private var selectedTask:String;
	private var buildCommand:Bool = false;
	private var taskPicker:StatusBarItem;
	private var config:WorkspaceConfiguration;
	private var tasks:Array<Dynamic>;
    /**
     *  Initialise the registered commands
     *  @param context - An instance of utilities specific to the extension
     *  @param output - Output channel where extension logging information will be sent
     **/
    public function new(context:ExtensionContext, output:OutputChannel) {        
        this.output = output;
        this.context = context;  
		
		config = workspace.getConfiguration('tasks',  window.activeTextEditor.document.uri);
		tasks = config.get("tasks");

        
        Constants.set_output(output); 		

		workspace.createFileSystemWatcher("**/tasks.json", true, false, true).onDidChange(
			function(uri) {
				updateTaskSelecter();
			}
		);
		
		this.registerCommands();   
		loadTasks();		
    }

    /**
     *  List of available commands
     **/
    private function registerCommands() {
        Helpers.registerCommand(context, 'CreateProjects', this.createProjects);
        Helpers.registerCommand(context, 'SetupKha', this.setupKha);
        Helpers.registerCommand(context, 'ProjectManager', this.projectManager);
        Helpers.registerCommand(context, 'SelectTask', this.selectTask);
    }

	private function updateTaskSelecter():Void {
		for (task in tasks) {			
			if (task.group != "none" && task.group != null) {
				selectedTask = task.taskName;
			}
			
			if (task.isBuildCommand) {
				buildCommand = true;
				selectedTask = task.taskName;
			}
		}

		if (selectedTask != "" && taskPicker != null) {
			taskPicker.text = selectedTask;
		}
	}

	private function loadTasks():Void {
		for (task in tasks) {			
			if (task.group != "none" && task.group != null) {
				selectedTask = task.taskName;
			}
			
			if (task.isBuildCommand) {
				buildCommand = true;
				selectedTask = task.taskName;
			}
		}

		if (selectedTask != "") {
			taskPicker = window.createStatusBarItem(Left, 12);
			taskPicker.tooltip = "Select a task";
			taskPicker.text = selectedTask;
			taskPicker.command = "hxmanager.SelectTask";
			taskPicker.show();
			context.subscriptions.push(taskPicker);		
		}
	}
    /**
     *  Create a project event
     **/
    private function selectTask() {
		var items = [];

		for (task in tasks) {
			var quickPick = Helpers.quickPickItem(task.taskName);
			items.push(quickPick);			
		}
		
		window.showQuickPick(items).then(
			function(response) {
				if (response != null && response.label != null) {
					var taskName = response.label;
					if (this.selectedTask != taskName) {
						var group = {
							kind: "build",
							isDefault: true
						};

						var newTasks = [];
						for (task in tasks) {
							if (task.taskName != taskName) {
								if (task.group != null) {
									task.group = "none";								
								}

								if (buildCommand) {
									task.isBuildCommand = false;
								}
							}

							if (task.taskName == taskName) {
								if (!buildCommand) {
									task.group = group;
								} else {
									task.isBuildCommand = true;
								}
							}

							newTasks.push(task);
						}

						config.update('tasks', newTasks).then(
							function(s){
								selectedTask = taskName;
								taskPicker.text = taskName;
							},
							function(response:Dynamic) {
								output.append('Error: $response');
							}
						);
					}
				}
			}
		);		
    }

    /**
     *  Create a project event
     **/
    private function createProjects() {
        var projects = new CreateProjects(output);
        projects.create();
    }
    /**
     *  Setup Kha
     **/
    private function setupKha() {
        var khaPath = Helpers.getConfiguration('khaPath');

        var props:InputBoxOptions = { 
            prompt: "What is the ROOT directory of kha?",
            placeHolder: "File path",
            ignoreFocusOut: true   
        }

        window.showInputBox(props).then(
            function(path) {
                if (FileSystem.exists(path)) {
                    path = Path.removeTrailingSlashes(path);
                    path = Path.join([path, 'make']);

                    workspace.getConfiguration().update('hxmanager.khaPath', path, true).then(
                        function (resolve) {
                            window.showInformationMessage('Kha source path has been set');                            
                            output.appendLine('Set Kha path to {$path}');
                        }
                    );
                } else {
                    window.showInformationMessage('Kha path does not exist');
                    output.appendLine('Kha path does not exist: {$path}');
                }
            }
        );        
    }

    /*****
      * Basic project manager based on the home root. 
      * Currently doesn't allow more than one sub-folder as a proper
      * Recursive method has not been implemented
      *****/
    private function projectManager() {
        var projects = new ProjectManager();
        projects.manage();
        
    }
}