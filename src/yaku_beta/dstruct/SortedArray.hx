package yaku_beta.dstruct;

import zenlog.Log;
import haxe.iterators.ArrayKeyValueIterator;
import haxe.iterators.ArrayIterator;

using yaku_core.NullX;

/*
* An Array that is sorted.  Inserts done using binary search
*/
class SortedArray<T> {
	final arr:Array<T>;
	final compare:(T, T) -> Int;

    public var length(get,never):Int;
    public function get_length():Int {
        return arr.length;
    }


	public function new(arr:Array<T>, compare:(T, T) -> Int, dataIsPreSorted:Bool) {
		this.arr = arr;
		this.compare = compare;
		if (!dataIsPreSorted){
			arr.sort(compare);
		} else {
			#if debug
				//debug validation to ensure the array is sorted
				if (arr.length > 1){
					for (index in 1...arr.length){
						var order = compare(arr[index-1], arr[index]);
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
		return new SortedArray(arr, compare, true);
	}

	public function copyArray():Array<T> {
		return arr.copy();
	}

	public function filter(f:T->Bool):Array<T> {
		return arr.filter(f);
	}

	public function indexOf(val:T, ?fromIndex:Null<Int>):Int {
		if (arr.length == 0){
			return -1;
		}
		var index = binarySearch(arr, val, fromIndex.orFallback(0), arr.length-1);
		if (arr[index] != val){
			return -1;
		}
		while (arr[index] == val){
			index--;
		}
		return index+1;
	}

    public function insert(val:T) {
		Log.debug('insert $val into ${arr}');
		if (arr.length == 0){
			arr.push(val);
			return;
		}
		var index = binarySearch(arr, val, 0, arr.length - 1);
		var c = compare(val, arr[index]);
		if (c > 0){
			index++;
		}
		arr.insert(index, val);
	}

	public function iterator():ArrayIterator<T> {
		return arr.iterator();
	}

	public function join(sep:String):String {
		return arr.join(sep);
	}

	public function keyValueIterator():ArrayKeyValueIterator<T> {
		return arr.keyValueIterator();
	}

    public function lastIndexOf(val:T, ?fromIndex:Int):Int {
		if (arr.length == 0){
			return -1;
		}
		var index = binarySearch(arr, val, fromIndex.orFallback(0), arr.length-1);
		if (arr[index] != val){
			return -1;
		}
		while (arr[index] == val){
			index++;
		}
		return index-1;
    }

    public function map<S>(f:T -> S):Array<S> {
        return arr.map(f);
    }

    public function pop():Null<T> {
        return arr.pop();
    }

    public function remove(x:T):Bool  {
        //TODO - can make faster
        return arr.remove(x);
    }

    public function shift():Null<T>{
        return arr.shift();
    }

    public function slice(pos:Int, ?end:Int):Array<T> {
        return arr.slice(pos, end);
    }

    public function toString():String {
        return arr.toString();
    }

	private function binarySearch(arr:Array<T>, val:T, start:Int, end:Int):Int {
		Log.debug('binary search from $start to $end');
		if (start == end) {
			return start;
		}
		var mid = Std.int(start + (end - start) / 2);
		var midVal = arr[mid];
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