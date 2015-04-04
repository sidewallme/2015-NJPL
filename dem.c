#include <stdio.h>
#include <stdlib.h>

static void rev_float(float *longone)
{
   struct long_bytes {
            char byte1;
            char byte2;
            char byte3;
            char byte4;
                      } *longptr;
   unsigned char temp;
 
   longptr = (struct long_bytes *) longone;
   temp = longptr->byte1;
   longptr->byte1 = longptr->byte4;
   longptr->byte4 = temp;
   temp = longptr->byte2;
   longptr->byte2 = longptr->byte3;
   longptr->byte3 = temp;
}

int Read_dem(char *filename)
{
	float *dem;
	int cols, rows;
	int i;
	FILE *fp;
	FILE *outfile;
	cols = 500;
	rows = 500;
	dem = (float *)malloc(sizeof(float)*cols*rows);
	fp = fopen(filename, "rb");
	outfile = fopen("output.raw", "rb+");
	fread(dem, sizeof(float), cols*rows, fp);
	//if your computer is a big endian machine you need to flig the byte order
	for(i = 0; i < cols*rows; ++i)
	{
		 rev_float(&dem[i]);
	}
	fwrite(dem, sizeof(float), cols*rows, outfile);
	fclose(fp);
	fclose(outfile);
	return 0;
}

int main()
{
	char *filename = "in.raw";
	Read_dem(filename);
	return 0;
}