library(tidyverse)
library(Matrix)
library(future)

# Source variables
source("path.R")


# Assign the number of cores for parallelization
ncpus <- future::availableCores()

# Adjust max memory allowed
options(future.globals.maxSize=40000 * 1024^2,
        mc.cores=ncpus)

# Parallelize the run
plan("multicore", workers=ncpus)

# Read .tab file
tab <- read.table(tabfile, header=T, sep="\t", fill=T) # returns a dataframe

# Expore the imported dataframe
tab[1:5, 1:5]

# Remove no-barcode columns
tab <- tab[, !is.na(colnames(tab))]

# Create a vector storing barcodes
barcodes <- colnames(tab[2:ncol(tab)])

# Create a vector storing all gene names (duplicates included)
all_genes <- tab[,1]

# Create a vector storing unique gene names
unqie_genes <- unique(all_genes)

# Rename the first column to gene
names(tab) <- c("gene", barcodes)

# Explore the cleaned data frame
tab[1:5, 1:5]

# Explore dimensions of the dataframe
dim(tab)

# Collapse read counts in every barcode by gene
new_tab <- tab %>%
    group_by(gene) %>%
    summarize_all(sum)

# Compare dimensions before and after data cleaning
print(paste("Number of rows changed from",
            nrow(tab),
            "to",
            nrow(new_tab)))



# Move the first column assigning gene names to row names
new_tab <- new_tab %>%
    column_to_rownames(var="gene")



# Build a sparse matrix from the dataframe
spars_mtx <- Matrix(as.matrix(new_tab), sparse=T)

# Explore the sparse matrix
str(spars_mtx)

# Create an mtx file storing the sparse matrix
writeMM(obj=spars_mtx, file=file.path(outputdir, 'matrix.mtx'))

# Create a tsv file storing the barcodes
write(x = colnames(spars_mtx), file=file.path(outputdir, "barcodes.tsv"))

# Create a tsv file storing the genes
write(x = rownames(spars_mtx), file=file.path(outputdir, "genes.tsv"))


sessionInfo()



