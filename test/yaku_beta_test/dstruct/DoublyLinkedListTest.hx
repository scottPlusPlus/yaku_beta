package yaku_beta_test.dstruct;

import utest.Assert;
import yaku_beta.dstruct.DoublyLinkedList;

using yaku_core.NullX;
using yaku_core.IteratorX;

class DoublyLinkedListTest extends utest.Test {

    function testInsertAfter() {
        var list = new DoublyLinkedList();
        addAll(list, [1,2,3]);
        var n = list.nodeOf(2).nullThrows();
        list.insertAfter(n, 7);

        var actual = list.iterator().collect();
        var expected = [1,2,7,3];
        Assert.same(expected, actual);
    }

    function testInsertBefore() {
        var list = new DoublyLinkedList();
        addAll(list, [1,2,3]);
        var n = list.nodeOf(2).nullThrows();
        list.insertBefore(n, 7);

        var actual = list.iterator().collect();
        var expected = [1,7, 2, 3];
        Assert.same(expected, actual);     
    }

    function testRemove() {
        var list = new DoublyLinkedList();
        addAll(list, [1,2,3]);

        list.remove(2);
        var actual = list.iterator().collect();
        Assert.same( [1,3], actual); 

        list.remove(1);
        actual = list.iterator().collect();
        Assert.same( [3], actual); 

        list.remove(3);
        actual = list.iterator().collect();
        Assert.same([], actual);

        list.remove(3);
        actual = list.iterator().collect();
        Assert.same([], actual);
    }

    function addAll<T>(list:DoublyLinkedList<T>, vals:Array<T>){
        for(val in vals){
            list.add(val);
        }
    }

}