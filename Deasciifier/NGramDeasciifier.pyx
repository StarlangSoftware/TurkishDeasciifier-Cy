from Corpus.Sentence cimport Sentence
from Dictionary.Word cimport Word
from MorphologicalAnalysis.FsmMorphologicalAnalyzer cimport FsmMorphologicalAnalyzer
from MorphologicalAnalysis.FsmParseList cimport FsmParseList
from NGram.NGram cimport NGram

import pkg_resources
from Deasciifier.SimpleDeasciifier cimport SimpleDeasciifier


cdef class NGramDeasciifier(SimpleDeasciifier):

    cdef NGram __n_gram
    cdef bint __root_n_gram
    cdef float __threshold
    cdef dict __asciified_same

    def __init__(self,
                 fsm: FsmMorphologicalAnalyzer,
                 nGram: NGram,
                 rootNGram: bool):
        """
        A constructor of NGramDeasciifier class which takes an FsmMorphologicalAnalyzer and an NGram
        as inputs. It first calls it super class SimpleDeasciifier with given FsmMorphologicalAnalyzer input
        then initializes nGram variable with given NGram input.

        PARAMETERS
        ----------
        fsm : FsmMorphologicalAnalyzer
            FsmMorphologicalAnalyzer type input.
        nGram : NGram
            NGram type input.
        """
        super().__init__(fsm)
        self.__n_gram = nGram
        self.__root_n_gram = rootNGram
        self.__threshold = 0.0
        self.__asciified_same = {}
        self.loadAsciifiedSameList()

    cpdef Word checkAnalysisAndSetRoot(self,
                                       Sentence sentence,
                                       int index):
        """
        Checks the morphological analysis of the given word in the given index. If there is no misspelling, it returns
        the longest root word of the possible analyses.
        @param sentence Sentence to be analyzed.
        @param index Index of the word
        @return If the word is misspelled, null; otherwise the longest root word of the possible analyses.
        """
        cdef FsmParseList fsm_parses
        if index < sentence.wordCount():
            fsm_parses = self.fsm.morphologicalAnalysis(sentence.getWord(index).getName())
            if fsm_parses.size() != 0:
                if self.__root_n_gram:
                    return fsm_parses.getParseWithLongestRootWord().getWord()
                else:
                    return sentence.getWord(index)
        return None

    cpdef setThreshold(self, float threshold):
        """
        Sets minimum N-Gram probability threshold for replacement candidates.
        :param threshold: New N-Gram probability threshold
        """
        self.__threshold = threshold

    cpdef Sentence deasciify(self, Sentence sentence):
        """
        The deasciify method takes a Sentence as an input. First it creates a String list as candidates,
        and a Sentence result. Then, loops i times where i ranges from 0 to words size of given sentence. It gets the
        current word and generates a candidateList with this current word then, it loops through the candidateList.
        First it calls morphologicalAnalysis method with current candidate and gets the first item as root word. If it
        is the first root, it gets its N-gram probability, if there are also other roots, it gets probability of these
        roots and finds out the best candidate, best root and the best probability. At the nd, it adds the bestCandidate
        to the bestCandidate list.

        PARAMETERS
        ----------
        sentence : Sentence
            Sentence type input.

        RETURNS
        -------
        Sentence
            Sentence result as output.
        """
        cdef str best_candidate, candidate
        cdef Sentence result
        cdef int i, repeat
        cdef Word previous_root, word, best_root, root, next_root
        cdef FsmParseList fsm_parses
        cdef list candidates
        cdef double best_probability, previous_probability, next_probability
        cdef bint is_asciified_same
        previous_root = None
        result = Sentence()
        root = self.checkAnalysisAndSetRoot(sentence, 0)
        next_root = self.checkAnalysisAndSetRoot(sentence, 1)
        for i in range(sentence.wordCount()):
            candidates = []
            is_asciified_same = False
            word = sentence.getWord(i)
            if word.getName() in self.__asciified_same:
                candidates.append(word.getName())
                candidates.append(self.__asciified_same[word.getName()])
                is_asciified_same = True
            if root is None or is_asciified_same:
                if not is_asciified_same:
                    candidates = self.candidateList(word)
                best_candidate = word.getName()
                best_root = word
                best_probability = self.__threshold
                for candidate in candidates:
                    fsm_parses = self.fsm.morphologicalAnalysis(candidate)
                    if self.__root_n_gram and not is_asciified_same:
                        root = fsm_parses.getParseWithLongestRootWord().getWord()
                    else:
                        root = Word(candidate)
                    if previous_root is not None:
                        previous_probability = self.__n_gram.getProbability(previous_root.getName(), root.getName())
                    else:
                        previous_probability = 0.0
                    if next_root is not None:
                        next_probability = self.__n_gram.getProbability(root.getName(), next_root.getName())
                    else:
                        next_probability = 0.0
                    if max(previous_probability, next_probability) > best_probability or len(candidates) == 1:
                        best_candidate = candidate
                        best_root = root
                        best_probability = max(previous_probability, next_probability)
                root = best_root
                result.addWord(Word(best_candidate))
            else:
                result.addWord(word)
            previous_root = root
            root = next_root
            next_root = self.checkAnalysisAndSetRoot(sentence, i + 2)
        return result

    cpdef loadAsciifiedSameList(self):
        """
        Loads asciified same word list. Asciified same words are the words whose asciified versions are also
        valid Turkish words. For example, ascified version of 'ekşi' is 'eksi', ascified version of 'fön' is 'fon'.
        """
        cdef str line
        input_file = open(pkg_resources.resource_filename(__name__, 'data/asciified-same.txt'), "r", encoding="utf8")
        lines = input_file.readlines()
        for line in lines:
            items = line.strip().split(" ")
            self.__asciified_same[items[0]] = items[1]
        input_file.close()
