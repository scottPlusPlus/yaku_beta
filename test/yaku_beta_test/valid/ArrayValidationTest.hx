package yaku_beta_test.valid;

import yaku_beta.valid.Validation;
import utest.Assert;

using yaku_beta.valid.StringValidation;
using yaku_beta.valid.ArrayValidation;

class ArrayValidationTest extends utest.Test {
	function testArrayValidation() {

        var initial = ["333", "4444", "55555"];
        var v = new Validation(initial, "strings");
        v.validateEach(function(str:String){
            var sv = new Validation(str, "");
            return sv.maxLength(4);
        });
		Assert.equals(1, v.errors().length);
	}
}