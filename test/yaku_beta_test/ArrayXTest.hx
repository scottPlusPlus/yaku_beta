package yaku_beta_test;

import zenlog.Log;
import utest.Assert;
import yaku_core.test_utils.TestUtils;

using yaku_core.ArrayX;
using yaku_beta.ArrayX;

class ArrayXTest extends utest.Test {

    public function testInsertMany() {
        var start = ["a", "c", "f"];
        start.insertMany([].ins(1, "b").ins(3, "d").ins(4, "e"));
        var expected = ["a","b","c","d","e","f"];
        Assert.same(expected, start);
    }

    // public function testInsertManySpeed(){
    //     var loops = 1000000;
    //     var insertMany = function(){
    //         var arr = ["a", "c", "f", "g", "h", "i", "k",  "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x"];
    //         arr.insertMany([].ins(1, "b").ins(3, "d").ins(4, "e").ins(9, "j").ins(10, "k").ins(11, "l"));
    //     }

    //     var insertNormally = function() {
    //         var arr = ["a", "c", "f", "g", "h", "i", "k",  "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x"];
    //         arr.insert(1, "b");
    //         arr.insert(3, "d");
    //         arr.insert(4, "e");
    //         arr.insert(9, "j");
    //         arr.insert(10, "k");
    //         arr.insert(11, "l");
    //     }

    //     var v2 = function(){
    //         var arr = ["a", "c", "f", "g", "h", "i", "k",  "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x"];
    //         arr.insertMany2(["b", "d", "e", "j", "k", "l"], [1,2,4,9,10,11]);            
    //     }

    //     var v3 = function(){
    //         var arr = ["a", "c", "f", "g", "h", "i", "k",  "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x"];
    //         arr.buildInsertion().add(1, "b").add(3, "d").add(4, "e").add(9, "j").add(10, "k").add(11, "l").run();
    //     }

    //     var normal = TestUtils.measure(insertNormally, loops);
    //     var many = TestUtils.measure(insertMany, loops);
    //     var v2Time = TestUtils.measure(v2, loops);
    //     var v3Time = TestUtils.measure(v3, loops);
    //     Log.warn('normal:$normal vs many:$many  vs v2:${v2Time}  vs v3:${v3Time}');
    //     Assert.isTrue(many < normal);
    // }
}