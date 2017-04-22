package;

import Vscode.*;
import vscode.QuickPickItem;
import vscode.OutputChannel;

import haxe.Json;
import haxe.io.Path;
import haxe.Template;

import sys.io.File;
import sys.FileSystem;

import Constants;
import Enums.Projects;
import Typedefs.Flixel;
import Typedefs.ClassTemplate;

class Parse {

    public var projectType:Projects;
    public var output:OutputChannel;
    private var save_location:String;

    public function new(output:OutputChannel) {
        this.save_location = workspace.getConfiguration('hxmanager').get('projectsRoot');
        this.output = output;
    }

    public function Project(name:String, project:Projects) {
        this.projectType = project;

        if (!FileSystem.exists(this.save_location)) {
            this.output.appendLine("ERROR: Projects directory is not set or does not exist");
            return;
        }

        this.ParseProjects(name, project);
    }

    public function ParseProjects(name:String, project:Projects) {
        var type = project.getName();

        var projects = Constants.Join([Constants.projectsRoot, type]);
        
        var rootProjects = Constants.Join([this.save_location, type]);
        
        if (!FileSystem.exists(rootProjects)) {
            FileSystem.createDirectory(rootProjects);
        }

        var rename_input= Constants.Join([this.save_location, type, type]);
        var rename_output = Constants.Join([this.save_location, type, name]);

        this.MoveDirectory(projects, rootProjects);
        this.RenameDirectory(rename_input, rename_output);

        //Temporary location for flixel project parsing

        var file_path = Constants.Join([rename_output, 'Project.xml']);
        if (FileSystem.exists(file_path)) {
            var project_file = this.GetFileContents(file_path);
            var parse = new Template(project_file);
            
            var data:Flixel = {
                name: name,
                height: 500,
                width: 500
            };
            
            project_file = parse.execute(data);

            this.SetFileContents(file_path, project_file);
        }

    }

    public function RenameDirectory(original:String, destination:String):Void {           
        FileSystem.rename(original, destination);        
    }

    public function MoveDirectory(original:String, destination:String):Void {       
        Helpers.copyFolderRecursiveSync(original, destination);    
    }

    public function GetFileContents(path:String):String {
        return sys.io.File.getContent(path);
    }

    public function SetFileContents(path:String, content:String):Void {
        sys.io.File.saveContent(path, content);
    }

    public function GetClassTemplates(path:String) {
        var projectTypes:Array<String> = workspace.getConfiguration('hxmanager').get('projectType');
        var detail = "";

        for (name in projectTypes) {
            detail += '$name, ';
        }

        var items = [];
        for (type in projectTypes) {
            var file_location = Constants.Join([Constants.classRoot, type, 'templates.json']);

            var parse_template = Json.parse(sys.io.File.getContent(file_location));
            var templates:Array<ClassTemplate> = parse_template.templates;
            
            for (template in templates) {
                items.push(this.CreateQuickPickItem(template.type, template.description, type));
            }
        }

        var template = "";
        var name = "";

        window.showQuickPick(items, {matchOnDetail: true, ignoreFocusOut: true}).then(
            function (resolve) {
                if (resolve != null && resolve.label != "") {
                    name = resolve.label;
                    var name = resolve.label;
                    var type = resolve.detail;

                    template = Constants.Join([Constants.classRoot, type, '$name.hx']);
                    var contents = this.ParseTemplate(template, path);

                    sys.io.File.saveContent(path, contents);
                }
            },

            function (reject) {
                trace('Rejected: $reject');
            }
        ); 
    }

    public function ParseTemplate(source:String, destination:String) {
        if (FileSystem.exists(source) && source != null) {
            var path_data = new Path(destination);

            var contents = sys.io.File.getContent(source);        

            var template = new Template(contents);  
            var getpackage = ParsePackage(destination);

            var contents = {
                name: path_data.file.split('.')[0],
                location: getpackage
            };
            
            return template.execute(contents);
        }
        
        return " ";
    }

    public function CreateQuickPickItem(label:String, description:String, detail:String) {
        var item:QuickPickItem = {
            label: label,
            description: description,
            detail: detail
        };

        return item;
    }

    public static function ParsePackage(directory:String):String {
        var path = new Path(directory);
        var slash = '';
        
        if (path.backslash) {
            slash = '\\';
        } else {
            slash = '/';
        }

        var divider = "source";
        
        if (path.dir.indexOf(divider) == -1) {
            divider = "src";
        }

        var split = path.dir.split(divider);

        if (split.length >= 2) {
            
            var file_location = StringTools.replace(split[1], slash, '.');
            
            if (file_location.charAt(0) == '.') {
                file_location = file_location.substring(1);
            }

            if (file_location.charAt(file_location.length - 1) == '.') {
                file_location = file_location.substring(0, file_location.length - 2);
            }

            return " " + file_location;
        }
        
        return "";
    }
}