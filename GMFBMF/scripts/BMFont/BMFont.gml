function BMFont() constructor {
    name = "";
    face = "";
    size = 0;
    bold = false;
    italic = false;
    padding = new Inset(0, 0, 0, 0);
    base = 0;
    
    chars = [];             /// @is {BMFontChar[]}
    kernings = [];          /// @is {BMFontKerning[]}
    
    static _parsingLine = "";
    static _parsingSeekPos = 1;
    
    static load = function(filename/*:string*/)/*->bool*/ {
        var file = file_text_open_read(filename);
        
        if (file == -1) return false;
        
        name = string_replace(filename_name(filename), ".fnt", "");
        
        _parsingLine = file_text_read_string(file);
        _parsingSeekPos = 1;
        
        if (string_copy(_parsingLine, 1, 4) == "info") {
            face = _parseValue("face=\"", "\"");
            size = abs(real(_parseValue("size=", " ")));
            bold = bool(real(_parseValue("bold=", " ")));
            italic = bool(real(_parseValue("italic=", " ")));
            
            padding.top = real(_parseValue("padding=", ","));
            padding.right = real(_parseValue(",", ","));
            padding.bottom = real(_parseValue(",", ","));
            padding.left = real(_parseValue(",", " "));
        } else {
            throw InvalidBMFontFileException;
        }
        
        file_text_readln(file);
        _parsingLine = file_text_read_string(file);
        _parsingSeekPos = 1;
        
        if (string_copy(_parsingLine, 1, 6) == "common") {
            base = real(_parseValue("base=", " "));
        } else {
            throw InvalidBMFontFileException;
        }
        
        file_text_readln(file);
        
        while(!file_text_eof(file)) {
            _parsingLine = file_text_read_string(file);
            
            if (string_copy(_parsingLine, 1, 5) == "chars") {
                file_text_readln(file);
                _parsingLine = file_text_read_string(file);
                _parsingSeekPos = 1;
                
                while (string_copy(_parsingLine, 1, 4) == "char") {
                    var id_ = real(_parseValue("id=", " "));
                    var x_ = real(_parseValue("x=", " "));
                    var y_ = real(_parseValue("y=", " "));
                    var width = real(_parseValue("width=", " "));
                    var height = real(_parseValue("height=", " "));
                    var xoffset = real(_parseValue("xoffset=", " "));
                    var yoffset = real(_parseValue("yoffset=", " "));
                    var xadvance = real(_parseValue("xadvance=", " "));
                    
                    array_push(chars, new BMFontChar(id_, x_, y_, width, height, xoffset, yoffset, xadvance));
                    
                    file_text_readln(file);
                    _parsingLine = file_text_read_string(file);
                    _parsingSeekPos = 1;
                }
            }
            
            if (string_copy(_parsingLine, 1, 8) == "kernings") {
                file_text_readln(file);
                _parsingLine = file_text_read_string(file);
                _parsingSeekPos = 1;
                
                while (string_copy(_parsingLine, 1, 7) == "kerning") {
                    var first = real(_parseValue("first=", " "));
                    var second = real(_parseValue("second=", " "));
                    var amount = real(_parseValue("amount=", " "));
                    
                    array_push(kernings, new BMFontKerning(first, second, amount));
                    
                    file_text_readln(file);
                    _parsingLine = file_text_read_string(file);
                    _parsingSeekPos = 1;
                }
            }
            
            file_text_readln(file);
        }
        
        file_text_close(file);
        _parsingLine = "";
        
        return true;
        
        // show_debug_message(json_stringify(self));
    }
    
    static _parseValue = function(opening/*:string*/, closing/*:string*/)/*->string*/ {
        _parsingSeekPos = string_pos_ext(opening, _parsingLine, _parsingSeekPos) + string_length(opening);
        var result = string_copy(_parsingLine, _parsingSeekPos, string_pos_ext(closing, _parsingLine, _parsingSeekPos) - _parsingSeekPos);
        _parsingSeekPos += string_length(result) - 1;
        
        return result;
    }
}

/// @param {number} id
/// @param {number} x
/// @param {number} y
/// @param {number} width
/// @param {number} height
/// @param {number} xoffset
/// @param {number} yoffset
/// @param {number} xadvance
function BMFontChar(_id, _x, _y, _width, _height, _xoffset, _yoffset, _xadvance) constructor {
    id = _id;                   /// @is {number}
    x = _x;                     /// @is {number}
    y = _y;                     /// @is {number}
    width = _width;             /// @is {number}
    height = _height;           /// @is {number}
    xoffset = _xoffset;         /// @is {number}
    yoffset = _yoffset;         /// @is {number}
    xadvance = _xadvance;       /// @is {number}
}

/// @param {number} first
/// @param {number} second
/// @param {number} amount
function BMFontKerning(_first, _second, _amount) constructor {
    first = _first;             /// @is {number}
    second = _second;           /// @is {number}
    amount = _amount;           /// @is {number}
}

#macro InvalidBMFontFileException "Invalid fnt file!"