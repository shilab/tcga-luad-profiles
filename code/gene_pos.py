from __future__ import print_function
import sys

def parse_position(line):
    id, pos = line.strip().split('\t')
    id = id.split('|')[0]
    pos = pos.split(':')
    chr = pos[0].replace('chr','')
    start, end = pos[1].split('-')
    strand = pos[2]
    return id, chr, start, end, strand

if __name__ == '__main__':

    genepos_file= sys.argv[1]

    with open(genepos_file, 'r') as gf:
        for line in gf:
            id, chr, start, end, strand = parse_position(line)
            print(id, chr, start, end, strand, sep='\t')
