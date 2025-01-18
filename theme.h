#ifndef THEME_H
#define THEME_H

#include <stdint.h>
#include "genhighlight.h"

struct format {
    uint8_t r, g, b;
    int     bold;
};

struct format theme[] = {
    // code block background color
    [0]              = {33, 33, 33},
    [TOK_PLAIN]      = {255, 255, 255, 0},


    [TOK_STRING]     = {220, 150,  28, 1},
    [TOK_CONST]      = {181, 120, 206, 0},
    [TOK_IDENTIFIER] = { 70,  70, 240, 0},
    [TOK_CALL]       = {254, 254,  91, 1},
    [TOK_SYSTEM]     = {115, 158, 213, 1},
    [TOK_TYPE]       = { 24, 212, 236, 0},
    [TOK_PREPROC]    = {139,  15, 127, 1},
    [TOK_LABEL]      = { 11,  84, 118, 0},
    [TOK_COMMENT]    = { 31, 145,  31, 1},
};

#endif