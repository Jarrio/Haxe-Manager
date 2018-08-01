package;

import vscode.FileType;
import vscode.OutputChannel;
import haxe.io.Path;

class Constants {
    
    private static var output:OutputChannel;
    
    /**
     *  Reference to the output channel to keep track of certain events
     *  @param out - The output channel
     **/
    public static function set_output(out:OutputChannel) {
        output = out;
    }

    /**
     * Returns the root folder for templates
     **/
    public static var templates_root(get, never):String;
    
    public static var extension_root:String = Vscode.extensions.getExtension('jarrio.hxmanager').extensionPath;
    public static function get_templates_root() {
        var templates = Join([extension_root, "templates"]);
        var config = Helpers.getConfiguration('templatePath');
        
        if (config != null) {
            if (Helpers.pathExists(config)) {
                templates = config;
                // output.appendLine('Using custom templates directory: ${config}');
            } else {
                // output.appendLine('Error: The path set for the property {templatePath} does not exist. Using default');
            }            
        }
         
        return templates;
    }

    /**
     *  Accessor for the project root
     **/
    public static var project_root(get, never):String;

    /**
     *  Getter for the project root directory
     *  @return String
     **/
    public static function get_project_root():String {
        var templates = get_templates_root();
        var projects = Join([templates, 'projects']);
        
        return projects;
    }

    /**
     *  Returns the class root folder
     **/
    public static var class_root:String = Join([templates_root, "classes"]);
    

    /**
     *  Attempts to format the path into a consistant way
     *  @param paths - An array of the folder paths. No slashes are required
     **/
    public static function Join(paths:Array<String>) {
		// var file_found = false;
		// if (paths == null || paths.length == 0) {
		// 	return null;
		// }

		// for (item in paths) {
		// 	if (item == null) {
		// 		continue;
		// 	}

		// 	if (item.indexOf('.') != -1) {
		// 		file_found = true;
		// 		break;
		// 	}
		// }

		var path = Path.join(paths);
		// if (file_found) {
		// 	var file_type = path.split('.')[1];
			
		// 	if (file_type != null && !checkFileTypes(file_type))  {
		// 		file_type = file_type.substring(0, file_type.length - 1);
				
		// 		if (!checkFileTypes(file_type)) {
		// 			trace('Invalid file type {Unknown error} | $file_type');
		// 			return null;
		// 		}

		// 		path = path.substring(0, path.length - 1);
		// 	}
		// }

        return path;
    }

    /**
     *  Used internally to autp append a slash at the end of processed paths. Used for consistancy
     *  @param directory - The path to attach a trailing slash
     *  @return String
     **/
    private static function ApplySlash(directory:String):String {
        return Path.addTrailingSlash(directory);
    }

	private static function checkFileTypes(extension:String):Bool {
		return (extension == 'hx' || extension == 'json' || extension == 'xml');
	}
}