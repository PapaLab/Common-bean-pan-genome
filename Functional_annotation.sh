# Functional annotation.sh

The following scripts take as input different files produced in previous analysis:

- files containing the best hits from the blast analyses between the protein predicted and the proteomes of closed species (best_hit_*closed species*);
- files containing the results of Interproscan analysis (augustus.aa.tsv);
- fasta file containing the predicted protein (final_protein.fa);
- path to the Orthofinder analysis result.

Final results of the analysis will be produced in a txt file, functional_report.txt.

```bash
less final_protein.fa | grep ">"  | sed 's/>//g' >gene_id
less ${path_to_orthofinder}/Orthogroups/Orthogroups.tsv | cut -f 1 | sed '1d' | tac >ortho

while read line; do
less ${path_to_orthofinder}/Orthogroup_Sequences/${line}.fa | grep ">" | sed 's/>//g' | grep -wFf gene_id - >selected_gene
if [ -s selected_gene ];then
        echo $line
                if [ -f descr ];then
                        rm descr
                fi
                if [ -f IPR ];then
                        rm IPR
                fi
                if [ -f GO ];then
                        rm GO
                fi
                if [ -f GO_new ];then
                        rm GO_new
                fi
                if [ -f IPR_new ];then
                        rm IPR_new
                fi
                if [ -f function_f ];then
                        rm function_f
                fi


for i in $(cat selected_gene);do
                        echo $i

                        less best_hit_${species1} | grep -v "hypothetical protein" | grep $i | cut -f 2 | grep -wFf - annotation_info.txt | cut -f 2 >>descr
                        less best_hit_${species2}| grep -v "hypothetical protein" | grep $i | cut -f 16 | cut -d " " -f 8 | cut -d ":" -f 2 >>descr
                        less best_hit_${species3} |grep -v "hypothetical protein" | grep $i | cut -f 16 | cut -d " " -f 2- | cut -d "[" -f 1 >>descr
                        less best_hit_${species4} |grep -v "hypothetical protein" | grep $i | cut -f 16 | cut -d "|" -f 3 | sed 's/^ //g' >>descr


                        less augustus.aa.tsv | grep $i | awk '$6!="Coil"' | awk '$6!="consensus"' | cut -f 6 | sed 's/-//g' |  sed '/^$/d' | sort | uniq -c | tr -s ' ' | sed 's/^ //g' | sort -k1,1nr | head -n 1 | cut -f 2- -d ' ' >>descr

                        less augustus.aa.tsv | grep $i | awk '$6!="Coil"' | awk '$6!="consensus"' | cut -f 12 | sed 's/-//g' |  sed '/^$/d' | sort | uniq -c | tr -s ' ' | sed 's/^ //g' | sort -k1,1nr | head -n 1 | cut -f 2- -d ' ' >>IPR

                        less augustus.aa.tsv | grep $i | awk '$6!="Coil"' | awk '$6!="consensus"' | cut -f 14 | sed 's/-//g' |  sed '/^$/d' | sort | uniq -c | tr -s ' ' | sed 's/^ //g' | sort -k1,1nr | head -n 1 | cut -f 2- -d ' ' >>GO
                done

                if [ -s descr ];then
                        cat descr | sed '/^$/d' | sort | uniq -c | tr -s ' ' | sed 's/^ //g'  | sort -k1,1nr | head -n 1 | cut -f 2- -d ' ' >function_f
                        cat GO | sort | uniq | tr '\n' ',' | sed 's/,$//g' >GO_new
                        cat IPR | sort | uniq | tr '\n' ',' | sed 's/,$//g'>IPR_new
                else
                        echo "No function" >function_f
                fi
                for i in $(cat selected_gene);do
                                echo $i>id
                                if [ -s IPR_new ];then
                                        if [ -s GO_new ];then
                                                paste id function_f IPR_new GO_new>>functional_report.txt
                                        else
                                                paste id function_f IPR_new>>functional_report.txt
                                        fi
                                else
                                        paste id function_f>>functional_report.txt
                                fi
                done
fi

```

