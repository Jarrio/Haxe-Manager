package;

import sys.FileSystem;
import Vscode.*;
import vscode.*;

class Main {

    function new(context:ExtensionContext) {

        var output = window.createOutputChannel("HaxeManager");        
        
        var projectsRoot = workspace.getConfiguration("hxmanager").get("projectsRoot");
        var seperate = workspace.getConfiguration('hxmanager').get('seperateFolders');
        
        if (projectsRoot == null) {
            Setup();
            // window.showWarningMessage("To create projects from haxe-manager you must configure root directory in your (global) settings.json file. (hxmanger.projectType)");
            // output.appendLine("WARNING: Can't create projects without defining a source");

            output.show(true);
        }
    
        new Events(context, output);
        new Commands(context, output);
    }
    
    public function Setup() {


        var props:InputBoxOptions = { 
            prompt: "Where would you like to store your projects?",
            placeHolder: "File path",
            ignoreFocusOut: true   
        }

        // window.showInformationMessage("Would you like projects to be seperated in the root folder based on project type? (default: Yes)", { modal: true }, 'Yes', 'No').then(


        window.showInputBox(props).then(
            function (input) {
                if (FileSystem.exists(input)) {
                    workspace.getConfiguration().update('hxmanager.projectsRoot', input, true).then(
                        function (resolve) {
                            window.showInformationMessage('Project root directory has been set');
                        }
                    );
                    return;
                }
                
                window.showErrorMessage('Failed to set directory to {$input} does it exist?');
            }
        );
    }

    @:keep
    @:expose("activate")
    static function main(context:ExtensionContext) {
        haxe.Log.trace = haxe.Log.trace;
        new Main(context);
    }



}
