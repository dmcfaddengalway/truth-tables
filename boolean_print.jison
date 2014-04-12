
/* description: Parses end executes mathematical expressions. */

%{
var exp_list = new Array();
%}

/* lexical grammar */
%lex
%%

\s+                   /* skip whitespace */
[a-eg-su-z]           return 'VAR'
[TF]                  return 'BOOL'
"="                   return 'EQ'
"->"                  return 'RIMP'
"<-"                  return 'LIMP'
"|"                   return 'OR'
"X"                   return 'XOR'
"&"                   return 'AND'
"!"                   return 'NOT'
"("                   return 'LPAREN'
")"                   return 'RPAREN'
<<EOF>>               return 'EOF'
.                     return 'INVALID'

/lex

/* operator associations and precedence */

%left LPAREN RPAREN
%left NOT
%left AND
%left OR XOR
%left LIMP RIMP
%left EQ
%left BOOL
%left VAR

%start expressions

%% /* language grammar */

expressions
    : eq EOF
        { console.log(exp_list); return $1; }
    ;

eq
    : imp EQ eq
        {$$ = $1 + " = " + $3; exp_list.push($$);}
    | imp
        {$$ = $1;}
    ;

imp
    : imp RIMP imp
        {$$ = $1 + " -> " + $3; exp_list.push($$);}
    | imp LIMP imp
        {$$ = $1 + " <- " + $3; exp_list.push($$);}
    | or
        {$$ = $1;}
    ;

or
    : or OR or
        {$$ = $1 + (" | ") + $3; exp_list.push($$);}
    | or XOR or
        {$$ = $1 + (" X ") + $3; exp_list.push($$);}
    | and
        {$$ = $1;}
    ;

and
    : not AND and
        {$$ = $1 + (" & ") + $3; exp_list.push($$);}
    | not
        {$$ = $1;}
    ;

not
    : NOT primary
        {$$ = "!" + $2; exp_list.push($$);}
    | primary
        {$$ = $1;}
    ;

primary
    : LPAREN eq RPAREN
        {$$ = "(" + $2 + ")";}
    | BOOL
        {$$ = yytext;}
    | VAR
        {$$ = yytext;}
    ;

