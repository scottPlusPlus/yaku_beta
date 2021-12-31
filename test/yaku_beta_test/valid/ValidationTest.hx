package yaku_beta_test.valid;

import haxe.ds.ReadOnlyArray;
import yaku_beta.valid.Validation;
import utest.Assert;

using yaku_core.NullX;
using yaku_beta.valid.StringValidation;
using yaku_beta.valid.NumValidation;

class ValidationTest extends utest.Test {
	function testValidator() {
		var testValidation:VTestClass->String->Validation<VTestClass>;
		testValidation = function(obj:VTestClass, name:String):Validation<VTestClass> {
			var v = new Validation(obj, name);
			v.validateObject(obj.str, '$name.str').minLength(3).maxLength(12);
			v.validateObject(obj.num, '$name.num').minValue(0).maxValue(100);
			v.validateObject(obj.child, '$name.child').addRule(testValidation).allowNull();
			return v;
		}

		var foo = VTestClass.example();
		Assert.isTrue(testValidation(foo, "Foo").isValid());

		foo.child.str = "";
		Assert.equals(1, testValidation(foo, "Foo").errors().length);
		Assert.stringContains("Foo.child.str", testValidation(foo, "Foo").firstError());

		foo.num = 200;
		Assert.equals(2, testValidation(foo, "Foo").errors().length);
	}

	function testRuleUnification() {
		var foo = VTestClass.example();
		var v = new Validation(foo, "Foo");

		v.addError("An Error!");
		v.addRule(function(obj:VTestClass, name:String) {
			if (obj.child != null) {
				return ['$name child should be null'];
			}
			return [];
		});
		v.addRule(function(obj:VTestClass, name:String) {
			var v2 = new Validation(obj, name);
			v2.validateObject(obj.str, '$name.str').minLength(123);
			return v2;
		});
		Assert.equals(3, v.errors().length);
	}

    function namedValidator(obj:VTestClass, name:String):Validation<VTestClass> {
        var v = new Validation(obj, name);
        v.validateObject(obj.str, '$name.str').minLength(3).maxLength(12);
        v.validateObject(obj.child, '$name.child').addRule(namedValidator).allowNull();
        return v;
    }

    function testSpeed(){
        var loops = 1000000;
        var subject = VTestClass.example();

        var newValidation:VTestClass->?String->Validation<VTestClass>;
        newValidation = function(obj:VTestClass, name:String = "VTest"):Validation<VTestClass> {
			var v = new Validation(obj, name);
			v.validateObject(obj.str, '$name.str').minLength(3).maxLength(12).contains("first");
			v.validateObject(obj.child, '$name.child').addRule(newValidation).allowNull();
			return v;
		}

        var oldValidator = new yaku_beta.valid1.Validator<VTestClass>("Foo");
        oldValidator.allowNull = true;
        var strV = new yaku_beta.valid1.StringValidator("Foo.str").minLength(3).maxLength(12).contains("first").asRule(function(obj){ return obj.str;});
        oldValidator.addRule(strV);
        oldValidator.addRule(oldValidator.asRule(function(obj){return obj.child;}));


        var start = Date.now().getTime();
        for (_ in 0...loops){
            var errs = newValidation(subject).errors();
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

        var newErrs = newValidation(subject, "foo").errors();
        var oldErrs = oldValidator.errors(subject);
        trace('Validation:\n newErrs: $newErrs \n oldErrs: $oldErrs \n');
		Assert.pass();
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
