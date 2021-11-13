package yaku_beta.valid;

import yaku_beta.valid.*;

using yaku_core.NullX;

class StringValidator extends Validator<String> {

    private var _fieldName:String = "Field";

    public function new(fieldName:String){
        super();
        _fieldName = fieldName;
    }

    public function minChar(v:UInt, ?errMsgOverride:String):StringValidator {
        var f = function(str:String):ValidationOutcome {
            if (str.length < v){
                var errMsg = errMsgOverride.orFallback('${_fieldName} must be at least ${v} chars.');
                return Fail([errMsg]);
            }
            return Pass;
        }
        rules.push(f);
        return this;
    }

    public function maxChar(v:UInt, ?errMsgOverride:String):StringValidator {
        var f = function(str:String):ValidationOutcome {
            if (str.length > v){
                var errMsg = errMsgOverride.orFallback('${_fieldName} must be less than ${v} chars.');
                return Fail([errMsg]);
            }
            return Pass;
        }
        rules.push(f);
        return this;
    }

    public function regex(regex:EReg, errMsg:String):StringValidator {
        var f = function(str:String):ValidationOutcome {
            if (!regex.match(str)){
                return Fail([errMsg]);
            }
            return Pass;
        }
        rules.push(f);
        return this;
    }

    public function trim(?errMsgOverride:String):StringValidator {
        var f = function(str:String):ValidationOutcome {
            if (StringTools.trim(str) != str){
                var errMsg = errMsgOverride.orFallback('${_fieldName} must not have any extra spaces.');
                return Fail([errMsg]);
            }
            return Pass;
        }
        rules.push(f);
        return this;
    }

    public function contains(needle:String, ?errMsgOverride:String):StringValidator {
        var f = function(str:String):ValidationOutcome {
            if (!StringTools.contains(str, needle)){
                var errMsg = errMsgOverride.orFallback('${_fieldName} must contain ${needle}.');
                return Fail([errMsg]);
            }
            return Pass;
        }
        rules.push(f);
        return this;
    }

    public function nonNull(?errMsgOverride:String):StringValidator {
        var f = function(str:String):ValidationOutcome {
            if (str == null){
                var errMsg = errMsgOverride.orFallback('${_fieldName} cannot be null.');
                return Fail([errMsg]);
            }
            return Pass;
        }
        rules.push(f);
        return this;
    }
}