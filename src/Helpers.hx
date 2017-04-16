package;

import js.node.Fs;
import js.node.Path;

class Helpers {
    public static function copyFileSync( source, target ) {

        var targetFile = target;

        //if target is a directory a new file with the same name will be created
        if ( Fs.existsSync( target ) ) {
            if ( Fs.lstatSync( target ).isDirectory() ) {
                targetFile = Path.join( target, Path.basename( source ) );
            }
        }

        Fs.writeFileSync(targetFile, Fs.readFileSync(source));
    }

    public static function copyFolderRecursiveSync( source, target ) {
        var files = [];

        //check if folder needs to be created or integrated
        var targetFolder = Path.join( target, Path.basename( source ) );
        if ( !Fs.existsSync( targetFolder ) ) {
            Fs.mkdirSync( targetFolder );
        }

        //copy
        if ( Fs.lstatSync( source ).isDirectory() ) {
            files = Fs.readdirSync( source );

            for (file in files) {
                var curSource = Path.join( source, file );
                if ( Fs.lstatSync( curSource ).isDirectory() ) {
                    copyFolderRecursiveSync( curSource, targetFolder );
                } else {
                    copyFileSync( curSource, targetFolder );
                }
            }
        }
    }
}