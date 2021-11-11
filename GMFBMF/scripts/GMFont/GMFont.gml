function GMFont(fnt/*:Fnt*/) constructor {
    hinting = 0;
    glyphOperations = 0;
    interpreter = 0;
    pointRounding = 0;
    fontName = fnt.face;
    styleName = fnt.bold ? "Bold" : (fnt.italic ? "Italic" : "Regular");
    size = fnt.size;
    bold = fnt.bold;
    italic = fnt.italic;
    charset = 1;
    AntiAlias = 1;
    first = 0;
    last = 0;
    sampleText = "abcdef ABCDEF\n0123456789 .,<>\"'&!?\nthe quick brown fox jumps over the lazy dog\nTHE QUICK BROWN FOX JUMPS OVER THE LAZY DOG\nDefault character: ▯ (9647)";
    includeTTF = bool(false);
    TTFName = "";
    textureGroupId = {
        name: "Default",
        path: "texturegroups/Default"
    }
    ascenderOffset = 2;
    
    glyphs = {};
    ranges = [];
    var range = { lower : 0, upper : 0 };
    
    for (var i = 0, i_size = array_length(fnt.chars); i < i_size; i++) {
        var char = fnt.chars[i];
        glyphs[$ string(char.id)] = {
            x : char.x,
            y : char.y,
            w : char.width,
            h : char.height + 1,
            character : char.id,
            shift : char.xadvance + 4,
            offset : 0
        };
        
        if (char.id != range.upper) {
            if (i != 0) {
                range.upper -= 1;
                array_push(ranges, range);
            }
            
            range = { lower : char.id, upper : 0 };
        }
        
        range.upper = char.id + 1;
    }
    
    kerningPairs = [];
    
    for (var i = 0, i_size = array_length(fnt.kernings); i < i_size; i++) {
        var kerning = fnt.kernings[i];
        array_push(kerningPairs, { first : kerning.first, second : kerning.second, amount : kerning.amount });
    }
    
    regenerateBitmap =  bool(false);
    canGenerateBitmap = bool(true);
    maintainGms1Font = bool(false);
    parent =  {
        name : "Fonts",
        path : "folders/Fonts.yy",
    };
    resourceVersion = "1.0";
    name = fnt.name;
    tags = [];
    resourceType = "GMFont";
    
    // show_debug_message(json_stringify(self));
}