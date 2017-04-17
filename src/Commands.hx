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
    }

    private function registerCommand(command:String, callback:Function) {        
        context.subscriptions.push(commands.registerCommand('hxmanager.$command', callback));

        this.output.appendLine('INFO: Command {$command} has been registered');
    }

    private function CreateHaxeProject() {
        this.ShowInput(Projects.Haxe);
    }
    
    private function CreateHaxeFlixelProject() {
        this.ShowInput(Projects.Flixel);
    }

    public function ShowInput(projectType:Projects) {
        window.showInputBox(this.InputBoxProps()).then(
            function (input) {
                if (input == null || input == "" || input == "undefined") {
                    window.showInformationMessage("You need to enter a project name!");
                    return;
                }
                
                this.parse.Project(input, projectType);

                window.showInformationMessage('Project $input was created!');                
            }
        );
    }

    public function ClassHaxe() {

    }

    public function InputBoxProps():InputBoxOptions {
        return {
            prompt: "Project Name",
            placeHolder: "Type a name for the project"
        };
    }
}