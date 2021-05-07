## Prior art

Documenting software has many different aspects. In this chapter we first cover literature touching research on 4 broader topics regarding documentation: 

- Automation as a solution for updating & maintainance
- Visual representation of software
- Interaction (graph navigation)
- Prescriptive theory for notation design

Then we discuss some of the most recent research and zoom in on the specific topic of UI storyboards. And finally, in addition to the literature, an overview is given covering features and missing features of 4 related tools that are used in the industry:

- Webkit inspector
- Storybook JS
- InterfaceBuilder Storyboards
- Visual paradigm

### Literature

#### Automated documentation

Creation and maintanance of documentation is a hard and time consuming task. A survey by Forward et al. [^Forward 2002] shows that its "participants agree that documentation tools should seek to better extract knowledge from core resources" like source code.

Various attempts have been made to use this knowledge for documentation purposes. Antoniol et al. [^Antoniol 2002] and Marcus et al. [^Marcus 2003] discuss how to extract knowledge from source code to automatically couple snippets from free text documents with their corresponding source code fragments. 

Another technique is to generate documentation text using AI. Barone et al. [^Barone 2017] scrape Github to collect python functions and their corresponding documentation. This data can then be used to automatically convert code to a summarising text using a neural attention model as is shown by Iyer et al. [^Iyer 2016]

[^Forward 2002]: Forward, Andrew, and Timothy C. Lethbridge. "The relevance of software documentation, tools and technologies: a survey." *Proceedings of the 2002 ACM symposium on Document engineering*. 2002.
[^Antoniol 2002]: Antoniol, Giuliano, et al. "Recovering traceability links between code and documentation." *IEEE transactions on software engineering* 28.10 (2002): 970-983.
[^Marcus 2003]: Marcus, Andrian, and Jonathan I. Maletic. "Recovering documentation-to-source-code traceability links using latent semantic indexing." *25th International Conference on Software Engineering, 2003. Proceedings.*. IEEE, 2003.
[^Barone 2017]: Barone, Antonio Valerio Miceli, and Rico Sennrich. "A parallel corpus of Python functions and documentation strings for automated code documentation and code generation." *arXiv preprint arXiv:1707.02275* (2017).
[^Iyer 2016]: Iyer, Srinivasan, et al. "Summarizing source code using a neural attention model." *Proceedings of the 54th Annual Meeting of the Association for Computational Linguistics (Volume 1: Long Papers)*. 2016.

#### Graphical visualisation

Other than textual documentation, there are lots of other visual techniques researchers have come up with over the last decennia. A survery published by Caserta et al. [^Caserta 2010] in 2010 provides a good overview of graphical documentation techniques, both 2D- and 3D-based, representing the static aspects of the software and its evolution. It covers classical diagrams like those specified in UML as well as more special representations like, city & solary system metaphore representations, Voronoi treemaps etc. The survey categorises them according to their characteristics and features.

![Caserta 2010](../Media/Images/Caserta2010.jpg)

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

Erben et al. [^Erben 2005] discuss graph navigation techniques specially designed to navigate in code bases and propose new interactions for UML diagrams that are hierarchically layered. Similarly, KaitoroBase is tool developed by Su et al. [^Su 2009] that provides assistance in non-linear exploration and visualization of software architecture documents and shows how grouping individual elements reduce cognitive load on the users.

[^Erben 2005]: Erben, Nils, and K. Lohr. "SAB-The Software Architecture Browser." *3rd IEEE International Workshop on Visualizing Software for Understanding and Analysis*. IEEE, 2005.

[^Pienta 2015]: Pienta, Robert, et al. "Scalable graph exploration and visualization: Sensemaking challenges and opportunities." *2015 International conference on Big Data and smart computing (BIGCOMP)*. IEEE, 2015.
[^Su 2009]: Su, Moon Ting, Christian Hirsch, and John Hosking. "Kaitorobase: Visual exploration of software architecture documents." *2009 IEEE/ACM International Conference on Automated Software Engineering*. IEEE, 2009.

#### Prescriptive theory

