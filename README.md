Turkish Deasciifier
============

This tool is used to turn Turkish text written in ASCII characters, which do not include some letters of the Turkish alphabet, into correctly written text with the appropriate Turkish characters (such as ı, ş, and so forth). It can also do the opposite, turning Turkish input into ASCII text, for the purpose of processing.

Video Lectures
============

[<img src="https://github.com/StarlangSoftware/TurkishDeasciifier/blob/master/video.jpg" width="50%">](https://youtu.be/b18-k8SKQ6U)

For Developers
============

You can also see [Python](https://github.com/starlangsoftware/TurkishDeasciifier-Py), [Java](https://github.com/starlangsoftware/TurkishDeasciifier), [C++](https://github.com/starlangsoftware/TurkishDeasciifier-CPP), [C](https://github.com/starlangsoftware/TurkishDeasciifier-C), [Swift](https://github.com/starlangsoftware/TurkishDeasciifier-Swift), [Js](https://github.com/starlangsoftware/TurkishDeasciifier-Js), or [C#](https://github.com/starlangsoftware/TurkishDeasciifier-CS) repository.

## Requirements

* [Python 3.7 or higher](#python)
* [Git](#git)

### Python 

To check if you have a compatible version of Python installed, use the following command:

    python -V
    
You can find the latest version of Python [here](https://www.python.org/downloads/).

### Git

Install the [latest version of Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git).

## Pip Install

	pip3 install NlpToolkit-Deasciifier-Cy

## Download Code

In order to work on code, create a fork from GitHub page. 
Use Git for cloning the code to your local or below line for Ubuntu:

	git clone <your-fork-git-link>

A directory called Deasciifier will be created. Or you can use below link for exploring the code:

	git clone https://github.com/starlangsoftware/TurkishDeasciifier-Cy.git

## Open project with Pycharm IDE

Steps for opening the cloned project:

* Start IDE
* Select **File | Open** from main menu
* Choose `TurkishDeasciifier-CY` file
* Select open as project option
* Couple of seconds, dependencies will be downloaded. 

Detailed Description
============

+ [Asciifier](#using-asciifier)
+ [Deasciifier](#using-deasciifier)

## Using Asciifier

Asciifier converts text to a format containing only ASCII letters. This can be instantiated and used as follows:

      asciifier = SimpleAsciifier()
      sentence = Sentence("çocuk")
      asciified = asciifier.asciify(sentence)
      print(asciified)

Output:
    
    cocuk      

## Using Deasciifier

Deasciifier converts text written with only ASCII letters to its correct form using corresponding letters in Turkish alphabet. There are two types of `Deasciifier`:


* `SimpleDeasciifier`

    The instantiation can be done as follows:  
    
        fsm = FsmMorphologicalAnalyzer()
        deasciifier = SimpleDeasciifier(fsm)
     
* `NGramDeasciifier`
    
    * To create an instance of this, both a `FsmMorphologicalAnalyzer` and a `NGram` is required. 
    
    * `FsmMorphologicalAnalyzer` can be instantiated as follows:
        
            fsm = FsmMorphologicalAnalyzer()
    
    * `NGram` can be either trained from scratch or loaded from an existing model.
        
        * Training from scratch:
                
                corpus = Corpus("corpus.txt")
                ngram = NGram(corpus.getAllWordsAsArrayList(), 1)
                ngram.calculateNGramProbabilities(LaplaceSmoothing())
                
        *There are many smoothing methods available. For other smoothing methods, check [here](https://github.com/olcaytaner/NGram).*       
        * Loading from an existing model:
     
                    ngram = NGram("ngram.txt")

	*For further details, please check [here](https://github.com/starlangsoftware/NGram).*        
            
    * Afterwards, `NGramDeasciifier` can be created as below:
        
            deasciifier = NGramDeasciifier(fsm, ngram)
     
A text can be deasciified as follows:
     
    sentence = Sentence("cocuk")
    deasciified = deasciifier.deasciify(sentence)
    print(deasciified)
    
Output:

    çocuk

For Contibutors
============

### Setup.py file
1. Do not forget to set package list. All subfolders should be added to the package list.
```
    packages=['Classification', 'Classification.Model', 'Classification.Model.DecisionTree',
              'Classification.Model.Ensemble', 'Classification.Model.NeuralNetwork',
              'Classification.Model.NonParametric', 'Classification.Model.Parametric',
              'Classification.Filter', 'Classification.DataSet', 'Classification.Instance', 'Classification.Attribute',
              'Classification.Parameter', 'Classification.Experiment',
              'Classification.Performance', 'Classification.InstanceList', 'Classification.DistanceMetric',
              'Classification.StatisticalTest', 'Classification.FeatureSelection'],
```
2. Package name should be lowercase and only may include _ character.
```
    name='nlptoolkit_math',
```
3. Package data should be defined and must ibclude pyx, pxd, c and py files.
```
    package_data={'NGram': ['*.pxd', '*.pyx', '*.c', '*.py']},
```
4. Setup should include ext_modules with compiler directives.
```
    ext_modules=cythonize(["NGram/*.pyx"],
                          compiler_directives={'language_level': "3"}),
```

### Cython files
1. Define the class variables and class methods in the pxd file.
```
cdef class DiscreteDistribution(dict):

    cdef float __sum

    cpdef addItem(self, str item)
    cpdef removeItem(self, str item)
    cpdef addDistribution(self, DiscreteDistribution distribution)
```
2. For default values in class method declarations, use *.
```
    cpdef list constructIdiomLiterals(self, FsmMorphologicalAnalyzer fsm, MorphologicalParse morphologicalParse1,
                               MetamorphicParse metaParse1, MorphologicalParse morphologicalParse2,
                               MetamorphicParse metaParse2, MorphologicalParse morphologicalParse3 = *,
                               MetamorphicParse metaParse3 = *)
```
3. Define the class name as cdef, class methods as cpdef, and \_\_init\_\_ as def.
```
cdef class DiscreteDistribution(dict):

    def __init__(self, **kwargs):
        """
        A constructor of DiscreteDistribution class which calls its super class.
        """
        super().__init__(**kwargs)
        self.__sum = 0.0

    cpdef addItem(self, str item):
```
4. Do not forget to comment each function.
```
    cpdef addItem(self, str item):
        """
        The addItem method takes a String item as an input and if this map contains a mapping for the item it puts the
        item with given value + 1, else it puts item with value of 1.

        PARAMETERS
        ----------
        item : string
            String input.
        """
```
5. Function names should follow caml case.
```
    cpdef addItem(self, str item):
```
6. Local variables should follow snake case.
```
	det = 1.0
	copy_of_matrix = copy.deepcopy(self)
```
7. Variable types should be defined for function parameters, class variables.
```
    cpdef double getValue(self, int rowNo, int colNo):
```
8. Local variables should be defined with types.
```
    cpdef sortDefinitions(self):
        cdef int i, j
        cdef str tmp
```
9. For abstract methods, use ABC package and declare them with @abstractmethod.
```
    @abstractmethod
    def train(self, train_set: list[Tensor]):
        pass
```
10. For private methods, use __ as prefix in their names.
```
    cpdef list __linearRegressionOnCountsOfCounts(self, list countsOfCounts)
```
11. For private class variables, use __ as prefix in their names.
```
cdef class NGram:
    cdef int __N
    cdef double __lambda1, __lambda2
    cdef bint __interpolated
    cdef set __vocabulary
    cdef list __probability_of_unseen
```
12. Write \_\_repr\_\_ class methods as toString methods
13. Write getter and setter class methods.
```
    cpdef int getN(self)
    cpdef setN(self, int N)
```
14. If there are multiple constructors for a class, define them as constructor1, constructor2, ..., then from the original constructor call these methods.
```
cdef class NGram:

    cpdef constructor1(self, int N, list corpus):
    cpdef constructor2(self, str fileName):
    def __init__(self,
                 NorFileName,
                 corpus=None):
        if isinstance(NorFileName, int):
            self.constructor1(NorFileName, corpus)
        else:
            self.constructor2(NorFileName)
```
15. Extend test classes from unittest and use separate unit test methods.
```
class NGramTest(unittest.TestCase):

    def test_GetCountSimple(self):
```
16. For undefined types use object as type in the type declarations.
```
cdef class WordNet:

    cdef object __syn_set_list
    cdef object __literal_list
```
17. For boolean types use bint as type in the type declarations.
```
	cdef bint is_done
```
18. Enumerated types should be used when necessary as enum classes, and should be declared in py files.
```
class AttributeType(Enum):
    """
    Continuous Attribute
    """
    CONTINUOUS = auto()
    """
```
19. Resource files should be taken from pkg_recources package.
```
	fileName = pkg_resources.resource_filename(__name__, 'data/turkish_wordnet.xml')
```
