package;

import vscode.OutputChannel;
import haxe.Constraints.Function;
import sys.FileSystem;
import js.node.Fs;
import js.node.Path;
import vscode.QuickPickItem;
import vscode.InputBoxOptions;
import Vscode.window;
import vscode.ExtensionContext;
import Vscode.commands;
import Vscode.workspace;

class Helpers {
    /**
     *  Helper to register a command 
     *  @param name - Internal identifier for the command
     *  @param event - Tell vscode what to do with when this command has been called
     **/
    public static function registerCommand(context:ExtensionContext, name:String, event:Function) {
        context.subscriptions.push(
            commands.registerCommand('hxmanager.$name', event);
        );
    }

    /**
     *  Helper to trigger an input box
     *  @param options - Configure the input box 
     *  @param onResolve - The callback for the a successful return
     *  @param onReject - Optional callback if any errors occured
     **/
    public static function showInput(?options:InputBoxOptions, onResolve:Null<String>->Void, ?onReject:Dynamic->Void) {
        window.showInputBox(options).then(onResolve, onReject);
    }

    /**
     *  Helper to generate a quick pick item
     *  @param label - Title of the item
     *  @param description - Appears next to the title, a description of the item
     *  @param detail - Provide more information or keywords in the detail portion. Is hidden by default
     *  @return QuickPickItem
     **/
    public static function quickPickItem(label:String, ?description:String, ?detail:String):QuickPickItem {
        return {
            label: label,
            description: description,
            detail: detail;
        }
    }

    /**
     *  Helper to open a project 
     *  @param source - Path to the project
     *  @param newWindow - Open the project in a new window
     **/
    public static function openProject(source:String, newWindow:Null<Bool> = null) {
        if (newWindow == null) {
            newWindow = workspace.getConfiguration('hxmanager').get('newWindow');            
        }
        
        var uri = vscode.Uri.file(source);
        commands.executeCommand("vscode.openFolder", uri, newWindow);        
    }

    public static function copyFileSync(source:String, target:String) {
        //if target is a directory a new file with the same name will be created
        if (FileSystem.exists(target)) {
            if (Fs.lstatSync(target).isDirectory()) {
                target = Path.join(target, Path.basename(source));
            }
        }

        Fs.writeFileSync(target, Fs.readFileSync(source));
    }

    public static function copyFolderRecursiveSync(source, target) {
        var files = [];

        //check if folder needs to be created or integrated
        var targetFolder = Path.join(target, Path.basename(source));
        if (!FileSystem.exists(targetFolder)) {
            Fs.mkdirSync(targetFolder);
        }

        //copy
        if (Fs.lstatSync(source).isDirectory()) {
            files = Fs.readdirSync(source);

            for (file in files) {
                var curSource = Path.join(source, file);
                if (Fs.lstatSync(curSource).isDirectory()) {
                    copyFolderRecursiveSync(curSource, targetFolder);
                } else {
                    copyFileSync(curSource, targetFolder);
                }
            }
        }
    }
}