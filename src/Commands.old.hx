package;

import sys.FileSystem;
import Enums.Classes;
import Enums.Projects;
import haxe.Constraints.Function;
import Vscode.*;
import vscode.*;

typedef OpenFolder = {
    var uri:String;
    var newWindow:Bool;
}

class Commands {

    private var parse:Parse;        
    private var output:OutputChannel;
    private var context:ExtensionContext;

    private var project_root:String;

    public function new(context:ExtensionContext, output:OutputChannel) {
        
        this.output = output;
        this.context = context;  
        this.parse = new Parse(output);

        this.project_root = workspace.getConfiguration("hxmanager").get("projectRoot");

        registerCommand('CreateHaxeProject', this.CreateHaxeProject);
        registerCommand('CreateFlixelProject', this.CreateHaxeFlixelProject);
        registerCommand('ProjectManager', this.ProjectManager);
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

    private function CreateClass(classType:Classes) {
        window.showInputBox(this.InputBoxProps()).then(
            function (input) {
                if (input == null || input == "" || input == "undefined") {
                    window.showInformationMessage("You need to enter a class name!");
                    return;
                }              
            }
        );
    }

    private function ProjectManager() {
        var projectPath = workspace.getConfiguration('hxmanager').get('projectsRoot');
        var projects = [];

        if (FileSystem.exists(projectPath)) {
            var directories =  FileSystem.readDirectory(projectPath);
            for (dir in directories) {
                var detail = Constants.Join([projectPath, dir]);
                projects.push(this.CreateQuickPickItem(dir, null, detail));
            }


            window.showQuickPick(projects, {matchOnDetail: true, ignoreFocusOut: true}).then(
                function (resolve) {                    
                    var folders = [];
                    var directories = FileSystem.readDirectory(resolve.detail);
                    
                    var projects = [];
                    var opened = false;
                    for (project in directories) {
                        if (project.indexOf('.') != -1) {
                            opened = true;
                            
                            this.OpenProject(resolve.detail);                            
                            return;
                        }
                    }

                    if (opened) return;

                    for (dir in directories) {                     
                        var detail = Constants.Join([resolve.detail, dir]);

                        folders.push(this.CreateQuickPickItem(dir, null, detail));                        
                    }

                    window.showQuickPick(folders, {matchOnDetail: true, ignoreFocusOut: true}).then(
                        function (resolve) {
                            this.OpenProject(resolve.detail);
                        }
                    );
                }
            );            

        }

    }

    public function CreateQuickPickItem(label:String, ?description:String, ?detail:String) {
        var item:QuickPickItem = {
            label: label,
            description: description,
            detail: detail
        };

        return item;
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
                var location = workspace.getConfiguration('hxmanager').get('projectsRoot');

                var path = Constants.Join([location, projectType.getName(), input]);
                this.OpenProject(path);
            }
        );
    }

    public function OpenProject(src:String) {
        var uri = vscode.Uri.file(src);
        var newWindow = workspace.getConfiguration('hxmanager').get('newWindow');
        Vscode.commands.executeCommand("vscode.openFolder", uri, newWindow);
    }

    public function ClassHaxe() {

    }

    public function InputBoxProps():InputBoxOptions {
        return {
            prompt: "Project Name",
            placeHolder: "Type a name for the project",
            
        };
    }
}