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

class Commands {

    private var output:OutputChannel;
    private var context:ExtensionContext;

    /**
     *  Initialise the registered commands
     *  @param context - An instance of utilities specific to the extension
     *  @param output - Output channel where extension logging information will be sent
     **/
    public function new(context:ExtensionContext, output:OutputChannel) {        
        this.output = output;
        this.context = context;  

        this.registerCommands();   
        Constants.set_output(output); 
    }

    /**
     *  List of available commands
     **/
    private function registerCommands() {
        Helpers.registerCommand(context, 'CreateProjects', this.createProjects);
        Helpers.registerCommand(context, 'SetupKha', this.setupKha);
        Helpers.registerCommand(context, 'ProjectManager', this.projectManager);
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
        if (khaPath == null) {
            var props:InputBoxOptions = { 
                prompt: "What is the ROOT directory of kha?",
                placeHolder: "File path",
                ignoreFocusOut: true   
            }

            window.showInputBox(props).then(
                function(path) {
                    if (FileSystem.exists(path)) {
                        path += '\\make';

                        workspace.getConfiguration().update('hxmanager.khaPath', path, true).then(
                            function (resolve) {
                                output.appendLine('Set Kha path to {$path}');
                            }
                        );
                    } else {

                    }
                }
            );
        }
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