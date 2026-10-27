#!/usr/bin/env python3

import argparse
import gzip
import sys


def open_vcf(filename):
    if filename.endswith(".gz"):
        return gzip.open(filename, "rt")
    return open(filename, "r")


parser = argparse.ArgumentParser(
    description="Convert a biallelic diploid VCF to SNAPPER/SNAPP NEXUS"
)

parser.add_argument("-i", "--input", required=True,
                    help="Input VCF/VCF.gz")

parser.add_argument("-o", "--output", required=True,
                    help="Output NEXUS")

args = parser.parse_args()


samples = []
data = []
nsites = 0


with open_vcf(args.input) as f:

    for line in f:

        if line.startswith("##"):
            continue

        if line.startswith("#CHROM"):
            header = line.rstrip().split("\t")
            samples = header[9:]
            data = [[] for _ in samples]
            continue

        fields = line.rstrip().split("\t")

        # Check biallelic
        if "," in fields[4]:
            raise RuntimeError(
                f"Multiallelic site found: {fields[0]}:{fields[1]}"
            )

        for i, genotype in enumerate(fields[9:]):

            gt = genotype.split(":")[0]
            gt = gt.replace("|", "/")

            if gt == "0/0":
                data[i].append("0")

            elif gt in ("0/1", "1/0"):
                data[i].append("1")

            elif gt == "1/1":
                data[i].append("2")

            else:
                raise RuntimeError(
                    f"Bad genotype {gt} at {fields[0]}:{fields[1]}"
                )

        nsites += 1


with open(args.output, "w") as out:

    out.write("#NEXUS\n\n")

    out.write("BEGIN DATA;\n")
    out.write(
        f"    DIMENSIONS NTAX={len(samples)} NCHAR={nsites};\n"
    )
    out.write(
        '    FORMAT DATATYPE=SNP SYMBOLS="012" '
        'MISSING=? GAP=-;\n'
    )

    out.write("    MATRIX\n")

    width = max(len(x) for x in samples) + 5

    for name, seq in zip(samples, data):
        out.write(
            "    " + name.ljust(width)
            + "".join(seq)
            + "\n"
        )

    out.write("    ;\n")
    out.write("END;\n")


print("Done")
print(f"Individuals: {len(samples)}")
print(f"SNPs: {nsites}")
print(f"Output: {args.output}")
