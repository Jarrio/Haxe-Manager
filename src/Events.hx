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

            var file = Parse.ReturnFile(textDocument.fileName);
            var filename = file.file;
            var ext = file.ext;

            if ((textDocument.getText() == null || textDocument.getText() == "") && ext == "hx") {
                trace("Haxe document");
                var content = Parse.ParseHaxeClass(filename, textDocument.fileName);
                if (FileSystem.exists(textDocument.fileName)) {
                    File.saveContent(textDocument.fileName, content);
                }
            }
            

        });        
    }
}