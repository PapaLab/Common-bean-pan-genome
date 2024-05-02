# Pangenome modelling
The following scripts help create a model of the pangenome, both for the complete set of genes and for the core set only. 

It takes as input an Excel matrix where for each gene, for each accession, the presence of the gene is encoded by '1'  and the absence by '0'.

It will output two other Excel files:

- output_complete, where we have 1000 rows and 339 columns. Each row corresponds to a different combination of accessions and each column to a different iteration.
- output_core, with the same structure of the previous one, but working only on core genes.

```python
# -*- coding: utf-8 -*-

"""
@author: leovi
"""

import pandas as pd
import numpy as np

df_comp=pd.read_excel(r'Geni_pangenoma_DOM.xlsx', index_col=None)

df_comp_tr=df_comp.T

df_comp_tr.columns = df_comp_tr.iloc[0]
df_comp_tr = df_comp_tr[1:]

df_comp_results = df_comp_tr.apply(lambda row: row[row == 1].index, axis=1)

permutazioni_da_fare = []
count=0
for i in range(1000):
    permutazioni_da_fare.append(np.random.permutation(220))
totalset=set()
somma_dei_geni=[]
for perm in permutazioni_da_fare:
    somma_permutazione=[]
    for index in perm:
        totalset=totalset.union(set(df_comp_results.iloc[index]))
        somma_permutazione.append(len(totalset))
        #print(somma_permutazione)
    somma_dei_geni.append(somma_permutazione)
    totalset=set()
    
        
df_final_comp=pd.DataFrame(somma_dei_geni)

df_final_comp.to_excel("output_complete_DOM.xlsx") 


totalset=set()
somma_dei_geni=[]
for perm in permutazioni_da_fare:
    i=0
    somma_permutazione=[]
    for index in perm:
        if i == 0:
            totalset=set(df_comp_results.iloc[index])
        totalset=totalset.intersection(set(df_comp_results.iloc[index]))
        somma_permutazione.append(len(totalset))
        i=i+1
        #print(somma_permutazione)
    somma_dei_geni.append(somma_permutazione)
    totalset=set(df_comp_results.iloc[perm[0]])
        
df_final_core=pd.DataFrame(somma_dei_geni)

df_final_core.to_excel("output_core_DOM.xlsx")
```

After generating the two excel files, mean values and standard deviation can be computed in Excel for each iteration (column). Then, they can plotted using R.