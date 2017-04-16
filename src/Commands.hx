package;

import Routes.Projects;
import haxe.Constraints.Function;
import Vscode.*;
import vscode.*;

class Commands {

    private var parse:Parse;        
    private var terminal:Terminal;
    private var output:OutputChannel;
    private var context:ExtensionContext;

    private var project_root:String;

    public function new(context:ExtensionContext, terminal:Terminal, output:OutputChannel) {
        
        this.output = output;
        this.context = context;
        this.terminal = terminal;        
        this.parse = new Parse(output);

        this.project_root = workspace.getConfiguration("hxmanager").get("projectRoot");

        registerCommand('CreateHaxeProject', this.CreateHaxeProject);
        registerCommand('CreateFlixelProject', this.CreateHaxeFlixelProject);
        registerCommand('ClassHaxe', this.ClassHaxe);

    }

    private function registerCommand(command:String, callback:Function) {        
        context.subscriptions.push(commands.registerCommand('hxmanager.$command', callback));

        this.output.appendLine('INFO: Command {$command} has been registered');
    }

    private function CreateHaxeFlixelProject() {
        var inputBoxProps:InputBoxOptions = {
            prompt: "Project Name",
            placeHolder: "Type a name for the project",
            value: "path"
        };

        window.showInputBox(inputBoxProps).then(
            function (input) {
                if (input == null || input == "" || input == "undefined") {
                    window.showInformationMessage("You need  to enter a project name!");
                    return;
                }
                
                this.parse.Project(input, Projects.Flixel);

                // if (this.terminal != null) {
                    
                //     this.terminal.sendText('echo ${this.project_root}');
                //     var change_path = 'cd ${this.project_root}';
                //     var create_project = 'flixel template -n $input';

                //     this.terminal.sendText(change_path);
                //     this.terminal.sendText(create_project);

                // }

                window.showInformationMessage('Project $input was created!');                
            }
        );
    }

    public function CreateHaxeProject() {

    }

    public function ClassHaxe() {

    }
}