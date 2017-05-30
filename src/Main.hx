package;

import sys.FileSystem;
import Vscode.*;
import vscode.*;

class Main {
    private var completed_setup:Bool = false;
    private var context:ExtensionContext;
    private var output:OutputChannel;
    function new(context:ExtensionContext) {

        this.output = window.createOutputChannel("HaxeManager");   
        this.context = context;     
        
        var projectsRoot = workspace.getConfiguration("hxmanager").get("projectsRoot");
        
        if (projectsRoot == null) {
            this.Setup();
            this.output.show(true);
        } else {
            completed_setup = true;
        }

        if (completed_setup) {
            this.Load();
        }
    }
    
    public function Load() {
        var config = Helpers.getConfiguration('projectType');
        trace('Config: $config');
        if (config == null || config == "" || config == "undefined") {
            workspace.getConfiguration().update('hxmanager.projectType', ["Haxe"], true);
            trace('Set global templates to Haxe');
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
                            this.completed_setup = true;
                            Load();
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
