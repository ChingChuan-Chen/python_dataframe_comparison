## A Comparison between DataFrame-related Modules

It was motivated by a [discussion](https://www.ptt.cc/bbs/Python/M.1684059240.A.3FF.html) on PTT.
The discussion is to find out a way to boost the performance of `pandas`.
The author had a `dataframe` with one column named `sentence` which consists several words.
Also, he had a list of words which consists ten thousands words.
Then, he would like to append ten thousands of columns which the column name is the word and indicate if the sentence contains the corresponding word.

### Comparison

1. `polars`
2. `pandas`
3. `duckdb`
4. `pandas` + `numpy`
5. `Cython`

4 & 5 are the options to output `numpy` arrays.

### Results



### Notes

I don't include it in the comparison due to the difficult usage of `dask`.
However, `dask` is leveraging `pandas` in the internal, so it just an parallel processing based on `pandas`.
Its performance won't be less than 30 seconds per loop on a 4-core machine.
