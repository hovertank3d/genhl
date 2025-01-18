#ifndef GENHIGHLIGHT_H
#define GENHIGHLIGHT_H

enum token {
    TOK_EOF,
    
    TOK_PLAIN,
    TOK_STRING,
    TOK_CONST,
    TOK_IDENTIFIER,
    TOK_CALL,
    TOK_SYSTEM,
    TOK_TYPE,
    TOK_PREPROC,
    TOK_LABEL,
    TOK_COMMENT,
    TOK_WHITE,

    TOKS_END,
};

int yylex();

#endif // GENHIGHLIGHT_H
