package;


import Typedefs.ClassTemplate;
import vscode.QuickPickItem;
import Typedefs.Structure;
import haxe.Template;
import haxe.io.Path;

import sys.FileSystem;
import sys.io.File;

import vscode.OutputChannel;
import Vscode.*;

import Enums.Classes;
import Enums.Projects;

import Constants;
import Typedefs.Flixel;

import js.node.Fs;
import haxe.Json;


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

        switch (project) {
            case Projects.Haxe:
                this.ParseHaxe(name);
            case Projects.Flixel:
                this.ParseFlixel(name);
        }
    }

    public function ParseHaxe(name:String) {
        var projectTemplateSrc = Constants.projectHaxeRoot;

        if (!FileSystem.isDirectory(projectTemplateSrc)) {
            this.output.appendLine("ERROR: Can't find Haxe Project Template at {"+projectTemplateSrc+"}");
            return; 
        }
        
        var location = this.save_location + '/' + this.projectType;
        var destination = this.save_location + '/' + name;

        this.MoveDirectory(projectTemplateSrc, this.save_location);
        this.RenameDirectory(location, destination);
    }

    public function ParseFlixel(name:String) {
        var dir = Constants.projectHaxeflixelRoot;

        if (!FileSystem.isDirectory(dir)) {
            this.output.appendLine("ERROR: Can't find HaxeFlixel Project Template at {"+dir+"}");
            return; 
        }

        var location = this.save_location + '/' + this.projectType;
        var destination = this.save_location + '/' + name;

        this.MoveDirectory(dir, this.save_location);
        this.RenameDirectory(location, destination);


        var project_file = this.GetFileContents(destination + '/Project.xml');
        var parse = new Template(project_file);
        
        var data:Flixel = {
            name: name,
            height: 500,
            width: 500
        };
        
        project_file = parse.execute(data);

        this.SetFileContents(destination + '/Project.xml', project_file);        
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

    public function GetClassTemplates(path:Path) {
        var projectTypes:Array<String> = workspace.getConfiguration('hxmanager').get('projectType');
        var detail = "";

        for (name in projectTypes) {
            detail += '$name, ';
        }

        var items = [];
        for (type in projectTypes) {
            var file_location = Path.join([Constants.classRoot, type, 'templates.json']);

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

                    template = Path.join([Constants.classRoot, type, '$name.hx']);
                    var contents = this.ParseTemplate(template, path.toString());

                    sys.io.File.saveContent(path.toString(), contents);
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