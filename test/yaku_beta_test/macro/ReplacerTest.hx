package yaku_beta_test.macro;

import yaku_beta.macros.Replacer;
import utest.Assert;

class ReplacerTest  extends utest.Test {

    function testReplacer(){
        var source = new ExampleSource();
        var out = new ExampleOut();
        Assert.equals("example data", source.data);
        Assert.equals("different data", out.data);
    }
}
