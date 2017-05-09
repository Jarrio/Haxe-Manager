package::location::;

import react.ReactComponent;
import react.ReactMacro.jsx;
import react.native.api.*;
import react.native.component.*;

class ::name:: extends ReactComponent {
	static var styles = Main.styles;

    function new(props) {
        super(props);
        
    }
	
	override function render() {
		return jsx('
			<View style={styles.container}>
				<Text style={styles.text}>
					This scene is ::name::
				</Text>
			</View>
		');
	}
}