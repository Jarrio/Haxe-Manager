package system.commands;

import haxe.Template;
import sys.io.File;
import system.enums.Projects;
import vscode.OutputChannel;
import Vscode.window;
import Helpers;

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

                    Helpers.copyFolders(source, input);                    
                    Helpers.renameDirectory(rename, output_file, output);

                    /**************
                     * @change 
                     * Temporary location for project configuration until I design a more
                     * dynamic and flexible system for this
                     **************/                     
                    var root_dir = Helpers.homeRoot([type, name]);
                    var project_xml = Constants.Join([root_dir, 'Project.xml']);

                    parse.parseLaunchConfig(root_dir, name);

                    if(Helpers.pathExists(project_xml) && !do_not_open) {
                        var get_content = File.getContent(project_xml);
                        var parse = new Template(get_content);

                        var data = {
                            name: name, 
                            height: 640,
                            width: 640
                        }

                        var content = parse.execute(data);
                        File.saveContent(project_xml, content);                        
                    }
                    
                    if (Helpers.pathExists(root_dir)) {
                        Helpers.openProject(root_dir, true);
                        trace('name: $name');
                        trace('Project $name created');
                        return;
                    }      
                    
                    trace('Failed to create the project');
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

