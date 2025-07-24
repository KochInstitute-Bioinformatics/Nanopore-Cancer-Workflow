process PREPARE_GENOME {
    tag "$genome"
    label 'process_medium'
    
    conda "bioconda::wget=1.21.3"
    
    publishDir "${params.outdir}/genome", mode: 'copy'
    
    input:
    val genome
    val genome_url
    
    output:
    path "fasta/*.fa*", emit: fasta
    path "gtf/*.gtf*", emit: gtf, optional: true
    path "gff/*.gff*", emit: gff, optional: true
    path "versions.yml", emit: versions
    
    when:
    task.ext.when == null || task.ext.when
    
    script:
    def args = task.ext.args ?: ''
    """
    # Download and extract the reference genome
    wget -O genome_reference.tar.gz "${genome_url}"
    tar -xzf genome_reference.tar.gz
    
    # Create organized directory structure
    mkdir -p fasta gtf gff
    
    # Find and move FASTA files
    find . -name "*.fa" -o -name "*.fasta" -o -name "*.fa.gz" -o -name "*.fasta.gz" | head -1 | xargs -I {} mv {} fasta/
    
    # Find and move GTF files
    find . -name "*.gtf" -o -name "*.gtf.gz" | head -1 | xargs -I {} mv {} gtf/ || echo "No GTF file found"
    
    # Find and move GFF files  
    find . -name "*.gff" -o -name "*.gff3" -o -name "*.gff.gz" -o -name "*.gff3.gz" | head -1 | xargs -I {} mv {} gff/ || echo "No GFF file found"
    
    # Clean up
    rm -f genome_reference.tar.gz
    rm -rf refdata-gex-*
    
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        wget: \$(wget --version | head -n1 | sed 's/GNU Wget //; s/ built.*\$//')
    END_VERSIONS
    """
    
    stub:
    """
    mkdir -p fasta gtf gff
    touch fasta/genome.fa
    touch gtf/genes.gtf
    touch gff/genes.gff
    touch versions.yml
    """
}