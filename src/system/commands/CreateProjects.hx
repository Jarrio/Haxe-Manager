package system.commands;

import sys.FileSystem;
import vscode.InputBoxOptions;
import haxe.Template;
import sys.io.File;
import system.enums.Projects;
import vscode.OutputChannel;
import Vscode.window;
import Vscode.workspace;
import Helpers;
import system.commands.projects.*;

class CreateProjects {

    private static var parse:Parse;
    private static var output:OutputChannel;
    public function new(_output:OutputChannel) {
        output = _output;
        parse = new Parse(output);
    }
    
    /**
     *  Create a project
     **/
    public function create() {
        var items = [];

        for (type in Projects.createAll()) {
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
                var kha_setup = false;

                if (Helpers.getConfiguration('khaPath') != null) {
                    kha_setup = true;
                }

                if (!kha_setup && resolve.label == "Kha") {
                    window.showInformationMessage('Please run the Kha setup in the command palette');
                    return;
                }

                if (Helpers.getConfiguration('projectsRoot') == null) {
                    window.showInformationMessage('The extension requires a location to store projects');
                    return;
                }

                var input_props = {
                    prompt: "Project name",
                    placeHolder: "Type a name for the project"
                }

                var do_not_open = false;

                function success(name:Null<String>) {
                    if (name == null || name == "" || name == "undefined") {
                        window.showWarningMessage('A project name is required');
                        return;
                    }
                    
                    var type = resolve.label;
                    
                    var source = Helpers.projectPath(type);
                    var input = Helpers.homeRoot([type]);
                    var rename = Helpers.homeRoot([type, type]);
                    var output_file = Helpers.homeRoot([type, name]);

                    if (Helpers.pathExists(rename)) {
                        window.showErrorMessage('A folder exists with the name - $type');
                        output.appendLine('Error: Folder exists at $rename. Cannot copy project template to this location.');
                        do_not_open = true;
                        return;
                    }

                    if (Helpers.pathExists(output_file)) {
                        window.showErrorMessage('A project with that name already exists');
                        output.appendLine('Error: A project already exists at the location $output_file');
                        do_not_open = true;
                        return;
                    }

                    trace('Source: $source | Input: $input');

                    Helpers.copyFolders(source, input);                    
                    Helpers.renameDirectory(rename, output_file, output);

                    /**************
                     * @change 
                     * Temporary location for project configuration until I design a more
                     * dynamic and flexible system for this
                     **************/                     
                    var root_dir = Helpers.homeRoot([type, name]);
                    
                    if ( Projects.Flixel.getName() == type) {
                        new Flixel(type, name, root_dir, output);
                    } else if (Projects.Kha.getName() == type) {
                        new Kha(type, name, root_dir, output);
                    } else {
                        output.appendLine('Here');
                    }
                    
                    if (Helpers.pathExists(root_dir)) {
                        Helpers.openProject(root_dir, true);
                        trace('name: $name');
                        trace('Project $name created');
                        return;
                    } else {
                        window.showErrorMessage('Failed to create the project');
                    }
                    
                    output.appendLine('Failed to create the project');
                    return;          
                }

                function error(response:Dynamic) {
                    output.appendLine('Error - $response');
                }

                Helpers.showInput(input_props, success, error);
            }
        );
    }    
}

