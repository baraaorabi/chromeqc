# Summarize sequencing library quality of 10x Genomics Chromium linked reads

all: data/SHA256

.DELETE_ON_ERROR:
.SECONDARY:
.PHONY: all

# Download the human reference genome.
data/grch38.fa.gz:
	mkdir -p $(@D)
	curl -o $@ ftp://ftp.ensembl.org/pub/release-90/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz

# Download the HG002 linked reads data.
data/hg002/%.fastq.gz:
	mkdir -p $(@D)
	curl -o $@ ftp://ftp-trace.ncbi.nlm.nih.gov/giab/ftp/data/AshkenazimTrio/HG002_NA24385_son/10Xgenomics_ChromiumGenome/NA24385.fastqs/$(@F)

# Download the HG003 linked reads data.
data/hg003/%.fastq.gz:
	mkdir -p $(@D)
	curl -o $@ ftp://ftp-trace.ncbi.nlm.nih.gov/giab/ftp/data/AshkenazimTrio/HG003_NA24149_father/10Xgenomics_ChromiumGenome/NA24149.fastqs/$(@F)

# Download the HG004 linked reads data.
data/hg004/%.fastq.gz:
	mkdir -p $(@D)
	curl -o $@ ftp://ftp-trace.ncbi.nlm.nih.gov/giab/ftp/data/AshkenazimTrio/HG004_NA24143_mother/10Xgenomics_ChromiumGenome/NA24143.fastqs/$(@F)

# Symlink the HG002 data.
data/hg002g1.fq.gz: data/hg002/read-RA_si-GCACAATG_lane-001-chunk-0002.fastq.gz
	ln -s hg002/$(<F) $@

# Symlink the HG003 data.
data/hg003g1.fq.gz: data/hg003/read-RA_si-GCTACTGA_lane-001-chunk-0002.fastq.gz
	ln -s hg003/$(<F) $@

# Symlink the HG004 data.
data/hg004g1.fq.gz: data/hg004/read-RA_si-GAGTTAGT_lane-001-chunk-0002.fastq.gz
	ln -s hg004/$(<F) $@

# Compute the SHA-256 of the data and verify it.
data/SHA256: \
		data/grch38.fa.gz \
		data/hg002g1.fq.gz \
		data/hg003g1.fq.gz \
		data/hg004g1.fq.gz
	gsha256sum -c SHA256
	gsha256sum $^ >$@