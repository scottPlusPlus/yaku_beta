package yaku_beta.valid;

using yaku_core.NullX;

class ArrayValidator {
    
    public static inline function minLength<T>(validator:Validator<Array<T>>, v:UInt, ?errMsgOverride:String):Validator<Array<T>> {
        if (validator.value.length < v){
            var msg = errMsgOverride.orFallback('${validator.name} must have at least ${v} items');
            validator.rule([msg]);
        }
        return validator;
    }

    public static inline function maxLength<T>(validator:Validator<Array<T>>, v:UInt, ?errMsgOverride:String):Validator<Array<T>> {
        if (validator.value.length > v){
            var msg = errMsgOverride.orFallback('${validator.name} must not have more than ${v} items');
            validator.rule([msg]);
        }
        return validator;
    }
}