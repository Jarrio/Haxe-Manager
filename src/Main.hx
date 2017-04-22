package;

import Vscode.*;
import vscode.*;

class Main {

    function new(context:ExtensionContext) {

        var output = window.createOutputChannel("HaxeManager");        
        
        var projectsRoot = workspace.getConfiguration("hxmanager").get("projectsRoot");

        if (projectsRoot == null) {
            window.showWarningMessage("To create projects from haxe-manager you must configure root directory in your (global) settings.json file");
            output.appendLine("WARNING: Can't create projects without defining a source");

            output.show(true);
        }
    
        new Events(context, output);
        new Commands(context, output);
    }


    @:keep
    @:expose("activate")
    static function main(context:ExtensionContext) {
        haxe.Log.trace = haxe.Log.trace;
        new Main(context);
    }



}
