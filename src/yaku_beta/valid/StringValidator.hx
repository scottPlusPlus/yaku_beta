package yaku_beta.valid;

using yaku_core.NullX;

class StringValidator {
    
    public static inline function minLength(validator:Validator<String>, v:UInt, ?errMsgOverride:String):Validator<String> {
        if (validator.value.length < v){
            var msg = errMsgOverride.orFallback('${validator.name} must be less than ${v} chars.');
            validator.rule([msg]);
        }
        return validator;
    }

    public static inline function maxLength(validator:Validator<String>, v:UInt, ?errMsgOverride:String):Validator<String> {
        if (validator.value.length > v){
            var msg = errMsgOverride.orFallback('${validator.name} must be at least ${v} chars.');
            validator.rule([msg]);
        }
        return validator;
    }

    public static inline function contains(validator:Validator<String>, needle:String, ?errMsgOverride:String):Validator<String> {
        if (!StringTools.contains(validator.value, needle)) {
            var msg = errMsgOverride.orFallback('${validator.name} must contain ${needle}');
            validator.rule([msg]);
        }
        return validator;
    }

    public static inline function regex(validator:Validator<String>, regex:EReg, errMsg:String):Validator<String> {
        if (!regex.match(validator.value)) {
            validator.rule([errMsg]);
        }
        return validator;
    }

}