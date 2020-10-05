from MorphologicalAnalysis.FsmMorphologicalAnalyzer cimport FsmMorphologicalAnalyzer
from Dictionary.Word cimport Word
from Corpus.Sentence cimport Sentence


cdef class SimpleDeasciifier:

    cdef FsmMorphologicalAnalyzer fsm

    cpdef __generateCandidateList(self, list candidates, str word, int index)
    cpdef list candidateList(self, Word word)
    cpdef list candidateList(self, Word word)
    cpdef Sentence deasciify(self, Sentence sentence)
