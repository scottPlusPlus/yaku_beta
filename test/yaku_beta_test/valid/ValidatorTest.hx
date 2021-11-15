package yaku_beta_test.valid;

import yaku_beta.valid.Validator;
import yaku_beta.valid.ValueValidator;
import utest.Assert;

using yaku_core.NullX;
using yaku_beta.valid.StringValidator;


class ValidatorTest extends utest.Test {

    function testUsage(){

        var foo = new Foo2Class();
        foo.str = "hello";
        foo.num = 5;
        foo.child = new Foo2Class();

        var numValidator = function(num:Int, name:String):Validator {          
            if (num < 0){
                return ['${name} must be >= 0'];
            }
            return [];
        }

        var v = Foo2Class.validate(foo, "Foo");
        v.assertThat(foo.num, "Foo.num").rule(numValidator);
        trace('v2 errors:');
        trace(v.errors());
        Assert.isTrue(v.isValid());
    }

    
}


class Foo2Class {
    public var str:String;
    public var num:Int;
    public var child:Foo2Class;

    public function new(){}

    public static function validate(foo:Foo2Class, name:String):Validator {
        var v = new Validator();
        v.assertThat(foo.str, '$name.str').minLength(3).maxLength(12);
        v.assertThat(foo.child, '$name.child').rule(Foo2Class.validate).allowNull();
        return v;
    }
}
