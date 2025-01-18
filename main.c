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

enum language
{
    LANG_C,
    LANG_ASM_ATT,
};

char *yytext(enum language l)
{
    switch (l) {
    case LANG_C:
        return cctext;
    case LANG_ASM_ATT:
        return asmatttext;
    default:
        return 0;
    }
}

const char *print_escape(FILE *file, char *str)
{
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

int main(int argc, char **argv)
{
    enum token tok;
    enum language lang = LANG_C;

    if (argc > 1) {
        if (!strcmp(argv[1], "c")) {
            lang = LANG_C;
        }
        else if (!strcmp(argv[1], "asmatt")) {
            lang = LANG_ASM_ATT;
        }
    }

    int (*yylex)(void);
    switch (lang) {
    case LANG_C:
        yylex = cclex;
        break;
    case LANG_ASM_ATT:
        yylex = asmattlex;
        break;
    default:
        yylex = 0;
        break;
    }

    {
        printf("<style>");
        printf(".stx_root{");
        printf("color: rgb(%d,%d,%d);", theme[TOK_PLAIN].r, theme[TOK_PLAIN].g, theme[TOK_PLAIN].b);
        printf("background-color: rgb(%d,%d,%d);", theme[0].r, theme[0].g, theme[0].b);
        if (theme[TOK_PLAIN].bold) {
            printf("font-weight: bold;");
        }
        printf("}");

        for (int i = 2; i < TOKS_END; i++) {
            printf(".stx%x{", i);
            printf("color: rgb(%d,%d,%d);", theme[i].r, theme[i].g, theme[i].b);
            if (theme[i].bold) {
                printf("font-weight: bold;");
            }
            printf("}");
        }
        printf("</style>");
    }
    printf("<div class=\"stx_root\"><pre><code>");
    while ((tok = yylex())) {
        if (tok == TOK_WHITE) {
            printf(yytext(lang));
            continue;
        }
        if (tok == TOK_PLAIN) {
            print_escape(stdout, yytext(lang));
            continue;
        }

        printf("<span class=\"stx%x\">", tok);
        print_escape(stdout, yytext(lang));
        printf("</span>");
    }

    printf("</code></pre></div>");
}