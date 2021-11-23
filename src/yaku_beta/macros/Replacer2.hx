package yaku_beta.macros;

import haxe.Json;
#if macro
import Sys;
import sys.io.File;
import sys.FileSystem;
import haxe.io.Path;
#end 

class Replacer2 {

	#if macro

	public static function copyProjectAssets() {
		runMacro();
	}

	private static function runMacro(){
		var cwd:String = Sys.getCwd();
		Sys.println('cwd =  ${cwd}');
        var pi = projectInfo(cwd);
		Sys.println('parsed ${pi.files} files with ${pi.chars} chars');
	}

	public static function projectInfo(dir:String):ProjectInfo {
		var res = {
			files: 0,
			chars: 0
		};

		for (entry in FileSystem.readDirectory(dir)) {
			var srcFile:String = Path.join([dir, entry]);

			if (FileSystem.isDirectory(srcFile)) {
				var pi = projectInfo(srcFile);
				res.chars += pi.chars;
				res.files += pi.files;
			} else {
				var content = File.getContent(srcFile);
				res.files += 1;
				res.chars += content.length;
				try {
					tryReplace(srcFile);
				} catch (e){
					Sys.println(e.message);
				}
			
			}
		}

		return res;
	}

	private static function tryReplace(path:String) {
		if (!StringTools.endsWith(path, ".hx")){
			return;
		}



		var content = File.getContent(path);

		var marker2 = "//@:noGen";
		if (StringTools.startsWith(content, marker2)){
			return;
		}

		var args = parseArgs(content);
		if (args == null){
			return;
		}

		Sys.println('got args!  $args');

		var contentCopy = content;
		var pathCopy = path;
		for (pair in args){
			Sys.println('handle pair ${pair[0]} => ${pair[1]}');
			contentCopy = StringTools.replace(contentCopy, pair[0], pair[1]);
			pathCopy = StringTools.replace(pathCopy, pair[0], pair[1]);
		}

		var preface = '$marker2\n//This file was generated with @:genReplace,\n//from source file $path\n//Do not modify manually, any changes will be overridden';

		contentCopy = '$preface\n$contentCopy';
		if (pathCopy == path){
			Sys.println('replacer func must modify the path ${path}');
			return;
		}
		try {
			File.saveContent(pathCopy, contentCopy);
		}
		catch(e:Dynamic) {
			Sys.println('Failed to write to file $path: $e');
		}
		Sys.println('Save content success with $pathCopy ?');
		
	}

	private static function parseArgs(content:String):Null<Array<Array<String>>>{
		var marker = "@:genReplace(";
		var indexOf = content.indexOf(marker);
		if (indexOf == -1){
			return null;
		}

		var start = indexOf + marker.length;
		var index = start;
		var inQuotes = false;
		var quote = "";
		var end = start;

		var preview = content.substring(start, start+100);
		Sys.println(preview);

		while (index < content.length){
			var char = content.charAt(index);
			if (!inQuotes){
				if (char == ")"){
					Sys.println('break after finding ) at $index');
					end = index;
					break;
				}
				if (char == quote){
					inQuotes = true;
				}
			} else {
				if (char == '"' || char == "'"){
					inQuotes = true;
					quote = char;
				}
			}
			index++;
		}
		var l = end-start;
		var input = content.substring(start, start+l);
		var args:Array<Array<String>> = Json.parse(input);
		return args;
	}
	#end
}

typedef ProjectInfo = {
	files:UInt,
	chars:UInt,
}
