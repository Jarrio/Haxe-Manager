package;

import Vscode.*;
import vscode.*;

class Main {

    function new(context:ExtensionContext) {
        var terminal = window.createTerminal("HaxeManager");
        var output = window.createOutputChannel("HaxeManager");        
        
        var projectsRoot = workspace.getConfiguration("hxmanager").get("projectsRoot");

        if (projectsRoot == null) {
            window.showErrorMessage("To use Haxe Manager you must configure a projects root in your settings.json file");
            output.appendLine("ERROR: A root directory to store projects is required");

            output.show(true);
        }
    
        new Events(context, terminal, output);
        new Commands(context, terminal, output);
    }

    @:keep
    @:expose("activate")
    static function main(context:ExtensionContext) {
        new Main(context);
    }



}