Hundreds of papers[^Merino 2018] have been written with inventions and suggestions of new ways for visualising software. But "in designing notations, the majority of effort is spent on semantics, with graphical conventions largely an afterthought. Typically, no design rationale, scientific or otherwise, is provided for visual representation choices. While SE has developed mature methods for evaluating and designing semantics, it lacks equivalent methods for visual syntax." [^Moody 2009] 

To counter this, T. Green layed out a foundation with his work on the Cognitive Dimensions of Notations [^Green 1989][^Blackwell 2001]. Later on, Moody et al. refined his findings and used it to construct a more rigid framework toward a "Scientific Basis for Constructing Visual Notations in Software Engineering" [^Moody 2009] in which they "define a set of principles for designing cognitively effective visual notations: ones that are optimized for human communication and problem solving. Together these form a design theory, called the Physics of Notations as it focuses on the physical (perceptual) properties of notations rather than their logical (semantic) properties. The principles were synthesized from theory and empirical evidence from a wide range of fields and rest on an explicit theory of how visual notations communicate." [^Moody 2009] This framework will be used further in this thesis together with the techniques for graph exploration from Pienta et al. [^Pienta 2015] as a foundation to guide the design of our tool to explore component based UI code.

[^Green 1989]: Green, Thomas RG. "Cognitive dimensions of notations." *People and computers V* (1989): 443-460.
[^Blackwell 2001]: Blackwell, Alan F., et al. "Cognitive dimensions of notations: Design tools for cognitive technology." *International Conference on Cognitive Technology*. Springer, Berlin, Heidelberg, 2001.
[^Moody 2009]: Moody, Daniel. "The “physics” of notations: toward a scientific basis for constructing visual notations in software engineering." *IEEE Transactions on software engineering* 35.6 (2009): 756-779.



#### UI Storyboards

The research papers that are probably the most closely related to this work are the ones on Doppio [^Chi 2015], DemoScript [^Chi 2016] and StoryDroid [^Chen 2019]. Doppio is a tool to visualize the flow between GUI screens that happens during user interactions. It's main drawbacks are that it's users need to manually execute every possible user interaction path to create a storyboard visualisation of them. Chi further developed on this idea and also created DemoScript which allows developers to write down textual scripts to define UI interaction flows. But the same drawback is still that in addition to the fully written app, one also need to write these scripts to generate a storyboard.

In that regard Chen et al. [^Chen 2019] proposed some interesting new ways to overcome this barrier and automate the creation of storyboards. They discuss how stochastic GUI testing tools like STOAT [^Su 2017] can automatically create activity transition graphs (ATGs) from which a storyboard can be generated. They go even further and show how their own tool StoryDroid is even better at the creation of ATGs using only static language analys. In addition to the effectiveness of the ATG extraction they also perform user studies to show the usefullness of such storyboards for information retrieval of small applications. For the graphical representation of bigger graphs however, "STORYDROID needs to provide a better strategy to visualize it" [^Chen 2019].

[^Chi 2015]: Chi, Pei-Yu, Sen-Po Hu, and Yang Li. "Doppio: Tracking ui flows and code changes for app development." *Proceedings of the 2018 CHI Conference on Human Factors in Computing Systems*. 2018.
[^Chi 2016]: Chi, Pei-Yu, Yang Li, and Björn Hartmann. "Enhancing cross-device interaction scripting with interactive illustrations." *Proceedings of the 2016 CHI Conference on Human Factors in Computing Systems*. 2016.
[^Su 2017]: Su, Ting, et al. "Guided, stochastic model-based GUI testing of Android apps." Proceedings of the 2017 11th Joint Meeting on Foundations of Software Engineering. 2017.
[^Chen 2019]: Chen, Sen, et al. "Storydroid: Automated generation of storyboard for Android apps." *2019 IEEE/ACM 41st International Conference on Software Engineering (ICSE)*. IEEE, 2019.

### Industry

// TODO UML usage in practice

// TODO Interface Builder storyboards

// TODO Visual paradigm

// TODO Webkit inspector

// TODO: StorybookJS

