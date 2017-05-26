package;

import Helpers;
import vscode.OutputChannel;
import vscode.ExtensionContext;

import Vscode.window;
import Vscode.workspace;
import system.enums.Project;

class Commands {

    private var parse:Parse;
    private var output:OutputChannel;
    private var context:ExtensionContext;

    private var root:String;

    /**
     *  Initialise the registered commands
     *  @param context - An instance of utilities specific to the extension
     *  @param output - Output channel where extension logging information will be sent
     **/
    public function new(context:ExtensionContext, output:OutputChannel) {        
        this.output = output;
        this.context = context;  
        this.parse = new Parse(output);

        this.root = Helpers.getConfiguration('projectRoot');
        this.registerCommands();   
    }

    /**
     *  List of available commands
     **/
    private function registerCommands() {
        Helpers.registerCommand(context, 'CreateProjects', this.createProjects);
    }

    /**
     *  Create a project event
     **/
    private function createProjects() {
        var items = [];

        for (type in Project.createAll()) {
            items.push (
                Helpers.quickPickItem(type.getName())
            );
        }

        window.showQuickPick(
            items,
            {
                ignoreFocusOut: true,
                placeHolder: "Select project type"
            }
        ).then(
            function (resolve) {
                var input_props = {
                    prompt: "Project name",
                    placeHolder: "Type a name for the project"
                }

                function success(input:Null<String>) {
                    if (input == null || input == "" || input == "undefined") {
                        window.showWarningMessage('A project name is required');
                        return;
                    }

                    trace('Project $input created');
                }

                function error(response:Dynamic) {
                    this.output.appendLine('Error - $response');
                }

                Helpers.showInput(input_props, success, error);
            }
        );
    }
}