//util.h
#ifndef UTIL_H
#define UTIL_H
void    count_bytes( FILE *input, ul *counts );
void 	scale_counts( ul *counts, ui count0[] );
void 	put_counts( BitFileIOs *f,  ui *count0 );
void 	get_counts( BitFileIOs *f, ui count0[] );
void    print_code( HUF_CODE *codes );
long 	file_size( char *name);
void 	print_ratios( char *input, char *output);
void    encode( BitFileIOs *f,  HUF_CODE *codes );
void    decode( BitFileIOs *f, huffTree &ht );
void 	compress( char *argv[] );
void 	uncompress ( char *argv[] );
void 	usage_exit( char *prog_name);
#endif
