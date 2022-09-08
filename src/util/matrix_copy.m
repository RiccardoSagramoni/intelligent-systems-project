%{
Questa funzione permette di copiare il contenuto di un vettore 
all'interno di una specifica riga di una matrice, impostando i vari indici
di inizio e di fine rispettivamente delle righe e delle colonne

INPUTS:
    A: Matrice nella quale voglio copiare il vettore 
    B: Vettore che voglio copiare
    start_index_row: indice della specifica riga della matrice dal quale
                     voglio iniziare a copiare il vettore 
    stop_index_row: indice della specifica riga a cui mi devo fermare nella
                    copia
    start_index_column: indice della specifica colonna della matrice dal quale
                        voglio iniziare a copiare il vettore 
    stop_index_columns: indice della specifica colonna a cui mi devo fermare nella
                        copia
OUTPUT:
    A: matrice nella quale ho copiato il vettore ormai modificata
%}
function [A] = matrix_copy(A, B, start_index_row, start_index_column)
    
    [number_row_matrix_to_copy,number_column_matrix_to_copy]=size(B);
    A(start_index_row:start_index_row + number_row_matrix_to_copy - 1,...
        start_index_column:start_index_column + number_column_matrix_to_copy -1) = B;

end
    
    