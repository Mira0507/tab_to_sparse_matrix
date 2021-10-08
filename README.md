## Data format conversion from .tab to seurat inpute sparse matrix for single cell RNA-seq analysis

### 1. Package managemant by conda
- `requirements.txt`: packages installed
- `env.yaml`: conda recipe

### 2. R script
- `Mat_to_R.R`: R script convering data format
- `path.R`: R config storing input and output directory paths

### 3. Getting output files
- Run the script

```r
# Activated conda env required 
# Assign correct directory paths in path.R

Rscript Mat_to_R.R
```

- Output
    - `matrix.mtx`
    - `barcodes.tsv`
    - `genes.tsv`
