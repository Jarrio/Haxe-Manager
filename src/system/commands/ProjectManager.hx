package system.commands;

import sys.FileSystem;
import Helpers;
import Vscode.window;

    /*****
      * Basic project manager based on the home root. 
      * Currently doesn't allow more than one sub-folder as a proper
      * Recursive method has not been implemented
      *****/

class ProjectManager {
    public function new() {
        
    }

    public function manage() {
        var projects = [];
        var homeRoot = Helpers.getConfiguration('projectsRoot');

        if (Helpers.pathExists(homeRoot)) {
            var dirs = FileSystem.readDirectory(homeRoot);

            if (dirs.length == 0) {
                window.showInformationMessage('No projects to show');
                return;
            }

            for (dir in dirs) {
                var detail = Helpers.homeRoot([dir]);
                projects.push(Helpers.quickPickItem(dir, null, detail));
            }

            window.showQuickPick(projects, {matchOnDetail: true, ignoreFocusOut: true}).then(
                function (resolve) {
                    var folders = [];
                    var more_dirs = FileSystem.readDirectory(resolve.detail);

                    if (more_dirs.length == 0) {
                        window.showInformationMessage('No projects to show');
                        return;
                    }

                    var opened = false;

                    for (project in more_dirs) {
                        var location = Constants.Join([resolve.detail, project]);

                        if (!FileSystem.isDirectory(location)){
                            opened = true;
                            Helpers.openProject(resolve.detail);
                            return;
                        }
                    }

                    if (opened) return;

                    for (dir in more_dirs) {
                        var detail = Constants.Join([resolve.detail, dir]);
                        folders.push(Helpers.quickPickItem(dir, null, detail));                        
                    }

                    window.showQuickPick(folders, {matchOnDetail: true, ignoreFocusOut: true}).then(
                        function (resolve) {
                            Helpers.openProject(resolve.detail);
                        }
                    );
                }
            );
        }
    }
}

