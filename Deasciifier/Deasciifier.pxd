from Corpus.Sentence cimport Sentence


cdef class Deasciifier:

    cpdef Sentence deasciify(self, Sentence sentence)
