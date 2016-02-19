/*
  $ gcc -dynamiclib -o libstar.dylib star.c
*/

static const char map[] = 
    "HI" /* A */
    "DG" /* B */
    "JA" /* C */
    "FI" /* D */
    "BC" /* E */
    "HA" /* F */
    "DE" /* G */
    "JC" /* H */
    "FG" /* I */
    "BE" /* J */
    ;

char star(char p, char c) {
    return map[(p - 'A') * 2 + (c % 2)];
}
