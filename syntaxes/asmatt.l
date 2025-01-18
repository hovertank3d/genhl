letter          [A-Za-z]
digit           [0-9]
symbol_special  [_.$]
eol             "\n"[\r]?

whitespace      [\t\s]*

c_comment     "/*".*("*/"|<EOF>)
v850_comment  "--".*{eol}
hash_comment  "#".*{eol}

comment {c_comment}|{v850_comment}|{hash_comment}

symbol_start {letter}|{symbol_special}
symbol_cont  {letter}|{symbol_special}|{digit}

number_binary   "0"[bB][01]*
number_octal    "0"[0-7]*
number_dec      [1-9][0-9]*
number_hex_suf  [0-9a-fA-F]+"h"
number_hex      "0"[xX][0-9a-fA-F]*

symbol          {symbol_start}{symbol_cont}*
character       "'"([^\\']|"\\".)"'"
string          "\""([^\\"]|"\\".)*"\""
number          ({number_hex_suf}|{number_hex}|{number_dec}|{number_octal}|{number_binary})
directive       "."{symbol}
label           {symbol}":"
register        "%"{symbol}

%s instr_start
%s dir

%{
#include "genhighlight.h"
%}

%%


<dir>"@"?{symbol}       {                       return TOK_CONST;       }
{directive}             { BEGIN(dir);           return TOK_PREPROC;     }
"$"?{number}            {                       return TOK_CONST;       }
"$"{symbol}             {                       return TOK_CONST;       }
{character}|{string}    {                       return TOK_STRING;      }
{label}                 { BEGIN(instr_start);   return TOK_LABEL;       }
<instr_start>{symbol}   { BEGIN(INITIAL);       return TOK_CALL;        }
{register}              {                       return TOK_SYSTEM;      }
{symbol}                {                       return TOK_IDENTIFIER;  }
{eol}|";"               { BEGIN(instr_start);   return TOK_PLAIN;       }
{comment}               { BEGIN(instr_start);   return TOK_COMMENT;     }
.                       {                       return TOK_PLAIN;       }
<<EOF>>                 {                       return TOK_EOF;         }
