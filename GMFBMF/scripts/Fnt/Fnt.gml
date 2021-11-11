function Fnt() constructor {
    name = "";
    face = "";
    size = 0;
    bold = false;
    italic = false;
    padding = new Inset(0, 0, 0, 0);
    
    chars = [];             /// @is {FntChar[]}
    kernings = [];          /// @is {FntKerning[]}
    
    _parsingLine = "";
    _parsingIndex = 1;
    
    load = function(filename/*:string*/) {
        var file = file_text_open_read(filename);
        
        name = string_replace(filename_name(filename), ".fnt", "");
        
        _parsingLine = file_text_read_string(file);
        
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
            throw InvalidFntFileException;
        }
        
        file_text_readln(file);
        
        while(!file_text_eof(file)) {
            _parsingLine = file_text_read_string(file);
            
            if (string_copy(_parsingLine, 1, 5) == "chars") {
                file_text_readln(file);
                _parsingLine = file_text_read_string(file);
                _parsingIndex = 1;
                
                while (string_copy(_parsingLine, 1, 4) == "char") {
                    var id_ = real(_parseValue("id=", " "));
                    var x_ = real(_parseValue("x=", " "));
                    var y_ = real(_parseValue("y=", " "));
                    var width = real(_parseValue("width=", " "));
                    var height = real(_parseValue("height=", " "));
                    var xadvance = real(_parseValue("xadvance=", " "));
                    
                    array_push(chars, new FntChar(id_, x_, y_, width, height, xadvance));
                    
                    file_text_readln(file);
                    _parsingLine = file_text_read_string(file);
                    _parsingIndex = 1;
                }
            }
            
            if (string_copy(_parsingLine, 1, 8) == "kernings") {
                file_text_readln(file);
                _parsingLine = file_text_read_string(file);
                _parsingIndex = 1;
                
                while (string_copy(_parsingLine, 1, 7) == "kerning") {
                    var first = real(_parseValue("first=", " "));
                    var second = real(_parseValue("second=", " "));
                    var amount = real(_parseValue("amount=", " "));
                    
                    array_push(kernings, new FntKerning(first, second, amount));
                    
                    file_text_readln(file);
                    _parsingLine = file_text_read_string(file);
                    _parsingIndex = 1;
                }
            }
            
            file_text_readln(file);
        }
        
        file_text_close(file);
        _parsingLine = "";
        
        // show_debug_message(json_stringify(self));
    }
    
    _parseValue = function(opening/*:string*/, closing/*:string*/)/*->string*/ {
        _parsingIndex = string_pos_ext(opening, _parsingLine, _parsingIndex) + string_length(opening);
        
        var result = string_copy(_parsingLine, _parsingIndex, string_pos_ext(closing, _parsingLine, _parsingIndex) - _parsingIndex);
        
        _parsingIndex += string_length(result) - 1;
        
        return result;
    }
}

/// @param {number} id
/// @param {number} x
/// @param {number} y
/// @param {number} width
/// @param {number} height
/// @param {number} xadvance
function FntChar(_id, _x, _y, _width, _height, _xadvance) constructor {
    id = _id;                   /// @is {number}
    x = _x;                     /// @is {number}
    y = _y;                     /// @is {number}
    width = _width;             /// @is {number}
    height = _height;           /// @is {number}
    xadvance = _xadvance;       /// @is {number}
}

/// @param {number} first
/// @param {number} second
/// @param {number} amount
function FntKerning(_first, _second, _amount) constructor {
    first = _first;             /// @is {number}
    second = _second;           /// @is {number}
    amount = _amount;           /// @is {number}
}

#macro InvalidFntFileException "Invalid fnt file!"