package;

import haxe.io.Path;

class Constants {
    
    
    public static var extensionRoot:String = Vscode.extensions.getExtension('jarrio.hxmanager').extensionPath;

    public static var templatesRoot:String = Join([extensionRoot, "templates"]);

    public static var classRoot:String = Join([templatesRoot, "classes"]);

    public static var projectsRoot:String =  Join([templatesRoot, "projects"]);


    //New constants
    public static var templates_root:String = Join([extensionRoot, "templates"]);
    public static var class_root:String = Join([templatesRoot, "classes"]);
    public static var project_root:String =  Join([templatesRoot, "projects"]);
    public static var extension_root:String = Vscode.extensions.getExtension('jarrio.hxmanager').extensionPath;

    public static function Join(paths:Array<String>) {
        return ApplySlash(Path.join(paths));
    }

    public static function ApplySlash(directory:String):String {
        return Path.addTrailingSlash(directory);
    }
}