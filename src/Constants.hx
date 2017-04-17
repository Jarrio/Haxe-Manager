package;

import haxe.io.Path;

class Constants {
    
    
    public static var extensionRoot:String = Vscode.extensions.getExtension('jarrio.hxmanager').extensionPath;

    public static var cacheRoot:String = Compile(["cache"]);

    public static var templatesRoot:String = Compile(["templates"]);
    
    public static var classRoot:String = Compile(["templates", "class"]);

    public static var projectHaxeRoot:String = Compile(["templates", "Haxe"]);

    public static var projectHaxeflixelRoot:String = Compile(["templates", "Flixel"]);

    
    public static function ApplySlash(directory:String):String {
        return Path.addTrailingSlash(directory);
    }

    public static function JoinPaths(paths:Array<String>) {
        return Path.join(paths);
    }

    public static function Compile(directories:Array<String>) {
        var compiled = "";
        for (directory in directories) {
            compiled += ApplySlash(directory);
        }

        return ApplySlash(Path.join([extensionRoot, compiled]));
    }
}