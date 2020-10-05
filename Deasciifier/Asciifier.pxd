from Corpus.Sentence cimport Sentence


cdef class Asciifier:

    cpdef Sentence asciify(self, Sentence sentence)
