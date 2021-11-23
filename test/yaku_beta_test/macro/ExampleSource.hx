package yaku_beta_test.macro;

@:genReplace([["ExampleSource", "ExampleOut"],["example data", "different data"]])
class ExampleSource {

    public var data:String;

    public function new(){
        data = "example data";
    }
}