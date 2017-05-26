# gdscDataViewR

A Shiny app to view dose reponse curves from a GDSC fitted dataset. The data will have been fitted with the sigmoid dose reponse multilevel model as described in:

Multilevel models improve precision and speed of IC50 estimates
DJ Vis, L Bombardelli, H Lightfoot, F Iorio, MJ Garnett, LFA Wessels
Pharmacogenomics 17 (7), 691-700 [PubMed](https://www.ncbi.nlm.nih.gov/pubmed/27180993)

To load a Shiny dataset the server.R code needs to be amended accordingly:

```
datadir <- "set_the_path_to_your_shiny_gdsc_dataset"
```
