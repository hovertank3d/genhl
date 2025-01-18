#include <stdio.h>

#include "genhighlight.h"
#include "theme.h"

int yywrap() {
    return 1;
}

int main() {
    enum token tok;

    printf("<style>");
    for (int i = 0; i < TOKS_END; i++) {
        const char *color_prefix = i > 0 ? "" : "background-";
        printf(".stx%x{", i);
        printf("%scolor: rgb(%d,%d,%d);", color_prefix, theme[i].r, theme[i].g, theme[i].b);
        if (theme[i].bold) {
            printf("font-weight: bold;");
        }
        printf("}");
    }
    printf("</style>");

    printf("<div class=\"stx0\"><pre><code>");
    extern char *yytext;
    while((tok = yylex()) ) {
        printf("<code class=\"stx%x\">%s</code>", tok, yytext);
    } 
    printf("</code></pre></div>");
}