import numpy as np
cimport numpy as np
from libcpp cimport bool
from libc.stdint cimport uint64_t
from libcpp.vector cimport vector
from libcpp.string cimport string
from libc.string cimport memcpy
cimport cython
cdef extern from "keyword_search.cpp":
    bool* sentences_contain_keywords(const vector[string]& sentences, const vector[string]& keywords) nogil

cpdef build_binary_matrix(np.ndarray sentences, np.ndarray keywords):
    cdef uint64_t num_sentences = sentences.shape[0]
    cdef uint64_t num_keywords = keywords.shape[0]
    cdef uint64_t total_size = num_sentences * num_keywords;
    cdef uint64_t i
    cdef vector[string] cpp_sentences, cpp_keywords

    # Convert numpy strings to C++ strings
    for i in range(num_sentences):
        cpp_sentences.push_back(sentences[i].encode('utf-8'))
    for i in range(num_keywords):
        cpp_keywords.push_back(keywords[i].encode('utf-8'))

    # Call the C++ function
    cdef bool* result
    with cython.nogil:
        result = sentences_contain_keywords(cpp_sentences, cpp_keywords)

    cdef np.ndarray np_result = np.zeros((num_sentences, num_keywords), dtype=np.bool_)
    cdef np.uint8_t* np_result_ptr = <np.uint8_t*>np_result.data
    cdef np.uint8_t* result_ptr = <np.uint8_t*>result
    cdef int nbytes = total_size * sizeof(bool)
    memcpy(np_result_ptr, result_ptr, total_size * sizeof(bool))
    return np_result
