package yaku_beta_test.valid;

import yaku_beta.valid.Validator;
import yaku_beta.valid.ArrayValidator;
import utest.Assert;

using yaku_core.NullX;

class ArrayValidatorTest extends utest.Test {
	function testLength() {
		var name = "foo";
		var v = new ArrayValidator(name).minLength(3).maxLength(5);
		Assert.isFalse(v.isValid([]));
		Assert.isTrue(v.isValid([1, 2, 3]));
		Assert.isFalse(v.isValid([1, 2, 3, 4, 5, 6]));
	}

	function testForeach() {
		var intValidator = new Validator<Int>("number").addRule(function(num) {
			if (num < 5) {
				return Pass;
			}
			return Fail(["Number should be less than 5"]);
		});

		var v = new ArrayValidator("foo").validateEach(intValidator);
		Assert.isFalse(v.isValid([4, 6]));
		Assert.isTrue(v.isValid([1, 2, 3]));
	}
}
