package;

import sys.FileSystem;
import haxe.Template;
import Helpers;
import vscode.OutputChannel;
import vscode.ExtensionContext;

import Vscode.window;
import Vscode.workspace;
import system.enums.Project;

import sys.io.File;

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
        Helpers.registerCommand(context, 'ProjectManager', this.projectManager);
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

                function success(name:Null<String>) {
                    if (name == null || name == "" || name == "undefined") {
                        window.showWarningMessage('A project name is required');
                        return;
                    }
                    
                    var type = resolve.label;
                    
                    var source = Helpers.projectPath(type);
                    var input = Helpers.homeRoot([type, 'lBlankl']);
                    var output = Helpers.homeRoot([type, name]);
                    trace(source);
                    trace(input);
                    trace(output);
                    Helpers.copyFolders(source, input);
                    Helpers.renameDirectory(input, output);

                    /**************
                     * @change 
                     * Temporary location for project configuration until I design a more
                     * dynamic and flexible system for this
                     **************/                     
                    var root_dir = Helpers.homeRoot([type, name]);
                    var project_xml = Constants.Join([root_dir, 'Project.xml']);

                    if(Helpers.pathExists(project_xml)) {
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
                        trace('Project $input created');
                        return;
                    }      
                    
                    trace('Failed to create the project');
                    return;          
                }

                function error(response:Dynamic) {
                    this.output.appendLine('Error - $response');
                }

                Helpers.showInput(input_props, success, error);
            }
        );
    }

    /*****
      * @Rework 
      *****/
    private function projectManager() {
        var projectPath = workspace.getConfiguration('hxmanager').get('projectsRoot');
        var projects = [];

        if (FileSystem.exists(projectPath)) {
            var directories =  FileSystem.readDirectory(projectPath);
            for (dir in directories) {
                var detail = Constants.Join([projectPath, dir]);
                projects.push(Helpers.quickPickItem(dir, null, detail));
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
                            
                            Helpers.openProject(resolve.detail);                            
                            return;
                        }
                    }

                    if (opened) return;

                    for (dir in directories) {                     
                        var detail = Constants.Join([resolve.detail, dir]);

                        folders.push(Helpers.quickPickItem(dir, null, detail));                        
                    }

                    window.showQuickPick(folders, {matchOnDetail: true, ignoreFocusOut: true}).then(
                        function (resolve) {
                            Helpers.openProject(resolve.detail);
                        }
                    );
                }
            );            

        }

    }
}