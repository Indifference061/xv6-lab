#include "kernel/types.h"
#include "kernel/stat.h"
#include "kernel/fcntl.h"
#include "user/user.h"
#include <stdarg.h>

char buf[1024];

int read_stdin(char* buf) {
    /*
    Description: Read stdin into buf
    Example:
        - read_stdin(); // Read the stdin into buf
    Parameters:
        - buf (char*): A buffer to store all characters
    Return:
        - 0 (int)
    */
    // Your code here
    int bytesRead = 0;
    int bufsize = sizeof(buf)-1;
    char c;
    while(bytesRead<bufsize){
    	int n = read(0,&c,1);//从stdin读如一个字符
    	if(n==0){//n=0停止输入
	        break;
    	}
    	if(n<0)//n<0出错
    	{
    	    fprintf(2,"read error\n");
    	    return -1;
    	}
    	buf[bytesRead++]=c;
    }
    buf[bytesRead]='\0';
    // End
    return 0;
}

int log_stdout(uint i) {
    /*
    Description: Redirect stdout to a log file named i.log
    Example:
        - log_stdout(1); // Redirect the stdout to 1.log and return 0
    Parameters:
        - i (uint): A number
    Return:
        - 0 (int)
    */
    char log_name[15] = "0.log";
    // Your code here

    if(i ==0)
    {
    	fprintf(2,"Invalid log file number(0)\n");
    	return -1;
    	
    }
    int n = 0;
    uint temp_i = i;
    do {
        temp_i /= 10;
        n++;
    } while (temp_i > 0);

    int temp_n=n;
    temp_i = i;

    while (n > 0) {
        log_name[--n] = '0' + (temp_i % 10);
        temp_i /= 10;
    }
    strcpy(log_name+temp_n,".log");
  
    //printf("%s",log_name);
    
    close(1);
    int log_fd=open(log_name,O_CREATE | O_WRONLY);
    if(log_fd!=1)
    {
    	fprintf(2,"Error opening log file %s\n",log_name);
    	return -1;
    }
    
    
    // End
    return 0;
}

int main(int argc, char* argv[]) {
    if (argc != 2) {
        fprintf(2, "Usage: log_stdout number\n");
        exit(1);
    }
    if (log_stdout(atoi(argv[1])) != 0) {
        fprintf(2, "log_stdout: log_stdout failed\n");
        exit(1);
    }
    if (read_stdin(buf) != 0) {
        fprintf(2, "log_stdout: read_stdin failed\n");
        exit(1);
    }
    printf(buf);
    
    exit(0);
}
