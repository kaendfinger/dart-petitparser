part of json;

/**
 * JSON parser.
 */
class JsonParser extends GrammarParser {
  JsonParser() : super(new JsonParserDefinition());
}

/**
 * JSON parser definition.
 */
class JsonParserDefinition extends JsonGrammarDefinition {

  array() => super.array().map((each) => each[1] != null ? each[1] : new List());
  object() => super.object().map((each) {
    var result = new LinkedHashMap();
    if (each[1] != null) {
      for (var element in each[1]) {
        result[element[0]] = element[2];
      }
    }
    return result;
  });

  trueToken() => super.trueToken().map((each) => true);
  falseToken() => super.falseToken().map((each) => false);
  nullToken() => super.nullToken().map((each) => null);
  stringToken() => ref(stringPrimitive).trim();
  numberToken() => super.numberToken().map((each) {
    var floating = double.parse(each);
    var integral = floating.toInt();
    if (floating == integral && each.indexOf('.') == -1) {
      return integral;
    } else {
      return floating;
    }
  });

  stringPrimitive() => super.stringPrimitive().map((each) => each[1].join());
  characterEscape() => super.characterEscape().map((each) => JSON_ESCAPE_CHARS[each[1]]);
  characterOctal() => super.characterOctal().map((each) {
    throw new UnsupportedError('Octal characters not supported yet');
  });

}
