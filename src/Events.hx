package;

import vscode.*;
import Vscode.*;
import sys.io.File;
import vscode.StatusBarItem;

class Events {

    private var output:OutputChannel;
    private var context:ExtensionContext;

    private var parse:Parse;
	private var tasks:StatusBarItem;
    
    public function new(context:ExtensionContext, output:OutputChannel) {
        this.output = output;
        this.context = context;

        this.parse = new Parse(output);

        var watcher = workspace.createFileSystemWatcher("**/*.hx");        
        watcher.onDidCreate(
            function (uri) {
                if (File.getContent(uri.fsPath) == "") {
                    Vscode.commands.getCommands(true).then(                    
                        function (resolve) {
                            this.parse.GetClassTemplates(uri.fsPath);                            
                        },
                        function (reject) {
                            trace("Reject");
                        }
                    );
                }
            }
        );
    }

}