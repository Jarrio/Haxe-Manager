package system.commands.projects;

import sys.io.File;
import haxe.Template;
import vscode.OutputChannel;
class Kha {
    public function new(type:String, name:String, root_dir:String, output:OutputChannel) {
        Parse.parseLaunchConfig(root_dir, name);

        var kha_file = Constants.Join([root_dir, 'khafile.js']);

        if(Helpers.pathExists(kha_file)) {
            var get_content = File.getContent(kha_file);
            var kha_file_tpl = new Template(get_content);

            var data = {
                name: name                
            }

            var content = kha_file_tpl.execute(data);
            File.saveContent(kha_file, content);      

            output.appendLine("Parsed Khafile.js");
        }

        var tasks_file = Constants.Join([root_dir, '.vscode', 'tasks.json']);
        
        if (Helpers.pathExists(tasks_file)) {

            var get_content = File.getContent(tasks_file); 
            var tasks_file_tpl = new Template(get_content);

            var khaPath = Helpers.getConfiguration('khaPath');            
            khaPath = StringTools.replace(khaPath, "\\", "\\\\");
            
            var data = {
                path: khaPath
            }

            output.appendLine('Path to Kha: $data');
            
            var content = tasks_file_tpl.execute(data);
            File.saveContent(tasks_file, content);
        }      
    }        
}