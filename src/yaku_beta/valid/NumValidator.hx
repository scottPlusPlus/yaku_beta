package yaku_beta.valid;

using yaku_core.NullX;

class NumValidator {
    
    public static inline function minValue<T:Float,Int,UInt>(validator:Validator<T>, v:Float, ?errMsgOverride:String):Validator<T> {
        if (validator.value < v){
            var msg = errMsgOverride.orFallback('${validator.name} cannot be less than ${v}');
            validator.rule([msg]);
        }
        return validator;
    }

    public static inline function maxValue<T:Float,Int,UInt>(validator:Validator<T>, v:Float, ?errMsgOverride:String):Validator<T> {
        if (validator.value > v){
            var msg = errMsgOverride.orFallback('${validator.name} cannot be more than ${v}');
            validator.rule([msg]);
        }
        return validator;
    }

}