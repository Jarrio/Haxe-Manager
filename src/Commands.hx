package;

import Helpers;
import vscode.OutputChannel;
import vscode.ExtensionContext;

import Vscode.window;
import Vscode.workspace;
import system.enums.EProject;

class Commands {

    private var parse:Parse;
    private var output:OutputChannel;
    private var context:ExtensionContext;

    private var root:String;

    public function new(context:ExtensionContext, output:OutputChannel) {
        
        this.output = output;
        this.context = context;  
        this.parse = new Parse(output);

        this.root = Helpers.getConfiguration('projectRoot');

        Helpers.registerCommand(context, 'CreateProjects', this.createProjects);
    }

    public function createProjects() {
        var items = [];

        for (type in EProject.createAll()) {
            items.push (
                Helpers.quickPickItem(type.getName())
            );
        }

        window.showQuickPick(
            items,
            {
                ignoreFocusOut: true
            }
        ).then(
            function (resolve) {
                trace(resolve);
            }
        );
    }
}