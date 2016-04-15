from __future__ import print_function
import sys

snp_annot = sys.argv[1]
matrixfile = sys.argv[2]

chrom = {}
matrix = {}

with open(snp_annot, 'r') as sa:
    for line in sa:
        affy, rsid, chr, pos, allele_a, allele_b = line.strip().split('\t')
        if chr == '---':
            continue
        if rsid == '---':
            rsid = chr + ':' + pos
        if chr in chrom:
            if rsid in chrom[chr]:
                res = chrom[chr][rsid]
                if chr != res[1] or pos != res[2] or allele_a != res[3] or allele_b != res[4]:
                    continue
            chrom[chr][rsid] = (affy, chr, pos, allele_a, allele_b)

        else:
            chrom[chr] = {rsid:(affy,chr,pos,allele_a,allele_b)}

with open(matrixfile, 'r') as mf:
    for line in mf:
        if line.startswith('Probe_ID'):
            continue
        fields = line.strip().split('\t')
        rsid = fields.pop(0)

        newline = []
        for geno in fields:
            if geno == '0':
                newline.extend(('1','0','0'))
            elif geno == '1':
                newline.extend(('0','1','0'))
            elif geno == '2':
                newline.extend(('0','0','1'))
            elif geno == 'NA':
                newline.extend(('-1','-1','-1'))

        matrix[rsid] = '\t'.join(newline)
    
for chr in range(1,23):
    output_file = 'chr' + str(chr) + '_gens'
    with open(output_file, 'w') as of:
        vals = chrom[str(chr)]
        for val in (sorted(vals, key = lambda x: int(vals[x][2]))):
            affy, chr, pos, allele_a, allele_b = chrom[str(chr)][val]
            print(affy, val, pos, allele_a, allele_b, matrix[rsid], sep='\t', file=of)
