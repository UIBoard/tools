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

#### Graphical visualisation

Other than textual documentation, there are lots of other visual techniques researchers have come up with over the last decennia. A survery published by [^Caserta 2010] in 2010 provides a good overview of graphical documentation techniques, both 2D- and 3D-based, representing the static aspects of the software and its evolution. It covers classical diagrams like those specified in UML as well as more special representations like, city & solary system metaphore representations, Voronoi treemaps etc. The survey categorises them according to their characteristics and features.

![Caserta2010](../Media/Images/Caserta2010.jpg)

Later on, in 2014, Shahin et al. [^Shahin 2014] did a systematic review of software architecture visualization techniques. They do not only summarize the different techiques found but also identify their purposeses and report the level of evidence their is to support the quality of the used techniques. Two main points they make in their conclusion are that there is a general lack of controlled experiments to evaluate the visualisations and that there is more likelihood to gather and provide higher level of evidence for (semi-)automatic visualisation tools compared with techniques which needs to be applied manually.

In a similar review anno 2018, Merino et al. [^Merino 2018] reconfirm the lack of strong evaluations for software visualisation techniques and call researchers in the field to collect evidence using controlled experiments on real-world open source software systems that promote reproducibility and replicability.

Asenov discusses a novel IDE called Envision in his doctoral thesis [^Asenov 2017]. It enables developers to use domain specific visualisations that are directly and inseparably coupled to their corresponding code and are unified in the same IDE. The work contains multiple user studies which clearly show the benefits of these graphical visualisations for understanding of and interacting with code.

[^Caserta 2010]: Caserta, Pierre, and Olivier Zendra. "Visualization of the static aspects of software: A survey." *IEEE transactions on visualization and computer graphics* 17.7 (2010): 913-933.APA
[^Shahin 2014]: Shahin, Mojtaba, Peng Liang, and Muhammad Ali Babar. "A systematic review of software architecture visualization techniques." *Journal of Systems and Software* 94 (2014): 161-185.
[^Merino 2018]: Merino, Leonel, et al. "A systematic literature review of software visualization evaluation." *Journal of Systems and Software* 144 (2018): 165-180.
[^Asenov 2017]: Asenov, Dimitar. *Envision: reinventing the integrated development environment*. Diss. ETH Zurich, 2017.

#### Graph navigation

When working with larger code bases, documentation (especially graphical representations) can quickly become overcluttered and difficult to understand [^Erben 2005]. Hence, creating static visualisations of code is often not sufficient and thus some kind of interaction is needed.

One can see a software code base as a big graph of interconnected nodes. Efficient navigation in graphs has been covered in various researche papers. Pienta et al. [^Pienta 2015] propose a graph sensemaking hierarchy that categorizes tools and techniques based on how to interact with large graph data and summarize and compare their strengths and weaknesses.

Erben et al. discuss graph navigation techniques specially designed to navigate in code bases. They propose a new interactions for UML diagrams that are hierarchically layered.

[^Erben 2005]: Erben, Nils, and K. Lohr. "SAB-The Software Architecture Browser." *3rd IEEE International Workshop on Visualizing Software for Understanding and Analysis*. IEEE, 2005.

[^Pienta 2015]: Pienta, Robert, et al. "Scalable graph exploration and visualization: Sensemaking challenges and opportunities." *2015 International conference on Big Data and smart computing (BIGCOMP)*. IEEE, 2015.



### Industry

