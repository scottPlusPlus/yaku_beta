package yaku_beta_test.valid;

import yaku_beta.valid.Validator;
import utest.Assert;

using yaku_core.NullX;


class ValidatorTest extends utest.Test {

    function testNulls() {
        var v = new Validator<Int>("num");
        Assert.isFalse(v.isValid(null));

        v.allowNull = true;
        Assert.isTrue(v.isValid(null));
    }
}

