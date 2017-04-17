// Generated by Haxe 3.4.0
if (process.version < "v4.0.0") console.warn("Module " + (typeof(module) == "undefined" ? "" : module.filename) + " requires node.js version 4.0.0 or higher");
(function ($hx_exports, $global) { "use strict";
var $estr = function() { return js_Boot.__string_rec(this,''); };
function $extend(from, fields) {
	function Inherit() {} Inherit.prototype = from; var proto = new Inherit();
	for (var name in fields) proto[name] = fields[name];
	if( fields.toString !== Object.prototype.toString ) proto.toString = fields.toString;
	return proto;
}
var Commands = function(context,terminal,output) {
	this.output = output;
	this.context = context;
	this.terminal = terminal;
	this.parse = new Parse(output);
	this.project_root = Vscode.workspace.getConfiguration("hxmanager").get("projectRoot");
	this.registerCommand("CreateHaxeProject",$bind(this,this.CreateHaxeProject));
	this.registerCommand("CreateFlixelProject",$bind(this,this.CreateHaxeFlixelProject));
};
Commands.__name__ = true;
Commands.prototype = {
	registerCommand: function(command,callback) {
		this.context.subscriptions.push(Vscode.commands.registerCommand("hxmanager." + command,callback));
		this.output.appendLine("INFO: Command {" + command + "} has been registered");
	}
	,CreateHaxeProject: function() {
		this.ShowInput(Projects.Haxe);
	}
	,CreateHaxeFlixelProject: function() {
		this.ShowInput(Projects.Flixel);
	}
	,ShowInput: function(projectType) {
		var _gthis = this;
		Vscode.window.showInputBox(this.InputBoxProps()).then(function(input) {
			if(input == null || input == "" || input == "undefined") {
				Vscode.window.showInformationMessage("You need to enter a project name!");
				return;
			}
			_gthis.parse.Project(input,projectType);
			Vscode.window.showInformationMessage("Project " + input + " was created!");
		});
	}
	,ClassHaxe: function() {
	}
	,InputBoxProps: function() {
		return { prompt : "Project Name", placeHolder : "Type a name for the project"};
	}
	,__class__: Commands
};
var haxe_io_Path = function(path) {
	switch(path) {
	case ".":case "..":
		this.dir = path;
		this.file = "";
		return;
	}
	var c1 = path.lastIndexOf("/");
	var c2 = path.lastIndexOf("\\");
	if(c1 < c2) {
		this.dir = HxOverrides.substr(path,0,c2);
		path = HxOverrides.substr(path,c2 + 1,null);
		this.backslash = true;
	} else if(c2 < c1) {
		this.dir = HxOverrides.substr(path,0,c1);
		path = HxOverrides.substr(path,c1 + 1,null);
	} else {
		this.dir = null;
	}
	var cp = path.lastIndexOf(".");
	if(cp != -1) {
		this.ext = HxOverrides.substr(path,cp + 1,null);
		this.file = HxOverrides.substr(path,0,cp);
	} else {
		this.ext = null;
		this.file = path;
	}
};
haxe_io_Path.__name__ = true;
haxe_io_Path.join = function(paths) {
	var paths1 = paths.filter(function(s) {
		if(s != null) {
			return s != "";
		} else {
			return false;
		}
	});
	if(paths1.length == 0) {
		return "";
	}
	var path = paths1[0];
	var _g1 = 1;
	var _g = paths1.length;
	while(_g1 < _g) {
		var i = _g1++;
		path = haxe_io_Path.addTrailingSlash(path);
		path += paths1[i];
	}
	return haxe_io_Path.normalize(path);
};
haxe_io_Path.normalize = function(path) {
	var slash = "/";
	path = path.split("\\").join(slash);
	if(path == slash) {
		return slash;
	}
	var target = [];
	var _g = 0;
	var _g1 = path.split(slash);
	while(_g < _g1.length) {
		var token = _g1[_g];
		++_g;
		if(token == ".." && target.length > 0 && target[target.length - 1] != "..") {
			target.pop();
		} else if(token != ".") {
			target.push(token);
		}
	}
	var tmp = target.join(slash);
	var regex_r = new RegExp("([^:])/+","g".split("u").join(""));
	var result = tmp.replace(regex_r,"$1" + slash);
	var acc_b = "";
	var colon = false;
	var slashes = false;
	var _g11 = 0;
	var _g2 = tmp.length;
	while(_g11 < _g2) {
		var i = _g11++;
		var _g21 = tmp.charCodeAt(i);
		switch(_g21) {
		case 47:
			if(!colon) {
				slashes = true;
			} else {
				var i1 = _g21;
				colon = false;
				if(slashes) {
					acc_b += "/";
					slashes = false;
				}
				acc_b += String.fromCharCode(i1);
			}
			break;
		case 58:
			acc_b += ":";
			colon = true;
			break;
		default:
			var i2 = _g21;
			colon = false;
			if(slashes) {
				acc_b += "/";
				slashes = false;
			}
			acc_b += String.fromCharCode(i2);
		}
	}
	return acc_b;
};
haxe_io_Path.addTrailingSlash = function(path) {
	if(path.length == 0) {
		return "/";
	}
	var c1 = path.lastIndexOf("/");
	var c2 = path.lastIndexOf("\\");
	if(c1 < c2) {
		if(c2 != path.length - 1) {
			return path + "\\";
		} else {
			return path;
		}
	} else if(c1 != path.length - 1) {
		return path + "/";
	} else {
		return path;
	}
};
haxe_io_Path.prototype = {
	__class__: haxe_io_Path
};
var EReg = function(r,opt) {
	this.r = new RegExp(r,opt.split("u").join(""));
};
EReg.__name__ = true;
EReg.prototype = {
	match: function(s) {
		if(this.r.global) {
			this.r.lastIndex = 0;
		}
		this.r.m = this.r.exec(s);
		this.r.s = s;
		return this.r.m != null;
	}
	,matched: function(n) {
		if(this.r.m != null && n >= 0 && n < this.r.m.length) {
			return this.r.m[n];
		} else {
			throw new js__$Boot_HaxeError("EReg::matched");
		}
	}
	,matchedRight: function() {
		if(this.r.m == null) {
			throw new js__$Boot_HaxeError("No string matched");
		}
		var sz = this.r.m.index + this.r.m[0].length;
		return HxOverrides.substr(this.r.s,sz,this.r.s.length - sz);
	}
	,matchedPos: function() {
		if(this.r.m == null) {
			throw new js__$Boot_HaxeError("No string matched");
		}
		return { pos : this.r.m.index, len : this.r.m[0].length};
	}
	,__class__: EReg
};
var StringBuf = function() {
	this.b = "";
};
StringBuf.__name__ = true;
StringBuf.prototype = {
	__class__: StringBuf
};
var Std = function() { };
Std.__name__ = true;
Std.string = function(s) {
	return js_Boot.__string_rec(s,"");
};
Std.parseInt = function(x) {
	var v = parseInt(x,10);
	if(v == 0 && (HxOverrides.cca(x,1) == 120 || HxOverrides.cca(x,1) == 88)) {
		v = parseInt(x);
	}
	if(isNaN(v)) {
		return null;
	}
	return v;
};
var js_Boot = function() { };
js_Boot.__name__ = true;
js_Boot.getClass = function(o) {
	if((o instanceof Array) && o.__enum__ == null) {
		return Array;
	} else {
		var cl = o.__class__;
		if(cl != null) {
			return cl;
		}
		var name = js_Boot.__nativeClassName(o);
		if(name != null) {
			return js_Boot.__resolveNativeClass(name);
		}
		return null;
	}
};
js_Boot.__string_rec = function(o,s) {
	if(o == null) {
		return "null";
	}
	if(s.length >= 5) {
		return "<...>";
	}
	var t = typeof(o);
	if(t == "function" && (o.__name__ || o.__ename__)) {
		t = "object";
	}
	switch(t) {
	case "function":
		return "<function>";
	case "object":
		if(o instanceof Array) {
			if(o.__enum__) {
				if(o.length == 2) {
					return o[0];
				}
				var str = o[0] + "(";
				s += "\t";
				var _g1 = 2;
				var _g = o.length;
				while(_g1 < _g) {
					var i = _g1++;
					if(i != 2) {
						str += "," + js_Boot.__string_rec(o[i],s);
					} else {
						str += js_Boot.__string_rec(o[i],s);
					}
				}
				return str + ")";
			}
			var l = o.length;
			var i1;
			var str1 = "[";
			s += "\t";
			var _g11 = 0;
			var _g2 = l;
			while(_g11 < _g2) {
				var i2 = _g11++;
				str1 += (i2 > 0 ? "," : "") + js_Boot.__string_rec(o[i2],s);
			}
			str1 += "]";
			return str1;
		}
		var tostr;
		try {
			tostr = o.toString;
		} catch( e ) {
			return "???";
		}
		if(tostr != null && tostr != Object.toString && typeof(tostr) == "function") {
			var s2 = o.toString();
			if(s2 != "[object Object]") {
				return s2;
			}
		}
		var k = null;
		var str2 = "{\n";
		s += "\t";
		var hasp = o.hasOwnProperty != null;
		for( var k in o ) {
		if(hasp && !o.hasOwnProperty(k)) {
			continue;
		}
		if(k == "prototype" || k == "__class__" || k == "__super__" || k == "__interfaces__" || k == "__properties__") {
			continue;
		}
		if(str2.length != 2) {
			str2 += ", \n";
		}
		str2 += s + k + " : " + js_Boot.__string_rec(o[k],s);
		}
		s = s.substring(1);
		str2 += "\n" + s + "}";
		return str2;
	case "string":
		return o;
	default:
		return String(o);
	}
};
js_Boot.__interfLoop = function(cc,cl) {
	if(cc == null) {
		return false;
	}
	if(cc == cl) {
		return true;
	}
	var intf = cc.__interfaces__;
	if(intf != null) {
		var _g1 = 0;
		var _g = intf.length;
		while(_g1 < _g) {
			var i = _g1++;
			var i1 = intf[i];
			if(i1 == cl || js_Boot.__interfLoop(i1,cl)) {
				return true;
			}
		}
	}
	return js_Boot.__interfLoop(cc.__super__,cl);
};
js_Boot.__instanceof = function(o,cl) {
	if(cl == null) {
		return false;
	}
	switch(cl) {
	case Array:
		if((o instanceof Array)) {
			return o.__enum__ == null;
		} else {
			return false;
		}
		break;
	case Bool:
		return typeof(o) == "boolean";
	case Dynamic:
		return true;
	case Float:
		return typeof(o) == "number";
	case Int:
		if(typeof(o) == "number") {
			return (o|0) === o;
		} else {
			return false;
		}
		break;
	case String:
		return typeof(o) == "string";
	default:
		if(o != null) {
			if(typeof(cl) == "function") {
				if(o instanceof cl) {
					return true;
				}
				if(js_Boot.__interfLoop(js_Boot.getClass(o),cl)) {
					return true;
				}
			} else if(typeof(cl) == "object" && js_Boot.__isNativeObj(cl)) {
				if(o instanceof cl) {
					return true;
				}
			}
		} else {
			return false;
		}
		if(cl == Class ? o.__name__ != null : false) {
			return true;
		}
		if(cl == Enum ? o.__ename__ != null : false) {
			return true;
		}
		return o.__enum__ == cl;
	}
};
js_Boot.__nativeClassName = function(o) {
	var name = js_Boot.__toStr.call(o).slice(8,-1);
	if(name == "Object" || name == "Function" || name == "Math" || name == "JSON") {
		return null;
	}
	return name;
};
js_Boot.__isNativeObj = function(o) {
	return js_Boot.__nativeClassName(o) != null;
};
js_Boot.__resolveNativeClass = function(name) {
	return $global[name];
};
var Vscode = require("vscode");
var Constants = function() { };
Constants.__name__ = true;
Constants.ApplySlash = function(directory) {
	return haxe_io_Path.addTrailingSlash(directory);
};
Constants.JoinPaths = function(paths) {
	return haxe_io_Path.join(paths);
};
Constants.Compile = function(directories) {
	var compiled = "";
	var _g = 0;
	while(_g < directories.length) {
		var directory = directories[_g];
		++_g;
		compiled += Constants.ApplySlash(directory);
	}
	return Constants.ApplySlash(haxe_io_Path.join([Constants.extensionRoot,compiled]));
};
var Events = function(context,terminal,output) {
	this.output = output;
	this.context = context;
	this.terminal = terminal;
	Vscode.workspace.onDidOpenTextDocument(function(textDocument) {
		var file = Parse.ReturnFile(textDocument.fileName);
		var filename = file.file;
		var ext = file.ext;
		if((textDocument.getText() == null || textDocument.getText() == "") && ext == "hx") {
			console.log("Haxe document");
			var content = Parse.ParseHaxeClass(filename,textDocument.fileName);
			if(sys_FileSystem.exists(textDocument.fileName)) {
				js_node_Fs.writeFileSync(textDocument.fileName,content);
			}
		}
	});
};
Events.__name__ = true;
Events.prototype = {
	__class__: Events
};
var Helpers = function() { };
Helpers.__name__ = true;
Helpers.copyFileSync = function(source,target) {
	var targetFile = target;
	if(js_node_Fs.existsSync(target)) {
		if(js_node_Fs.lstatSync(target).isDirectory()) {
			targetFile = js_node_Path.join(target,js_node_Path.basename(source));
		}
	}
	js_node_Fs.writeFileSync(targetFile,js_node_Fs.readFileSync(source));
};
Helpers.copyFolderRecursiveSync = function(source,target) {
	var files = [];
	var targetFolder = js_node_Path.join(target,js_node_Path.basename(source));
	if(!js_node_Fs.existsSync(targetFolder)) {
		js_node_Fs.mkdirSync(targetFolder);
	}
	if(js_node_Fs.lstatSync(source).isDirectory()) {
		files = js_node_Fs.readdirSync(source);
		var _g = 0;
		while(_g < files.length) {
			var file = files[_g];
			++_g;
			var curSource = js_node_Path.join(source,file);
			if(js_node_Fs.lstatSync(curSource).isDirectory()) {
				Helpers.copyFolderRecursiveSync(curSource,targetFolder);
			} else {
				Helpers.copyFileSync(curSource,targetFolder);
			}
		}
	}
};
var HxOverrides = function() { };
HxOverrides.__name__ = true;
HxOverrides.cca = function(s,index) {
	var x = s.charCodeAt(index);
	if(x != x) {
		return undefined;
	}
	return x;
};
HxOverrides.substr = function(s,pos,len) {
	if(len == null) {
		len = s.length;
	} else if(len < 0) {
		if(pos == 0) {
			len = s.length + len;
		} else {
			return "";
		}
	}
	return s.substr(pos,len);
};
var List = function() {
	this.length = 0;
};
List.__name__ = true;
List.prototype = {
	add: function(item) {
		var x = new _$List_ListNode(item,null);
		if(this.h == null) {
			this.h = x;
		} else {
			this.q.next = x;
		}
		this.q = x;
		this.length++;
	}
	,push: function(item) {
		var x = new _$List_ListNode(item,this.h);
		this.h = x;
		if(this.q == null) {
			this.q = x;
		}
		this.length++;
	}
	,first: function() {
		if(this.h == null) {
			return null;
		} else {
			return this.h.item;
		}
	}
	,pop: function() {
		if(this.h == null) {
			return null;
		}
		var x = this.h.item;
		this.h = this.h.next;
		if(this.h == null) {
			this.q = null;
		}
		this.length--;
		return x;
	}
	,isEmpty: function() {
		return this.h == null;
	}
	,__class__: List
};
var _$List_ListNode = function(item,next) {
	this.item = item;
	this.next = next;
};
_$List_ListNode.__name__ = true;
_$List_ListNode.prototype = {
	__class__: _$List_ListNode
};
var Main = function(context) {
	var terminal = Vscode.window.createTerminal("HaxeManager");
	var output = Vscode.window.createOutputChannel("HaxeManager");
	var projectsRoot = Vscode.workspace.getConfiguration("hxmanager").get("projectsRoot");
	if(projectsRoot == null) {
		Vscode.window.showErrorMessage("To use Haxe Manager you must configure a projects root in your settings.json file");
		output.appendLine("ERROR: A root directory to store projects is required");
		output.show(true);
	}
	new Events(context,terminal,output);
	new Commands(context,terminal,output);
};
Main.__name__ = true;
Main.main = $hx_exports["activate"] = function(context) {
	new Main(context);
};
Main.prototype = {
	__class__: Main
};
Math.__name__ = true;
var Parse = function(output) {
	this.save_location = Vscode.workspace.getConfiguration("hxmanager").get("projectsRoot");
	this.output = output;
};
Parse.__name__ = true;
Parse.ParseHaxeClass = function(name,path) {
	if(sys_FileSystem.exists(Constants.classRoot + "/haxeClass.hx")) {
		var structure = js_node_Fs.readFileSync(Constants.classRoot + "/haxeClass.hx",{ encoding : "utf8"});
		var parse = new haxe_Template(structure);
		var data = { name : name, packageName : Parse.ParsePackage(path)};
		return parse.execute(data);
	}
	return null;
};
Parse.ReturnFile = function(directory) {
	var path = new haxe_io_Path(directory);
	return path;
};
Parse.ParsePackage = function(directory) {
	var path = new haxe_io_Path(directory);
	var slash = "";
	if(path.backslash) {
		slash = "\\";
	} else {
		slash = "/";
	}
	var divider = "source";
	if(path.dir.indexOf(divider) == -1) {
		divider = "src";
	}
	var split = path.dir.split(divider);
	if(split.length >= 2) {
		var file_location = StringTools.replace(split[1],slash,".");
		if(file_location.charAt(0) == ".") {
			file_location = file_location.substring(1);
		}
		if(file_location.charAt(file_location.length - 1) == ".") {
			file_location = file_location.substring(0,file_location.length - 2);
		}
		return " " + file_location;
	}
	return "";
};
Parse.prototype = {
	Project: function(name,project) {
		this.projectType = project;
		if(!sys_FileSystem.exists(this.save_location)) {
			this.output.appendLine("ERROR: Projects directory is not set or does not exist");
			return;
		}
		switch(project[1]) {
		case 0:
			this.ParseHaxe(name);
			break;
		case 1:
			this.ParseFlixel(name);
			break;
		}
	}
	,ParseHaxe: function(name) {
		var projectTemplateSrc = Constants.projectHaxeRoot;
		if(!js_node_Fs.statSync(projectTemplateSrc).isDirectory()) {
			this.output.appendLine("ERROR: Can't find Haxe Project Template at {" + projectTemplateSrc + "}");
			return;
		}
		var location = this.save_location + "/" + Std.string(this.projectType);
		var destination = this.save_location + "/" + name;
		this.MoveDirectory(projectTemplateSrc,this.save_location);
		this.RenameDirectory(location,destination);
	}
	,ParseFlixel: function(name) {
		var dir = Constants.projectHaxeflixelRoot;
		if(!js_node_Fs.statSync(dir).isDirectory()) {
			this.output.appendLine("ERROR: Can't find HaxeFlixel Project Template at {" + dir + "}");
			return;
		}
		var location = this.save_location + "/" + Std.string(this.projectType);
		var destination = this.save_location + "/" + name;
		this.MoveDirectory(dir,this.save_location);
		this.RenameDirectory(location,destination);
		var project_file = this.GetFileContents(destination + "/Project.xml");
		var parse = new haxe_Template(project_file);
		var data = { name : name, height : 500, width : 500};
		project_file = parse.execute(data);
		this.SetFileContents(destination + "/Project.xml",project_file);
	}
	,RenameDirectory: function(original,destination) {
		js_node_Fs.renameSync(original,destination);
	}
	,MoveDirectory: function(original,destination) {
		Helpers.copyFolderRecursiveSync(original,destination);
	}
	,GetFileContents: function(path) {
		return js_node_Fs.readFileSync(path,{ encoding : "utf8"});
	}
	,SetFileContents: function(path,content) {
		js_node_Fs.writeFileSync(path,content);
	}
	,__class__: Parse
};
var Reflect = function() { };
Reflect.__name__ = true;
Reflect.field = function(o,field) {
	try {
		return o[field];
	} catch( e ) {
		return null;
	}
};
var Projects = { __ename__ : true, __constructs__ : ["Haxe","Flixel"] };
Projects.Haxe = ["Haxe",0];
Projects.Haxe.toString = $estr;
Projects.Haxe.__enum__ = Projects;
Projects.Flixel = ["Flixel",1];
Projects.Flixel.toString = $estr;
Projects.Flixel.__enum__ = Projects;
var Classes = { __ename__ : true, __constructs__ : ["Haxe","FlixelState","FlixelSprite"] };
Classes.Haxe = ["Haxe",0];
Classes.Haxe.toString = $estr;
Classes.Haxe.__enum__ = Classes;
Classes.FlixelState = ["FlixelState",1];
Classes.FlixelState.toString = $estr;
Classes.FlixelState.__enum__ = Classes;
Classes.FlixelSprite = ["FlixelSprite",2];
Classes.FlixelSprite.toString = $estr;
Classes.FlixelSprite.__enum__ = Classes;
var StringTools = function() { };
StringTools.__name__ = true;
StringTools.replace = function(s,sub,by) {
	return s.split(sub).join(by);
};
var haxe__$Template_TemplateExpr = { __ename__ : true, __constructs__ : ["OpVar","OpExpr","OpIf","OpStr","OpBlock","OpForeach","OpMacro"] };
haxe__$Template_TemplateExpr.OpVar = function(v) { var $x = ["OpVar",0,v]; $x.__enum__ = haxe__$Template_TemplateExpr; $x.toString = $estr; return $x; };
haxe__$Template_TemplateExpr.OpExpr = function(expr) { var $x = ["OpExpr",1,expr]; $x.__enum__ = haxe__$Template_TemplateExpr; $x.toString = $estr; return $x; };
haxe__$Template_TemplateExpr.OpIf = function(expr,eif,eelse) { var $x = ["OpIf",2,expr,eif,eelse]; $x.__enum__ = haxe__$Template_TemplateExpr; $x.toString = $estr; return $x; };
haxe__$Template_TemplateExpr.OpStr = function(str) { var $x = ["OpStr",3,str]; $x.__enum__ = haxe__$Template_TemplateExpr; $x.toString = $estr; return $x; };
haxe__$Template_TemplateExpr.OpBlock = function(l) { var $x = ["OpBlock",4,l]; $x.__enum__ = haxe__$Template_TemplateExpr; $x.toString = $estr; return $x; };
haxe__$Template_TemplateExpr.OpForeach = function(expr,loop) { var $x = ["OpForeach",5,expr,loop]; $x.__enum__ = haxe__$Template_TemplateExpr; $x.toString = $estr; return $x; };
haxe__$Template_TemplateExpr.OpMacro = function(name,params) { var $x = ["OpMacro",6,name,params]; $x.__enum__ = haxe__$Template_TemplateExpr; $x.toString = $estr; return $x; };
var haxe_Template = function(str) {
	var tokens = this.parseTokens(str);
	this.expr = this.parseBlock(tokens);
	if(!tokens.isEmpty()) {
		throw new js__$Boot_HaxeError("Unexpected '" + Std.string(tokens.first().s) + "'");
	}
};
haxe_Template.__name__ = true;
haxe_Template.prototype = {
	execute: function(context,macros) {
		this.macros = macros == null ? { } : macros;
		this.context = context;
		this.stack = new List();
		this.buf = new StringBuf();
		this.run(this.expr);
		return this.buf.b;
	}
	,resolve: function(v) {
		if(v == "__current__") {
			return this.context;
		}
		var o = this.context;
		var tmp;
		var value;
		if(o == null) {
			value = null;
		} else {
			var value1;
			if(o.__properties__) {
				tmp = o.__properties__["get_" + v];
				value1 = tmp;
			} else {
				value1 = false;
			}
			if(value1) {
				value = o[tmp]();
			} else {
				value = o[v];
			}
		}
		if(value != null || Object.prototype.hasOwnProperty.call(this.context,v)) {
			return value;
		}
		var _g_head = this.stack.h;
		while(_g_head != null) {
			var val = _g_head.item;
			_g_head = _g_head.next;
			var ctx = val;
			var tmp1;
			var value2;
			if(ctx == null) {
				value2 = null;
			} else {
				var value3;
				if(ctx.__properties__) {
					tmp1 = ctx.__properties__["get_" + v];
					value3 = tmp1;
				} else {
					value3 = false;
				}
				if(value3) {
					value2 = ctx[tmp1]();
				} else {
					value2 = ctx[v];
				}
			}
			value = value2;
			if(value != null || Object.prototype.hasOwnProperty.call(ctx,v)) {
				return value;
			}
		}
		return Reflect.field(haxe_Template.globals,v);
	}
	,parseTokens: function(data) {
		var tokens = new List();
		while(haxe_Template.splitter.match(data)) {
			var p = haxe_Template.splitter.matchedPos();
			if(p.pos > 0) {
				tokens.add({ p : HxOverrides.substr(data,0,p.pos), s : true, l : null});
			}
			if(HxOverrides.cca(data,p.pos) == 58) {
				tokens.add({ p : HxOverrides.substr(data,p.pos + 2,p.len - 4), s : false, l : null});
				data = haxe_Template.splitter.matchedRight();
				continue;
			}
			var parp = p.pos + p.len;
			var npar = 1;
			var params = [];
			var part = "";
			while(true) {
				var c = HxOverrides.cca(data,parp);
				++parp;
				if(c == 40) {
					++npar;
				} else if(c == 41) {
					--npar;
					if(npar <= 0) {
						break;
					}
				} else if(c == null) {
					throw new js__$Boot_HaxeError("Unclosed macro parenthesis");
				}
				if(c == 44 && npar == 1) {
					params.push(part);
					part = "";
				} else {
					part += String.fromCharCode(c);
				}
			}
			params.push(part);
			tokens.add({ p : haxe_Template.splitter.matched(2), s : false, l : params});
			data = HxOverrides.substr(data,parp,data.length - parp);
		}
		if(data.length > 0) {
			tokens.add({ p : data, s : true, l : null});
		}
		return tokens;
	}
	,parseBlock: function(tokens) {
		var l = new List();
		while(true) {
			var t = tokens.first();
			if(t == null) {
				break;
			}
			if(!t.s && (t.p == "end" || t.p == "else" || HxOverrides.substr(t.p,0,7) == "elseif ")) {
				break;
			}
			l.add(this.parse(tokens));
		}
		if(l.length == 1) {
			return l.first();
		}
		return haxe__$Template_TemplateExpr.OpBlock(l);
	}
	,parse: function(tokens) {
		var t = tokens.pop();
		var p = t.p;
		if(t.s) {
			return haxe__$Template_TemplateExpr.OpStr(p);
		}
		if(t.l != null) {
			var pe = new List();
			var _g = 0;
			var _g1 = t.l;
			while(_g < _g1.length) {
				var p1 = _g1[_g];
				++_g;
				pe.add(this.parseBlock(this.parseTokens(p1)));
			}
			return haxe__$Template_TemplateExpr.OpMacro(p,pe);
		}
		if(HxOverrides.substr(p,0,3) == "if ") {
			p = HxOverrides.substr(p,3,p.length - 3);
			var e = this.parseExpr(p);
			var eif = this.parseBlock(tokens);
			var t1 = tokens.first();
			var eelse;
			if(t1 == null) {
				throw new js__$Boot_HaxeError("Unclosed 'if'");
			}
			if(t1.p == "end") {
				tokens.pop();
				eelse = null;
			} else if(t1.p == "else") {
				tokens.pop();
				eelse = this.parseBlock(tokens);
				t1 = tokens.pop();
				if(t1 == null || t1.p != "end") {
					throw new js__$Boot_HaxeError("Unclosed 'else'");
				}
			} else {
				t1.p = HxOverrides.substr(t1.p,4,t1.p.length - 4);
				eelse = this.parse(tokens);
			}
			return haxe__$Template_TemplateExpr.OpIf(e,eif,eelse);
		}
		if(HxOverrides.substr(p,0,8) == "foreach ") {
			p = HxOverrides.substr(p,8,p.length - 8);
			var e1 = this.parseExpr(p);
			var efor = this.parseBlock(tokens);
			var t2 = tokens.pop();
			if(t2 == null || t2.p != "end") {
				throw new js__$Boot_HaxeError("Unclosed 'foreach'");
			}
			return haxe__$Template_TemplateExpr.OpForeach(e1,efor);
		}
		if(haxe_Template.expr_splitter.match(p)) {
			return haxe__$Template_TemplateExpr.OpExpr(this.parseExpr(p));
		}
		return haxe__$Template_TemplateExpr.OpVar(p);
	}
	,parseExpr: function(data) {
		var l = new List();
		var expr = data;
		while(haxe_Template.expr_splitter.match(data)) {
			var p = haxe_Template.expr_splitter.matchedPos();
			var k = p.pos + p.len;
			if(p.pos != 0) {
				l.add({ p : HxOverrides.substr(data,0,p.pos), s : true});
			}
			var p1 = haxe_Template.expr_splitter.matched(0);
			l.add({ p : p1, s : p1.indexOf("\"") >= 0});
			data = haxe_Template.expr_splitter.matchedRight();
		}
		if(data.length != 0) {
			l.add({ p : data, s : true});
		}
		var e;
		try {
			e = this.makeExpr(l);
			if(!l.isEmpty()) {
				throw new js__$Boot_HaxeError(l.first().p);
			}
		} catch( s ) {
			if (s instanceof js__$Boot_HaxeError) s = s.val;
			if( js_Boot.__instanceof(s,String) ) {
				throw new js__$Boot_HaxeError("Unexpected '" + s + "' in " + expr);
			} else throw(s);
		}
		return function() {
			try {
				return e();
			} catch( exc ) {
				if (exc instanceof js__$Boot_HaxeError) exc = exc.val;
				throw new js__$Boot_HaxeError("Error : " + Std.string(exc) + " in " + expr);
			}
		};
	}
	,makeConst: function(v) {
		haxe_Template.expr_trim.match(v);
		v = haxe_Template.expr_trim.matched(1);
		if(HxOverrides.cca(v,0) == 34) {
			var str = HxOverrides.substr(v,1,v.length - 2);
			return function() {
				return str;
			};
		}
		if(haxe_Template.expr_int.match(v)) {
			var i = Std.parseInt(v);
			return function() {
				return i;
			};
		}
		if(haxe_Template.expr_float.match(v)) {
			var f = parseFloat(v);
			return function() {
				return f;
			};
		}
		var me = this;
		return function() {
			return me.resolve(v);
		};
	}
	,makePath: function(e,l) {
		var p = l.first();
		if(p == null || p.p != ".") {
			return e;
		}
		l.pop();
		var field = l.pop();
		if(field == null || !field.s) {
			throw new js__$Boot_HaxeError(field.p);
		}
		var f = field.p;
		haxe_Template.expr_trim.match(f);
		f = haxe_Template.expr_trim.matched(1);
		return this.makePath(function() {
			return Reflect.field(e(),f);
		},l);
	}
	,makeExpr: function(l) {
		return this.makePath(this.makeExpr2(l),l);
	}
	,makeExpr2: function(l) {
		var p = l.pop();
		if(p == null) {
			throw new js__$Boot_HaxeError("<eof>");
		}
		if(p.s) {
			return this.makeConst(p.p);
		}
		var _g = p.p;
		switch(_g) {
		case "!":
			var e = this.makeExpr(l);
			return function() {
				var v = e();
				if(v != null) {
					return v == false;
				} else {
					return true;
				}
			};
		case "(":
			var e1 = this.makeExpr(l);
			var p1 = l.pop();
			if(p1 == null || p1.s) {
				throw new js__$Boot_HaxeError(p1);
			}
			if(p1.p == ")") {
				return e1;
			}
			var e2 = this.makeExpr(l);
			var p2 = l.pop();
			if(p2 == null || p2.p != ")") {
				throw new js__$Boot_HaxeError(p2);
			}
			var _g1 = p1.p;
			switch(_g1) {
			case "!=":
				return function() {
					return e1() != e2();
				};
			case "&&":
				return function() {
					return e1() && e2();
				};
			case "*":
				return function() {
					return e1() * e2();
				};
			case "+":
				return function() {
					return e1() + e2();
				};
			case "-":
				return function() {
					return e1() - e2();
				};
			case "/":
				return function() {
					return e1() / e2();
				};
			case "<":
				return function() {
					return e1() < e2();
				};
			case "<=":
				return function() {
					return e1() <= e2();
				};
			case "==":
				return function() {
					return e1() == e2();
				};
			case ">":
				return function() {
					return e1() > e2();
				};
			case ">=":
				return function() {
					return e1() >= e2();
				};
			case "||":
				return function() {
					return e1() || e2();
				};
			default:
				throw new js__$Boot_HaxeError("Unknown operation " + p1.p);
			}
			break;
		case "-":
			var e3 = this.makeExpr(l);
			return function() {
				return -e3();
			};
		}
		throw new js__$Boot_HaxeError(p.p);
	}
	,run: function(e) {
		switch(e[1]) {
		case 0:
			var v = e[2];
			var _this = this.buf;
			var x = Std.string(this.resolve(v));
			_this.b += Std.string(x);
			break;
		case 1:
			var e1 = e[2];
			var _this1 = this.buf;
			var x1 = Std.string(e1());
			_this1.b += Std.string(x1);
			break;
		case 2:
			var eelse = e[4];
			var eif = e[3];
			var e2 = e[2];
			var v1 = e2();
			if(v1 == null || v1 == false) {
				if(eelse != null) {
					this.run(eelse);
				}
			} else {
				this.run(eif);
			}
			break;
		case 3:
			var str = e[2];
			this.buf.b += str == null ? "null" : "" + str;
			break;
		case 4:
			var l = e[2];
			var _g_head = l.h;
			while(_g_head != null) {
				var val = _g_head.item;
				_g_head = _g_head.next;
				var e3 = val;
				this.run(e3);
			}
			break;
		case 5:
			var loop = e[3];
			var e4 = e[2];
			var v2 = e4();
			try {
				var x2 = v2.iterator();
				if(x2.hasNext == null) {
					throw new js__$Boot_HaxeError(null);
				}
				v2 = x2;
			} catch( e5 ) {
				try {
					if(v2.hasNext == null) {
						throw new js__$Boot_HaxeError(null);
					}
				} catch( e6 ) {
					throw new js__$Boot_HaxeError("Cannot iter on " + Std.string(v2));
				}
			}
			this.stack.push(this.context);
			var v3 = v2;
			var ctx = v3;
			while(ctx.hasNext()) {
				var ctx1 = ctx.next();
				this.context = ctx1;
				this.run(loop);
			}
			this.context = this.stack.pop();
			break;
		case 6:
			var params = e[3];
			var m = e[2];
			var v4 = Reflect.field(this.macros,m);
			var pl = [];
			var old = this.buf;
			pl.push($bind(this,this.resolve));
			var _g_head1 = params.h;
			while(_g_head1 != null) {
				var val1 = _g_head1.item;
				_g_head1 = _g_head1.next;
				var p = val1;
				if(p[1] == 0) {
					var v5 = p[2];
					pl.push(this.resolve(v5));
				} else {
					this.buf = new StringBuf();
					this.run(p);
					pl.push(this.buf.b);
				}
			}
			this.buf = old;
			try {
				var _this2 = this.buf;
				var x3 = Std.string(v4.apply(this.macros,pl));
				_this2.b += Std.string(x3);
			} catch( e7 ) {
				if (e7 instanceof js__$Boot_HaxeError) e7 = e7.val;
				var plstr;
				try {
					plstr = pl.join(",");
				} catch( e8 ) {
					plstr = "???";
				}
				var msg = "Macro call " + m + "(" + plstr + ") failed (" + Std.string(e7) + ")";
				throw new js__$Boot_HaxeError(msg);
			}
			break;
		}
	}
	,__class__: haxe_Template
};
var haxe_io_Bytes = function() { };
haxe_io_Bytes.__name__ = true;
haxe_io_Bytes.prototype = {
	__class__: haxe_io_Bytes
};
var js__$Boot_HaxeError = function(val) {
	Error.call(this);
	this.val = val;
	this.message = String(val);
	if(Error.captureStackTrace) {
		Error.captureStackTrace(this,js__$Boot_HaxeError);
	}
};
js__$Boot_HaxeError.__name__ = true;
js__$Boot_HaxeError.wrap = function(val) {
	if((val instanceof Error)) {
		return val;
	} else {
		return new js__$Boot_HaxeError(val);
	}
};
js__$Boot_HaxeError.__super__ = Error;
js__$Boot_HaxeError.prototype = $extend(Error.prototype,{
	__class__: js__$Boot_HaxeError
});
var js_node_Fs = require("fs");
var js_node_Path = require("path");
var js_node_buffer_Buffer = require("buffer").Buffer;
var sys_FileSystem = function() { };
sys_FileSystem.__name__ = true;
sys_FileSystem.exists = function(path) {
	try {
		js_node_Fs.accessSync(path);
		return true;
	} catch( _ ) {
		return false;
	}
};
var $_, $fid = 0;
function $bind(o,m) { if( m == null ) return null; if( m.__id__ == null ) m.__id__ = $fid++; var f; if( o.hx__closures__ == null ) o.hx__closures__ = {}; else f = o.hx__closures__[m.__id__]; if( f == null ) { f = function(){ return f.method.apply(f.scope, arguments); }; f.scope = o; f.method = m; o.hx__closures__[m.__id__] = f; } return f; }
String.prototype.__class__ = String;
String.__name__ = true;
Array.__name__ = true;
var Int = { __name__ : ["Int"]};
var Dynamic = { __name__ : ["Dynamic"]};
var Float = Number;
Float.__name__ = ["Float"];
var Bool = Boolean;
Bool.__ename__ = ["Bool"];
var Class = { __name__ : ["Class"]};
var Enum = { };
js_Boot.__toStr = ({ }).toString;
Constants.extensionRoot = Vscode.extensions.getExtension("jarrio.hxmanager").extensionPath;
Constants.cacheRoot = Constants.Compile(["cache"]);
Constants.templatesRoot = Constants.Compile(["templates"]);
Constants.classRoot = Constants.Compile(["templates","class"]);
Constants.projectHaxeRoot = Constants.Compile(["templates","Haxe"]);
Constants.projectHaxeflixelRoot = Constants.Compile(["templates","Flixel"]);
haxe_Template.splitter = new EReg("(::[A-Za-z0-9_ ()&|!+=/><*.\"-]+::|\\$\\$([A-Za-z0-9_-]+)\\()","");
haxe_Template.expr_splitter = new EReg("(\\(|\\)|[ \r\n\t]*\"[^\"]*\"[ \r\n\t]*|[!+=/><*.&|-]+)","");
haxe_Template.expr_trim = new EReg("^[ ]*([^ ]+)[ ]*$","");
haxe_Template.expr_int = new EReg("^[0-9]+$","");
haxe_Template.expr_float = new EReg("^([+-]?)(?=\\d|,\\d)\\d*(,\\d*)?([Ee]([+-]?\\d+))?$","");
haxe_Template.globals = { };
})(typeof exports != "undefined" ? exports : typeof window != "undefined" ? window : typeof self != "undefined" ? self : this, typeof window != "undefined" ? window : typeof global != "undefined" ? global : typeof self != "undefined" ? self : this);

//# sourceMappingURL=main.js.map