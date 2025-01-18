#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "genhighlight.h"
#include "theme.h"

int ccwrap() { return 1; }
int asmattwrap() { return 1; }

extern char *asmatttext;
extern char *cctext;
extern int asmattlex(void);
extern int cclex(void);

enum language {
    LANG_C,
    LANG_ASM_ATT,
};

char *yytext(enum language l) {
    switch (l)
    {
    case LANG_C:        return cctext;
    case LANG_ASM_ATT:  return asmatttext;
    default:            return 0;
    }
}

const char *print_escape(FILE *file, char *str) {
    while (*str) {
        switch (*str)
        {
        case '<':
            fprintf(file, "&lt;");
            break;
        case '>':
            fprintf(file, "&gt;");
            break;
        default:
            fputc(*str, file);
            break;
        }

        str++;
    }
}

int main(int argc, char **argv) {
    enum token    tok;
    enum language lang = LANG_C;

    if (argc > 1) {
        if (!strcmp(argv[1], "c")) {
            lang = LANG_C;
        } else if (!strcmp(argv[1], "asmatt")) {
            lang = LANG_ASM_ATT;
        }
    }

    int (*yylex)(void);
    switch (lang)
    {
    case LANG_C:        yylex = cclex; break;
    case LANG_ASM_ATT:  yylex = asmattlex; break;
    default:            yylex = 0; break;
    }

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
    
    while((tok = yylex())) {
        if (tok == TOK_WHITE) {
            printf(yytext(lang));
            continue;
        }
        printf("<code class=\"stx%x\">", tok);
        print_escape(stdout, yytext(lang));
        printf("</code>");
    } 

    printf("</code></pre></div>");
}