package yaku_beta.valid;

using yaku_core.NullX;

class NumValidation {
    
    public static inline function minValue<T:Float,Int,UInt>(validation:Validation<T>, v:Float, ?errMsgOverride:String):Validation<T> {
        if (validation.value < v){
            var msg = errMsgOverride.orFallback('${validation.name} cannot be less than ${v}');
            validation.addRule([msg]);
        }
        return validation;
    }

    public static inline function maxValue<T:Float,Int,UInt>(validation:Validation<T>, v:Float, ?errMsgOverride:String):Validation<T> {
        if (validation.value > v){
            var msg = errMsgOverride.orFallback('${validation.name} cannot be more than ${v}');
            validation.addRule([msg]);
        }
        return validation;
    }

}