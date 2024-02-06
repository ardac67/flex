%{
  /* for printing error messages */
  #include <stdbool.h> 
  #include <string.h>
  int errorStart=0;
  bool print_error = false;
  /* if the counter incremented then it means that there is an error */
  char action[1024];
  bool printItOut(){
        if(print_error){
                printf("Error: %s\n",action);
                errorStart=0;
                
                return false;
        }
        return true;
  }
  /*if not matched put it on the action array*/
  /*then increment for the further adding*/
  /*also set print error true for the error message*/
  int incrementCounter(){
        action[errorStart]=yytext[0];
        errorStart++;
        print_error=true;
  }
  /* defining the necessary regex for identifiying the tokens */
  /* keywords */
  /* identifier which should include first character as a char then something numeric or char*/
  /* valueEf which should start with 1-9 and then something numeric and then "b" and then something numeric*/
  /* valueEI which should start with 0-9 and then something numeric*/
  /* valid_olmayan_identififer which should start with 0-9 and then something numeric or char  for identify the not valid statement because cannot be catched in error handling part*/
%}
keywords (and|or|not|equal|less|nil|list|append|concat|set|def|for|if|exit|load|display|true|false)
identifier  [a-zA-Z][a-zA-Z0-9]*
valueEf [0-9]+["b"][1-9]+[0-9]*
valueEI [0-9]+
valid_olmayan_identififer [0-9][a-zA-Z0-9]*
%%
{keywords}     {if(printItOut()){printf("Keyword:%s\n",yytext);}else{return 0;}}
{identifier}   {if(printItOut()){printf("Identifier:%s\n",yytext);}else{return 0;}}
[+] {if(printItOut()){printf("OP_PLUS\n"); }else{return 0;}}
[-] {if(printItOut()){printf("OP_MINUS\n"); }else{return 0;}}
[*] {if(printItOut()){printf("OP_MULT\n"); }else{return 0;}}
[/] {if(printItOut()){printf("OP_DIV\n"); }else{return 0;}}
[(] {if(printItOut()){printf("OP_OP\n"); }else{return 0;}}
[)] {if(printItOut()){printf("OP_OC\n"); }else{return 0;}}
[,] {if(printItOut()){printf("OP_COMMA\n"); }else{return 0;}}
";;"[^\n]* {if(printItOut()){printf("COMMENT");}else{return 0;}}
{valueEf} {if(printItOut()){printf("ValueEF:%s\n",yytext);}else{return 0;}}
{valueEI} {if(printItOut()){printf("ValueEI:%s\n",yytext);}else{return 0;}}
{valid_olmayan_identififer} {if(printItOut()){printf("Error:%s\n",yytext);}else{return 0;}}
[ \n\t]
. {incrementCounter();}
<<EOF>> {return 0;}


%%
int yywrap(){}
int main(int argc , char** argv)
{
    if (argc == 1)
    {
        printf(">");
    }
    else if (argc == 2)
    {
        FILE *fp;
        fp = fopen(argv[1], "r");
        yyin = fp;
    }
    yylex();
    return 0;
}