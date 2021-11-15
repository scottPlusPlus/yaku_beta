package yaku_beta.valid;

using yaku_core.NullX;

@:access(yaku_beta.valid.ValueValidator)
class StringValidator {
    
    public static function minLength(validator:ValueValidator<String>, v:UInt, ?errMsgOverride:String):ValueValidator<String> {
        if (validator.isNull){
            return validator;
        }
        if (validator.value.length < v){
            var msg = errMsgOverride.orFallback('${validator.name} must be less than ${v} chars.');
            validator.errors.push(msg);
        }
        return validator;
    }

    public static function maxLength(validator:ValueValidator<String>, v:UInt, ?errMsgOverride:String):ValueValidator<String> {
        if (validator.isNull){
            return validator;
        }
        if (validator.value.length > v){
            var msg = errMsgOverride.orFallback('${validator.name} must be at least ${v} chars.');
            validator.errors.push(msg);
        }
        return validator;
    }

    public static function contains(validator:ValueValidator<String>, needle:String, ?errMsgOverride:String):ValueValidator<String> {
        if (validator.isNull){
            return validator;
        }
        if (!StringTools.contains(validator.value, needle)) {
            var msg = errMsgOverride.orFallback('${validator.name} must contain ${needle}');
            validator.errors.push(msg);
        }
        return validator;
    }

}