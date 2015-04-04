/*******************************************

RAW file endian inverter
Author : Kaiwen Chen

Output is little endian RAW file,
it is readable by windows based Matlab

Mac/Linux based Matlab does not need this file.

*******************************************/

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

int Read_dem(char * filename, char * out_name)
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
	outfile = fopen(out_name, "rb+"); //
	fread(dem, sizeof(float), cols*rows, fp);
	//if your computer is a big endian machine you need to flip the byte order
	for(i = 0; i < cols*rows; ++i)
	{
		 rev_float(&dem[i]);
	}
	fwrite(dem, sizeof(float), cols*rows, outfile);
	fclose(fp);
	fclose(outfile);
    free(dem);
	return 0;
}

int main()
{
	char *filename1 = "terrainS0C0R10_100_500by500_dem.raw";
	Read_dem(filename1, "output1.raw");
	char *filename2 = "terrainS4C0R10_100_500by500_dem.raw";
	Read_dem(filename2, "output2.raw");
	char *filename3 = "terrainS4C4R10_100-500by500_dem.raw";
	Read_dem(filename3, "output3.raw");
	char *filename4 = "terrainS4C4R20_100-500by500_dem.raw";
	Read_dem(filename4, "output4.raw");
	return 0;
}
