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

    public static function ParseHaxeClass(name:String):String {
        var structure = sys.io.File.getContent(Constants.classRoot + '/haxeClass.hx');
        var parse = new Template(structure);

        return parse.execute({name: name});
    }

    public static function ParsePackage(
}