%{
Questa funzione prende in ingresso la matrice delle feature e controlla la
correlazione tra le feature della stessa, se una o più feature risultano
correlate con un valore > 0.90 allora se ne mantiene una sola e le
rimanenti vengono scartate

INPUTS:
    FEATURES : Matrice delle features in ingresso

OUTPUT:
    FEATURES_without_correlated_columns: matrice trasformata in uscita senza le
                                         feature correlate tra di loro 
%}

function [FEATURES_without_correlated_columns] = remove_correlated_features(FEATURES)
    correlation_coef = corrcoef(FEATURES);
    [correlated_features, ~] = find( tril( (abs(correlation_coef) > 0.9), -1 ) );
    correlated_features = unique(sort(correlated_features));
    
    FEATURES_without_correlated_columns = FEATURES;
    FEATURES_without_correlated_columns(:, correlated_features) = [];
