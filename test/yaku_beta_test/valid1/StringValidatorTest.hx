package yaku_beta_test.valid1;

import yaku_beta.valid1.StringValidator;
import utest.Assert;
import tink.core.Outcome;

using yaku_core.NullX;


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

    function testExample() {
        var name = "foo";
        var v = new StringValidator(name)
            .minLength(3).maxLength(12).contains("foo");

        var o = v.validOutcome("foo2");
        Assert.isTrue(o.isSuccess());

        o = v.validOutcome("asfdasfd");
        Assert.isFalse(o.isSuccess());
    }
}

