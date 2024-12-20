# indel_spectrum

Scripts and input data to generate indel spectrum and homopolymer summary

- indel_spectrum.R script used to generate indelSpectrum_plot.pdf from input file (indel_spectrum.csv).

- Homopolymer counts for each reference genome summarized as follows:

`perl homopolymer_counter.pl refs_cp28673mod.fas > homopolymer_list.txt`

- homopolymer_plot.R script used to generate homopolymer_plot.pdf from input file (homopolymer_plot_input.csv).