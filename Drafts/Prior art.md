## Prior art

### Literature

#### Automated documentation

Creation and maintanance of documentation is a hard and time consuming task. A survey by Forward et al. [^Forward 2002] shows that its "participants agree that documentation tools should seek to better extract knowledge from core resources" like source code.

Various attempts have been made to use this knowledge for documentation purposes. Antoniol et al. [^Antoniol 2002] and Marcus et al. [^Marcus 2003] discuss how to extract knowledge from source code to automatically couple snippets from free text documents with their corresponding source code. 

Another technique is to generate documentation text using AI. Barone et al. [^Barone 2017] scrape Github to collect python functions and their corresponding documentation. This data can then be used to automatically convert code to a summarising text using a neural attention model as is shown by Iyer et al. [^Iyer 2016]

[^Forward 2002]: Forward, Andrew, and Timothy C. Lethbridge. "The relevance of software documentation, tools and technologies: a survey." *Proceedings of the 2002 ACM symposium on Document engineering*. 2002.

[^Antoniol 2002]: Antoniol, Giuliano, et al. "Recovering traceability links between code and documentation." *IEEE transactions on software engineering* 28.10 (2002): 970-983.

[^Marcus 2003]: Marcus, Andrian, and Jonathan I. Maletic. "Recovering documentation-to-source-code traceability links using latent semantic indexing." *25th International Conference on Software Engineering, 2003. Proceedings.*. IEEE, 2003.

[^Barone 2017]: Barone, Antonio Valerio Miceli, and Rico Sennrich. "A parallel corpus of Python functions and documentation strings for automated code documentation and code generation." *arXiv preprint arXiv:1707.02275* (2017).

[^Iyer 2016]: Iyer, Srinivasan, et al. "Summarizing source code using a neural attention model." *Proceedings of the 54th Annual Meeting of the Association for Computational Linguistics (Volume 1: Long Papers)*. 2016.

#### Graphical documentation

Other than textual documentation, there are lots of other visual techniques researchers have come up with over the last decennia. A survery published by [^Caserta 2010] in 2010 provides a good overview of graphical documentation techniques, both 2D- and 3D-based, representing the static aspects of the software and its evolution. It covers classical diagrams like those specified in UML as well as more special representations like, city & solary system metaphore representations, Voronoi treemaps etc.

// TODO: add image

Later on, in 2014, Shahin et al. [^Shahin 2014] did a systematic review of software architecture visualization techniques.

[^Caserta 2010]: Caserta, Pierre, and Olivier Zendra. "Visualization of the static aspects of software: A survey." *IEEE transactions on visualization and computer graphics* 17.7 (2010): 913-933.APA
[^Shahin 2014]: Shahin, Mojtaba, Peng Liang, and Muhammad Ali Babar. "A systematic review of software architecture visualization techniques." *Journal of Systems and Software* 94 (2014): 161-185.

### Industry

