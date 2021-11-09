package yaku_beta.dstruct;

import zenlog.Log;

class Heap<T> {

    public var length(default,null):UInt;

    private var data:Array<Null<T>> = [];
    private var nextResize:Int = 8;

    private final compare:T->T->Int;
    private final capacity:Null<UInt>;

    public function new(compare:T->T->Int, capacity:Null<UInt> = null){
        this.compare = compare;
        this.length = 0;
        var initSize = 8;
        data = [];
        data.resize(initSize);
        this.capacity = capacity;
    }

    //could do it if capacity is multiple of 2...

    //Example:
    //0
    //1         2
    //3   4     5     6
    //7 8 9 10  11 12 13 14
    

    public function peek(): Null<T> {
        if (length == 0){
            return null;
        }
        return data[0];
    }



    //returns and removes topmost
    public function pop() : Null<T> {
        //Log.debug('poll');
        if (length == 0){
            return null;
        }
        //Log.debug('- length == $length');
        var val = data[0];
        data[0] = null;
        // Log.debug('pre-sink:');
        // Log.debug(data);
        sink(0);
        length--;
        return val;
    }

    public function push(x:T){
        Log.debug('insert $x');
        if (data.length == length){
            for (i in 0...nextResize){
                data.push(null);
            }
            nextResize *= 2;
        }
        //Log.debug('length $length and x $x');
        data[length] = x;
        // Log.debug('data[0] == ${data[0]}');
        // Log.debug('before swim:');
        // Log.debug(toString());

        swim(length);
        length++;
        // if (capacity != null){
        //     if (length > capacity){
        //         pop();
        //     }
        // }
        // Log.debug('before capacity thing:');
        // Log.debug(toString());
        // if (capacity != null){
        //     data[capacity] = null;
        //     if (length > capacity){
        //         length = capacity;
        //     }
        // }
        //Log.debug(toString());
    }

    public function toString():String {
        var str = "[";
        for (i in data){
            str += Std.string(i) + ", ";
        }
        str += "]";
        return str;
    }

    private function swim(pos:Int){
        //Log.debug('- swim for $pos');
        while (true){
            if (pos == 0){
                return;
            }
            var parentPos = parentIndex(pos);
            var val = data[pos];
            var parentVal = data[parentPos];
            //Log.debug('- - val $val vs parent $parentVal ?');
            if (compare(val, parentVal) < 0){
                swap(pos, parentPos);
                pos = parentPos;
            } else {
                return;
            }
        }
    }

    private function sink(pos:Int){
        //Log.debug('- sink for $pos (${data[pos]})');
        while (true){
            //Log.debug('- - sink for $pos (${data[pos]})');
            var leftPos = leftChildIndex(pos);
            if (leftPos > data.length){
               // Log.debug('- - end sink cause leftPos == $leftPos');
                return;
            }
            var rightPos = rightChildIndex(pos);
            var valLeft = data[leftPos];
            var valRight = data[rightPos];
            //Log.debug('- - sinking with left/right == ${valLeft} / ${valRight}');
            var smaller = valLeft;
            var smallerPos = leftPos;
            if (valLeft == null || (valRight != null && compare(valRight, valLeft)<0)){
                smaller = valRight;
                smallerPos = rightPos;
            }
            if (smaller == null){
                //Log.debug('- - end sink with smaller is null');
                return;
            }
            var val = data[pos];
            if (val == null || compare(smaller, val)<0 ){
                swap(pos, smallerPos);
                pos = smallerPos;
            } else {
                //Log.debug('- - end sink with $val vs $smaller');
                return;
            }
        }
    }

    private inline function swap(posX:Int, posY:Int) {
        var valX = data[posX];
        var valY = data[posY];

        data[posX] = valY;
        data[posY] = valX;
    }

    private inline function parentIndex(pos:Int):Int {
        if (pos == 0){
            return null;
        }
        return Math.floor((pos -1)/2);
    }

    private inline function leftChildIndex(pos:Int):Int {
        return pos*2+1;
    }
    private inline function rightChildIndex(pos:Int):Int {
        return pos*2+2;
    }


}