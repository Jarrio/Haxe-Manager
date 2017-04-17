package;


import Typedefs.Structure;
import haxe.Template;
import haxe.io.Path;

import sys.FileSystem;
import sys.io.File;

import vscode.OutputChannel;
import Vscode.*;

import Routes.Classes;
import Routes.Projects;

import Constants;
import Typedefs.Flixel;

import js.node.Fs;


class Parse {

    public var output:OutputChannel;

    public function new(output:OutputChannel) {
        
        this.output = output;
    }

    public function Project(name:String, project:Projects) {
        switch (project) {
            case Projects.Haxe:

            case Projects.Flixel:
                this.ParseFlixel(name);
        }
    }

    public function ParseFlixel(name:String) {
        var dir = Constants.projectHaxeflixelRoot;

        if (!FileSystem.isDirectory('$dir')) {
            this.output.appendLine("ERROR: Can't find HaxeFlixel Project Template at {"+dir+"}");
            return; 
        }



        var save_location = workspace.getConfiguration('hxmanager').get('projectsRoot');

        if (!FileSystem.exists(save_location)) {
            this.output.appendLine("ERROR: Projects directory is not set or does not exist");
            return;
        }


        Helpers.copyFolderRecursiveSync(dir, save_location);        
        
        FileSystem.rename(save_location + '/haxeflixel', save_location + '/$name');

        save_location += '/$name';

        var project_file = sys.io.File.getContent(save_location + '/Project.xml');
        var parse = new Template(project_file);
        
        var data:Flixel = {
            name: name,
            height: 500,
            width: 500
        };
        
        project_file = parse.execute(data);
        sys.io.File.saveContent(save_location + '/Project.xml', project_file);        
    }

    public static function ParseHaxeClass(name:String, path:String):String {
        if (FileSystem.exists(Constants.classRoot + '/haxeClass.hx')) {
            var structure = sys.io.File.getContent(Constants.classRoot + '/haxeClass.hx');
            var parse = new Template(structure);
            
            var data = {
                name: name,
                packageName: ParsePackage(path)
            };

            return parse.execute(data);
        }

        return null;
    }

    public static function ReturnFile(directory:String):Path {
        var path = new Path(directory);
        

        return path;
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