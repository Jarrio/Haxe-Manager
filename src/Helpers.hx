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
     *  Get the templates path for projects
     *  @param type - The type of project
     *  @return String
     **/
    public static function projectPath(type:String):String {
        var source = Constants.Join([Constants.project_root, type]);
        

        if (!pathExists(source)) {
            return null;
        }

        return source;
    }

    /**
     *  Get a path based off of the projects root directory
     *  @param path - Optional extension for the projects root folder
     *  @return String
     **/
    public static function homeRoot(?path:Array<String>):String {
        var home = getConfiguration('projectsRoot');
        path.insert(0, home);

        var path = Constants.Join(path);
        return (path);
    }
    /**
     *  Check if directory or file exists
     *  @param path - location of the directory or file
     *  @return Bool
     **/
    public static function pathExists(path:String):Bool {
        if (!FileSystem.exists(path)) {
            return false;
        }
        return true;
    }
    
    /**
     *  Get extension settings
     *  @param value - The specific setting identifier
     *  @param source - Root access to the setting
     **/
    public static function getConfiguration(value:String, source:String = 'hxmanager') {
        return workspace.getConfiguration(source).get(value);
    }

    /**
     *  Register a command 
     *  @param name - Internal identifier for the command
     *  @param event - Tell vscode what to do with when this command has been called
     **/
    public static function registerCommand(context:ExtensionContext, name:String, event:Function) {
        context.subscriptions.push(
            commands.registerCommand('hxmanager.$name', event)
        );
    }

    /**
     *  Trigger an input box
     *  @param options - Configure the input box 
     *  @param onResolve - The callback for the a successful return
     *  @param onReject - Optional callback if any errors occured
     **/
    public static function showInput(?options:InputBoxOptions, onResolve:Null<String>->Void, ?onReject:Dynamic->Void) {
        window.showInputBox(options).then(onResolve, onReject);
    }

    /**
     *  Generate a quick pick item
     *  @param label - Title of the item
     *  @param description - Appears next to the title, a description of the item
     *  @param detail - Provide more information or keywords in the detail portion. Is hidden by default
     *  @return QuickPickItem
     **/
    public static function quickPickItem(label:String, ?description:String, ?detail:String):QuickPickItem {
        return {
            label: label,
            description: description,
            detail: detail
        }
    }

    /**
     *  Open a project 
     *  @param source - Path to the project
     *  @param newWindow - Open the project in a new window
     **/
    public static function openProject(source:String, newWindow:Null<Bool> = null) {
        if (newWindow == null) {
            trace('Here');
            newWindow = workspace.getConfiguration('hxmanager').get('newWindow');            
        }
        
        trace('Here');
        var uri = vscode.Uri.file(source);
        commands.executeCommand("vscode.openFolder", uri, newWindow).then(
            function (resolve) {
                trace('Here');
            },

            function (reject) {
                trace('error: $reject');
            }
        );     
    }

    /**
     *  Rename a directory
     *  @param source - Original folder
     *  @param destination - Renamed folder
     **/
    public static function renameDirectory(source:String, destination:String, output:OutputChannel) {         
        if (pathExists(destination)) {
            window.showErrorMessage('A project already exists with that name');
            output.appendLine('Error: A folder exists at the path {$destination}');
            return;
        }

        FileSystem.rename(source, destination);
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

    public static function copyFolders(source, target, ?callback) {
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
                    copyFolders(curSource, targetFolder );
                } else {
                    copyFileSync(curSource, targetFolder);
                }
            }
        }
    }
}