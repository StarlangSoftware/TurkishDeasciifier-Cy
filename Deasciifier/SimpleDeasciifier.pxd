from MorphologicalAnalysis.FsmMorphologicalAnalyzer cimport FsmMorphologicalAnalyzer
from Dictionary.Word cimport Word
from Corpus.Sentence cimport Sentence
from Deasciifier.Deasciifier cimport Deasciifier


cdef class SimpleDeasciifier(Deasciifier):

    cdef FsmMorphologicalAnalyzer fsm

    cpdef __generateCandidateList(self, list candidates, str word, int index)
    cpdef list candidateList(self, Word word)
    cpdef list candidateList(self, Word word)
    cpdef Sentence deasciify(self, Sentence sentence)
