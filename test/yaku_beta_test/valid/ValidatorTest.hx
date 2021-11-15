package yaku_beta_test.valid;

import haxe.ds.ReadOnlyArray;
import yaku_beta.valid.Validator;
import utest.Assert;

using yaku_core.NullX;
using yaku_beta.valid.StringValidator;
using yaku_beta.valid.NumValidator;

class ValidatorTest extends utest.Test {
	function testValidator() {
		var myValidator:VTestClass->String->Validator<VTestClass>;
		myValidator = function(obj:VTestClass, name:String):Validator<VTestClass> {
			var v = new Validator(obj, name);
			v.assertThat(obj.str, '$name.str').minLength(3).maxLength(12);
			v.assertThat(obj.num, '$name.num').minValue(0).maxValue(100);
			v.assertThat(obj.child, '$name.child').rule(myValidator).allowNull();
			return v;
		}

		var foo = VTestClass.example();
		Assert.isTrue(myValidator(foo, "Foo").isValid());

		foo.child.str = "";
		Assert.equals(1, myValidator(foo, "Foo").errors().length);
		Assert.stringContains("Foo.child.str", myValidator(foo, "Foo").firstError());

		foo.num = 200;
		Assert.equals(2, myValidator(foo, "Foo").errors().length);
	}

	function testRuleUnification() {
		var foo = VTestClass.example();
		var v = new Validator(foo, "Foo");

		v.rule(["An Error!"]);
		v.rule(function(obj:VTestClass, name:String) {
			if (obj.child != null) {
				return ['$name child should be null'];
			}
			return [];
		});
		v.rule(function(obj:VTestClass, name:String) {
			var v2 = new Validator(obj, name);
			v2.assertThat(obj.str, '$name.str').minLength(123);
			return v2;
		});
		Assert.equals(3, v.errors().length);
	}

    function namedValidator(obj:VTestClass, name:String):Validator<VTestClass> {
        var v = new Validator(obj, name);
        v.assertThat(obj.str, '$name.str').minLength(3).maxLength(12);
        v.assertThat(obj.child, '$name.child').rule(namedValidator).allowNull();
        return v;
    }

    function testSpeed(){
        var loops = 1000000;
        var subject = VTestClass.example();

        var newValidator:VTestClass->?String->Validator<VTestClass>;
        newValidator = function(obj:VTestClass, name:String = "VTest"):Validator<VTestClass> {
			var v = new Validator(obj, name);
			v.assertThat(obj.str, '$name.str').minLength(3).maxLength(12).contains("first");
			v.assertThat(obj.child, '$name.child').rule(newValidator).allowNull();
			return v;
		}

        var oldValidator = new yaku_beta.valid1.Validator<VTestClass>("Foo");
        oldValidator.allowNull = true;
        var strV = new yaku_beta.valid1.StringValidator("Foo.str").minLength(3).maxLength(12).contains("first").asRule(function(obj){ return obj.str;});
        oldValidator.addRule(strV);
        oldValidator.addRule(oldValidator.asRule(function(obj){return obj.child;}));


        var start = Date.now().getTime();
        for (_ in 0...loops){
            var errs = newValidator(subject).errors();
            var _ = errs.length;
        }
        var newTime = Date.now().getTime() - start;

        start = Date.now().getTime();
        for (_ in 0...loops){
            var errs = oldValidator.errors(subject);
            var _ = errs.length;
        }
        var oldTime = Date.now().getTime() - start;

        trace('Validation:\nnewTime: $newTime \noldTime: $oldTime \n');

        var newErrs = newValidator(subject, "foo").errors();
        var oldErrs = oldValidator.errors(subject);
        trace('Validation:\n newErrs: $newErrs \n oldErrs: $oldErrs \n');
    }
}

class VTestClass {
	public var str:String;
	public var num:Int;
	public var child:VTestClass;

	public function new() {}

	public static function example():VTestClass {
		var x = new VTestClass();
		x.str = "first";
		x.num = 1;
		x.child = new VTestClass();
		x.child.str = "second";
		x.child.num = 2;
		return x;
	}
}
