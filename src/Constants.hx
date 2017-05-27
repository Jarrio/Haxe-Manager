package;

import vscode.OutputChannel;
import haxe.io.Path;

class Constants {
    
    private static var output:OutputChannel;

    public static function set_output(out:OutputChannel) {
        output = out;
    }

    public static var extensionRoot:String = Vscode.extensions.getExtension('jarrio.hxmanager').extensionPath;

    public static var templatesRoot:String = Join([extensionRoot, "templates"]);

    public static var classRoot:String = Join([templatesRoot, "classes"]);

    public static var projectsRoot:String =  Join([templatesRoot, "projects"]);


    //New constants
    public static var templates_root(get, never):String;

    public static function get_templates_root() {
        var templates = Join([extensionRoot, "templates"]);
        var config = Helpers.getConfiguration('templatePath');
        
        if (config != null) {
            if (Helpers.pathExists(config)) {
                templates = config;
            } else {
                trace('Error: The path set for the property {templatePath} does not exist. Using default');
                output.appendLine('Error: The path set for the property {templatePath} does not exist. Using default');
            }            
        }
        
        return templates;
    }

    public static var project_root(get, never):String;

    public static function get_project_root() {
        var templates = get_templates_root();
        var projects = Join([templates, 'projects']);
        
        return projects;
    }

    public static var class_root:String = Join([templatesRoot, "classes"]);
    public static var extension_root:String = Vscode.extensions.getExtension('jarrio.hxmanager').extensionPath;

    public static function Join(paths:Array<String>) {
        return ApplySlash(Path.join(paths));
    }

    public static function ApplySlash(directory:String):String {
        return Path.addTrailingSlash(directory);
    }
}