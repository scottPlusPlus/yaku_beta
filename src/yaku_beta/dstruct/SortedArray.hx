package yaku_beta.dstruct;

import zenlog.Log;
import haxe.iterators.ArrayKeyValueIterator;
import haxe.iterators.ArrayIterator;

using yaku_core.NullX;

/*
* An Array that is sorted.  Inserts done using binary search
*/
class SortedArray<T> {
	public final array:Array<T>;
	final compare:(T, T) -> Int;

    public var length(get,never):Int;
    public function get_length():Int {
        return array.length;
    }


	public function new(array:Array<T>, compare:(T, T) -> Int, dataIsPreSorted:Bool) {
		this.array = array;
		this.compare = compare;
		if (!dataIsPreSorted){
			array.sort(compare);
		} else {
			#if debug
				//debug validation to ensure the array is sorted
				if (array.length > 1){
					for (index in 1...array.length){
						var order = compare(array[index-1], array[index]);
						if (order > 0){
							Log.error("Array data is not pre-sorted");
							break;
						}
					}
				}
			#end
		}
	}

	public function contains(val:T):Bool {
		return indexOf(val) > -1;
	}

	public function copy():SortedArray<T> {
		return new SortedArray(array, compare, true);
	}

	public function filter(f:T->Bool):Array<T> {
		return array.filter(f);
	}

	public function indexOf(val:T, ?fromIndex:Null<Int>):Int {
		if (array.length == 0){
			return -1;
		}
		var index = binarySearch(array, val, fromIndex.orFallback(0), array.length-1);
		if (array[index] != val){
			return -1;
		}
		while (array[index] == val){
			index--;
		}
		return index+1;
	}

    public function insert(val:T) {
		if (array.length == 0){
			array.push(val);
			return;
		}
		var index = binarySearch(array, val, 0, array.length - 1);
		var c = compare(val, array[index]);
		if (c > 0){
			index++;
		}
		array.insert(index, val);
	}

	public function iterator():ArrayIterator<T> {
		return array.iterator();
	}

	public function join(sep:String):String {
		return array.join(sep);
	}

	public function keyValueIterator():ArrayKeyValueIterator<T> {
		return array.keyValueIterator();
	}

    public function lastIndexOf(val:T, ?fromIndex:Int):Int {
		if (array.length == 0){
			return -1;
		}
		var index = binarySearch(array, val, fromIndex.orFallback(0), array.length-1);
		if (array[index] != val){
			return -1;
		}
		while (array[index] == val){
			index++;
		}
		return index-1;
    }

    public function map<S>(f:T -> S):Array<S> {
        return array.map(f);
    }

    public function pop():Null<T> {
        return array.pop();
    }

    public function remove(x:T):Bool  {
        //TODO - can make faster
        return array.remove(x);
    }

    public function shift():Null<T>{
        return array.shift();
    }

    public function slice(pos:Int, ?end:Int):Array<T> {
        return array.slice(pos, end);
    }

    public function toString():String {
        return array.toString();
    }

	private function binarySearch(arr:Array<T>, val:T, start:Int, end:Int):Int {
		Log.debug('binary search from $start to $end');
		if (start == end) {
			return start;
		}
		var mid = Std.int(start + (end - start) / 2);
		var midVal = array[mid];
		Log.debug('mid at $mid = $midVal');
		var c = compare(val, midVal);
		Log.debug('$val is $c than $midVal');
		if (c < 0) {
			return binarySearch(arr, val, start, mid);
		} else if (c > 0) {
			return binarySearch(arr, val, mid+1, end);
		} else {
			return mid;
		}
	}
}