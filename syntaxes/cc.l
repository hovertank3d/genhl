letter          [A-Za-z]
digit           [0-9]
symbol_special  [_.$]
eol             "\n""\r"?

whitespace      [\t\s]*

c_comment     "/*".*"*/"
cpp_comment  "//".*{eol}
comment       {c_comment}|{cpp_comment}

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
incstring       "<"([^\\"]|"\\".)*">"
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

{comment}               {                       return TOK_COMMENT; }

"alignas"               {                       return TOK_LABEL;       }
"alignof"               {                       return TOK_LABEL;       }
"auto"                  {                       return TOK_SYSTEM;       }
"bool"                  {                       return TOK_SYSTEM;       }
"break"                 {                       return TOK_PREPROC;     }
"case"                  {                       return TOK_PREPROC;     }
"char"                  {                       return TOK_SYSTEM;       }
"constexpr"             {                       return TOK_SYSTEM; }
"continue"              {                       return TOK_PREPROC; }
"default"               {                       return TOK_PREPROC; }
"do"                    {                       return TOK_PREPROC; }
"double"                {                       return TOK_SYSTEM; }
"else"                  {                       return TOK_PREPROC; }
"enum"                  {                       return TOK_SYSTEM; }
"extern"                {                       return TOK_LABEL; }
"false"                 {                       return TOK_CONST; }
"float"                 {                       return TOK_SYSTEM; }
"for"                   {                       return TOK_PREPROC; }
"goto"                  {                       return TOK_PREPROC; }
"if"                    {                       return TOK_PREPROC; }
"inline"                {                       return TOK_LABEL; }
"int"                   {                       return TOK_SYSTEM; }
"long"                  {                       return TOK_SYSTEM; }
"nullptr"               {                       return TOK_SYSTEM; }
"register"              {                       return TOK_SYSTEM; }
"restrict"              {                       return TOK_SYSTEM; }
"return"                {                       return TOK_PREPROC; }
"short"                 {                       return TOK_SYSTEM; }
"signed"                {                       return TOK_SYSTEM; }
"sizeof"                {                       return TOK_LABEL; }
"static"                {                       return TOK_LABEL; }
"static_assert"         {                       return TOK_LABEL; }
"struct"                {                       return TOK_LABEL; }
"switch"                {                       return TOK_PREPROC; }
"thread_local"          {                       return TOK_LABEL; }
"true"                  {                       return TOK_CONST; }
"typedef"               {                       return TOK_LABEL; }
"typeof"                {                       return TOK_LABEL; }
"typeof_unqual"         {                       return TOK_LABEL; }
"union"                 {                       return TOK_LABEL; }
"unsigned"              {                       return TOK_SYSTEM; }
"void"                  {                       return TOK_SYSTEM; }
"volatile"              {                       return TOK_LABEL; }
"while"                 {                       return TOK_PREPROC; }
"_Alignas"              {                       return TOK_LABEL; }
"_Alignof"              {                       return TOK_LABEL; }
"_Atomic"               {                       return TOK_SYSTEM; }
"_BitInt"               {                       return TOK_SYSTEM; }
"_Bool"                 {                       return TOK_SYSTEM; }
"_Complex"              {                       return TOK_SYSTEM; }
"_Decimal128"           {                       return TOK_SYSTEM; }
"_Decimal32"            {                       return TOK_SYSTEM; }
"_Decimal64"            {                       return TOK_SYSTEM; }
"_Generic"              {                       return TOK_LABEL; }
"_Imaginary"            {                       return TOK_LABEL; }
"_Noreturn"             {                       return TOK_LABEL; }
"_Static_assert"        {                       return TOK_LABEL; }
"_Thread_local"         {                       return TOK_LABEL; }

"#"{symbol}+            {                       return TOK_PREPROC; }

{symbol}{whitespace}/"("             {          return TOK_CALL;}

{symbol}"_t"            {                       return TOK_SYSTEM; }

{string}|{character}    {                       return TOK_STRING;}
{incstring}             {                       return TOK_STRING;}
{symbol}                {                       return TOK_IDENTIFIER;}

"$"?{number}            {                       return TOK_CONST;       }

.                       {                       return TOK_PLAIN;       }
<<EOF>>                 {                       return TOK_EOF;         }
