package yaku_beta;

import zenlog.Log;
import tink.CoreApi.Lazy;
import yaku_core.CommonSorters;

using yaku_core.NullX;

class ArrayX {

    public static function insertMany<T>(arr:Array<T>, inserts:Array<Insertion<T>>){
        inserts.sort(sortInsertions);
        var source = arr.copy();
        arr.resize(arr.length + inserts.length);
        //Log.debug('arr length now ${arr.length}');

        var sourceIndex = 0;
        var insertIndex = 0;
        var nextInsert = inserts[insertIndex].p;
        for (writeIndex in 0...arr.length){
            //Log.debug('write: $writeIndex, source:${sourceIndex}, insert:${insertIndex}');
            if (writeIndex == nextInsert){
                arr[writeIndex] = inserts[insertIndex].d;
                insertIndex++;
                if (insertIndex < inserts.length){
                    nextInsert = inserts[insertIndex].p;
                } else {
                    nextInsert = -1;
                }
                
            } else {
                arr[writeIndex] = source[sourceIndex];
                sourceIndex++;
            }
        }
    }

    public static function insertMany2<T>(arr:Array<T>, inserts:Array<T>, positions:Array<UInt>){
        // inserts.sort(sortInsertions);
        var source = arr.copy();
        arr.resize(arr.length + inserts.length);
        //Log.debug('arr length now ${arr.length}');

        var sourceIndex = 0;
        var insertIndex = 0;
        var nextInsert = positions[insertIndex];
        for (writeIndex in 0...arr.length){
            //Log.debug('write: $writeIndex, source:${sourceIndex}, insert:${insertIndex}');
            if (writeIndex == nextInsert){
                arr[writeIndex] = inserts[insertIndex];
                insertIndex++;
                if (insertIndex < inserts.length){
                    nextInsert = positions[insertIndex];
                } else {
                    nextInsert = -1;
                }
                
            } else {
                arr[writeIndex] = source[sourceIndex];
                sourceIndex++;
            }
        }
    }

    public static function insertManyBuilder<T>(arr:Array<T>):Array<Insertion<T>>{
        return new Array<Insertion<T>>();
    }

    public static function ins<T>(arr:Array<Insertion<T>>, pos:UInt, data:T): Array<Insertion<T>> {
        arr.push({p:pos, d:data});
        return arr;
    }

    public static function buildInsertion<T>(arr:Array<T>):Insertions<T> {
        return new Insertions<T>(arr);
    }

    private static function sortInsertions<T>(a:Insertion<T>, b:Insertion<T>){
        return CommonSorters.intsAscending(a.p, b.p);
    }
}


class Insertions<T> {
    public var data:Array<T> = [];
    public var pos:Array<UInt> = [];
    public final arr:Array<T>;
    public function new(arr:Array<T>){
        this.arr = arr;
    };

    public inline function add(pos:UInt, data:T):Insertions<T>{
        this.data.push(data);
        this.pos.push(pos);
        return this;
    }

    public function run(){
        ArrayX.insertMany2(arr, data, pos);
    }
}

typedef Insertion<T> = {
    p:UInt,
    d:T
}