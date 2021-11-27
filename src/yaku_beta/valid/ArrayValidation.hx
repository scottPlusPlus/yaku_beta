package yaku_beta.valid;

using yaku_core.NullX;

class ArrayValidation {
    
    public static inline function minLength<T>(validation:Validation<Array<T>>, v:UInt, ?errMsgOverride:String):Validation<Array<T>> {
        if (validation.value.length < v){
            var msg = errMsgOverride.orFallback('${validation.name} must have at least ${v} items');
            validation.addRule([msg]);
        }
        return validation;
    }

    public static inline function maxLength<T>(validation:Validation<Array<T>>, v:UInt, ?errMsgOverride:String):Validation<Array<T>> {
        if (validation.value.length > v){
            var msg = errMsgOverride.orFallback('${validation.name} must not have more than ${v} items');
            validation.addRule([msg]);
        }
        return validation;
    }
}