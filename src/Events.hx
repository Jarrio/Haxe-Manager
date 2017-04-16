package;

import sys.FileSystem;
import vscode.*;
import Vscode.*;
import sys.io.File;

class Events {

    private var terminal:Terminal;
    private var output:OutputChannel;
    private var context:ExtensionContext;

    private var parse:Parse;
    
    public function new(context:ExtensionContext, terminal:Terminal, output:OutputChannel) {
        this.output = output;
        this.context = context;
        this.terminal = terminal;

        
        
        workspace.onDidOpenTextDocument(function(textDocument) {
            var split = textDocument.fileName.split('.');

            if (split.length == 2) {
                var path = split[0];
                var dirs = path.split('/');
                if (dirs.length == 1) {
                    dirs = path.split('\\');
                }

                var filename = dirs[dirs.length - 1];
                
                trace(path);

                var ext = split[1];

                if ((textDocument.getText() == null || textDocument.getText() == "") && ext == "hx") {
                    trace("Haxe document");
                    var content = Parse.ParseHaxeClass(filename);
                    if (FileSystem.exists(textDocument.fileName)) {
                        File.saveContent(textDocument.fileName, content);
                    }
                }
            }

        });        
    }
}