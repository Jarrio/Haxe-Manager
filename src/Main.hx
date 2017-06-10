package;

import haxe.io.Path;
import sys.FileSystem;
import Vscode.*;
import vscode.*;

class Main {
    private var completed_setup:Bool = false;
    private var context:ExtensionContext;
    private var output:OutputChannel;

    function new(context:ExtensionContext) {
        Constants.set_output(output);
        
        this.output = window.createOutputChannel("HaxeManager");   
        this.output.appendLine('Starting Haxe Manager');
        this.context = context;     
        
        var projectsRoot = workspace.getConfiguration("hxmanager").get("projectsRoot");
        
        if (projectsRoot == null) {
            this.Setup();
            this.output.show(true);
        } else {
            completed_setup = true;
        }

        if (completed_setup) {
            this.output.appendLine('Loading extension...');
            this.Load();
        }
    }
    
    public function Load() {
        var config = Helpers.getConfiguration('projectType');
        
        if (config == null || config == "" || config == "undefined") {
            workspace.getConfiguration().update('hxmanager.projectType', ["Haxe"], true);
            this.output.appendLine('Set global templates to Haxe');
        }

        new Events(context, output);
        new Commands(context, output);

        this.output.appendLine('Loaded events and commands');
    }

    public function Setup() {
        this.output.appendLine('Running through initial setup steps...');
        var props:InputBoxOptions = { 
            prompt: "Where would you like to store your projects?",
            placeHolder: "File path",
            ignoreFocusOut: true   
        }

        window.showInputBox(props).then(
            function (input) {
                if (FileSystem.exists(input)) {
                    workspace.getConfiguration().update('hxmanager.projectsRoot', input, true).then(
                        function (resolve) {
                            this.completed_setup = true;
                            Load();
                            window.showInformationMessage('Project root directory has been set');
                            
                            //@TODO: Change to loop through an array rather than manually do this QUICK BUGFIX
                            var khaPath = Path.join([input, 'Kha']);
                            var FlxPath = Path.join([input, 'Flixel']);
                            var HaxPath = Path.join([input, 'Haxe']);
                            
                            FileSystem.createDirectory(khaPath);
                            FileSystem.createDirectory(FlxPath);
                            FileSystem.createDirectory(HaxPath);

                            output.appendLine('Project root directory has been set to $input');
                        }
                    );
                    return;
                } else {
                    window.showErrorMessage('Failed to set directory to {$input} does it exist?');
                    output.appendLine('Couldn\'t find the path: $input');
                }
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
