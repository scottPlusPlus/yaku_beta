package yaku_beta.macros;


import haxe.macro.Context;

class Replacer {

   
    // macro public static function someFunc(path:String, path2:String) : ExprOf<String> {

    //     var fileStr = loadFileAsString(path);
    //     var v = 'got file with length ${fileStr.length}: ${fileStr.substr(0, 32)}';

    //     writeFile(path2, fileStr);

    //     return Context.makeExpr(v, Context.currentPos());
    // }

    // #if macro
    // static function loadFileAsString(path:String) {
    //     try {
    //         var p = Context.resolvePath(path);
    //         Context.registerModuleDependency(Context.getLocalModule(),p);
    //         return sys.io.File.getContent(p);
    //     }
    //     catch(e:Dynamic) {
    //         return haxe.macro.Context.error('Failed to load file $path: $e', Context.currentPos());
    //     }
    // }

    // static function writeFile(path:String, content:String):Void{
    //     try {
    //         var f = hx.files.File.of(path);
    //         f.delete();
    //         f.touch();
    //         f.writeString(content);
    //     }
    //     catch(e:Dynamic) {
    //         haxe.macro.Context.error('Failed to write to file $path: $e', Context.currentPos());
    //     }
    // }

    // #end 
}