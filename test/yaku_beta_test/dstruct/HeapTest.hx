package yaku_beta_test.dstruct;

import yaku_beta.dstruct.Heap;
import zenlog.Log;
import utest.Assert;
import tink.CoreApi;

import yaku_core.CommonSorters;
using yaku_core.NullX;

@:access(yaku_beta.dstruct.Heap)
class HeapTest extends utest.Test {

    // function measurePolyHeap(){

    // }

	function testHeapSanity() {
		Assert.equals(1, 1);
    }

    function testHeapBiggest() {
        var input = [1, 3, 5, 7, 9,   2, 4, 6, 8];
        var heap = new Heap(CommonSorters.intsDescending);
        for (i in input){
            heap.push(i);
            Log.debug(heap.data);
        }
        var output = [];
        for (_ in 0...input.length){
            var p = heap.pop();
            output.push(p.nullThrows());
            Log.debug(heap.data);
        }
        Assert.same([9,8,7,6,5,4,3,2,1], output);
    }

    function testHeapSmallest() {
        //Log.warn('testHeapSmallest...');
        var input = [1, 3, 5, 7, 9,   2, 4, 6, 8];
        var heap = new Heap(CommonSorters.intsAscending);
        for (i in input){
            heap.push(i);
            Log.debug(heap.data);
        }
        var output = [];
        for (_ in 0...input.length){
            var p = heap.pop();
            output.push(p.nullThrows());
            Log.debug(heap.data);
        }
        Assert.same([1,2,3,4,5,6,7,8,9], output);
    }

    function testCapacity() {
        var input = [1,2,3,4,5, 0, 7];
        var heap = new Heap(CommonSorters.intsAscending, 4);
        Log.debug("testCapacity input");
        for (i in input){
            heap.push(i);
            Log.debug(heap.toString());
        }
        var output = [];
        Log.debug("testCapacity output");
        for (_ in 0...input.length){
            var x = heap.pop();
            if (x != null){
                output.push(x);
            }
            Log.debug(heap.toString());
        }
        Assert.same([0, 1, 2, 3], output);
    }

    function testMany() {
        var input = [1,3,5,7,9,11,13,15,17,19,21,23,25,27,29,  2,4,6,8,10,12,14,16,18,20,22,24,26,28,30];
        var heap = new Heap(CommonSorters.intsAscending);
        Log.debug("testMany input");
        for (i in input){
            heap.push(i);
            Log.debug(heap.toString());
        }
        var output = [];
        Log.debug("testMany  output");
        for (_ in 0...input.length){
            var x = heap.pop();
            if (x != null){
                output.push(x);
            }
            Log.debug(heap.toString());
        }
        var expected = input.copy();
        expected.sort(CommonSorters.intsAscending);
        Log.debug('testMany  expected == ${expected}');
        Assert.same(expected, output);
    }

}

