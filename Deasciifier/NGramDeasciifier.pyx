from Corpus.Sentence cimport Sentence
from Dictionary.Word cimport Word
from MorphologicalAnalysis.FsmMorphologicalAnalyzer cimport FsmMorphologicalAnalyzer
from MorphologicalAnalysis.FsmParseList cimport FsmParseList
from NGram.NGram cimport NGram

import pkg_resources
from Deasciifier.SimpleDeasciifier cimport SimpleDeasciifier


cdef class NGramDeasciifier(SimpleDeasciifier):

    cdef NGram __nGram
    cdef bint __rootNgram
    cdef float __threshold
    cdef dict __asciifiedSame

    def __init__(self, fsm: FsmMorphologicalAnalyzer, nGram: NGram, rootNGram: bool):
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
        self.__nGram = nGram
        self.__rootNgram = rootNGram
        self.__threshold = 0.0
        self.__asciifiedSame = {}
        self.loadAsciifiedSameList()

    cpdef Word checkAnalysisAndSetRoot(self, Sentence sentence, int index):
        """
        Checks the morphological analysis of the given word in the given index. If there is no misspelling, it returns
        the longest root word of the possible analyses.
        @param sentence Sentence to be analyzed.
        @param index Index of the word
        @return If the word is misspelled, null; otherwise the longest root word of the possible analyses.
        """
        cdef FsmParseList fsmParses
        if index < sentence.wordCount():
            fsmParses = self.fsm.morphologicalAnalysis(sentence.getWord(index).getName())
            if fsmParses.size() != 0:
                if self.__rootNgram:
                    return fsmParses.getParseWithLongestRootWord().getWord()
                else:
                    return sentence.getWord(index)
        return None

    cpdef setThreshold(self, float threshold):
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
        cdef str bestCandidate, candidate
        cdef Sentence result
        cdef int i, repeat
        cdef Word previousRoot, word, bestRoot, root, nextRoot
        cdef FsmParseList fsmParses
        cdef list candidates
        cdef double bestProbability, previousProbability, nextProbability
        cdef bint isAsciifiedSame
        previousRoot = None
        result = Sentence()
        root = self.checkAnalysisAndSetRoot(sentence, 0)
        nextRoot = self.checkAnalysisAndSetRoot(sentence, 1)
        for repeat in range(2):
            for i in range(sentence.wordCount()):
                candidates = []
                isAsciifiedSame = False
                word = sentence.getWord(i)
                if word.getName() in self.__asciifiedSame:
                    candidates.append(word.getName())
                    candidates.append(self.__asciifiedSame[word.getName()])
                    isAsciifiedSame = True
                if root is None or isAsciifiedSame:
                    if not isAsciifiedSame:
                        candidates = self.candidateList(word)
                    bestCandidate = word.getName()
                    bestRoot = word
                    bestProbability = self.__threshold
                    for candidate in candidates:
                        fsmParses = self.fsm.morphologicalAnalysis(candidate)
                        if self.__rootNgram and not isAsciifiedSame:
                            root = fsmParses.getParseWithLongestRootWord().getWord()
                        else:
                            root = Word(candidate)
                        if previousRoot is not None:
                            previousProbability = self.__nGram.getProbability(previousRoot.getName(), root.getName())
                        else:
                            previousProbability = 0.0
                        if nextRoot is not None:
                            nextProbability = self.__nGram.getProbability(root.getName(), nextRoot.getName())
                        else:
                            nextProbability = 0.0
                        if max(previousProbability, nextProbability) > bestProbability:
                            bestCandidate = candidate
                            bestRoot = root
                            bestProbability = max(previousProbability, nextProbability)
                    root = bestRoot
                    result.addWord(Word(bestCandidate))
                else:
                    result.addWord(word)
                previousRoot = root
                root = nextRoot
                nextRoot = self.checkAnalysisAndSetRoot(sentence, i + 2)
            sentence = result
            if repeat < 1:
                result = Sentence()
                previousRoot = None
                root = self.checkAnalysisAndSetRoot(sentence, 0)
                nextRoot = self.checkAnalysisAndSetRoot(sentence, 1)
        return result

    cpdef loadAsciifiedSameList(self):
        cdef str line
        inputFile = open(pkg_resources.resource_filename(__name__, 'data/asciified-same.txt'), "r", encoding="utf8")
        lines = inputFile.readlines()
        for line in lines:
            items = line.strip().split(" ")
            self.__asciifiedSame[items[0]] = items[1]
        inputFile.close()
