package system.commands.projects;

import vscode.OutputChannel;
import haxe.Template;
import sys.io.File;
import Parse;
class Flixel {

    public function new(type:String, name:String, root_dir:String, output:OutputChannel) {
        var project_xml = Constants.Join([root_dir, 'Project.xml']);


        Parse.parseLaunchConfig(root_dir, name);

        if(Helpers.pathExists(project_xml)) {
            var get_content = File.getContent(project_xml);
            var tpl = new Template(get_content);

            var data = {
                name: name, 
                height: 640,
                width: 640
            }

            var content = tpl.execute(data);
            File.saveContent(project_xml, content);      

            output.appendLine("Parsed Flixel project");
        }        
    }
}