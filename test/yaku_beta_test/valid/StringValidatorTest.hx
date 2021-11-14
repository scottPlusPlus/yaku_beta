package yaku_beta_test.valid;

import yaku_beta.valid.StringValidator;
import utest.Assert;

using yaku_core.NullX;

@:access(yaku_beta.dstruct.Heap)
class StringValidatorTest extends utest.Test {

    function testMinLength() {
        var name = "foo";
        var v = new StringValidator(name).minLength(3);
        Assert.equals(1, v.errors("").length);
        Assert.equals(1, v.errors("12").length);
        Assert.equals(0, v.errors("123").length);
        Assert.equals(0, v.errors("123456").length);
    }

    function testMaxLength() {
        var name = "foo";
        var v = new StringValidator(name).maxLength(5);
        Assert.equals(0, v.errors("12345").length);
        Assert.equals(1, v.errors("123456").length);
    }
}

