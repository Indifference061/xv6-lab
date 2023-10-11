#include"kernel/types.h"
#include"kernel/stat.h"
#include"user/user.h"

#define MAXARG 32
#define BUF_SIZE 1024

int main( int argc , char* argv[] )
{
    if (argc < 2) {
	fprintf(2, "Usage: %s command [args...]\n", argv[0]);
        exit(1);
    }
    char buf[BUF_SIZE],*p,c;
    if(strlen(argv[0])+1>BUF_SIZE)
    {
    	fprintf(2,"arg[%s] too long\n",argv[0]);
    	exit(1);
    }

    p = buf;
    
    //char *command = argv[1];
    char *args[MAXARG];
    for(int i=1;i<argc;i++)
    {
    	args[i-1]=argv[i];
    }
    args[argc-1] = 0;

    while(read(0,&c,1)>0)
    {   
        if( c != '\n' )
        {
            *p = c;
            p++;
            continue;
        }
        *p = '\0';
        if(p!=buf&&argc==MAXARG)
        {
            printf("Too many args!\n ");
        }
        if( p != buf )
        {
            args[ argc-1 ] = buf;
	        args[argc]=0;
        }
            
        if( fork() == 0 ) 
        {	
            exec(args[0] , args );
            exit(0);
        }
        else 
        {
            wait(0);
        }

        p = buf;
        args[argc-1] = 0;
    }

    exit( 0 ); 
}
