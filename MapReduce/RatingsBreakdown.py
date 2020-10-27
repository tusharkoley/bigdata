from mrjob.job import MRJob
from mrjob.step import MRStep

class RatingsBreakdown(MRJob):
    def steps(self):    
        return [
            MRStep(
                   mapper=self.mapper_get_ratings,
                   combiner=self.combiner_count_words,
                   reducer=self.reducer_count_words),
            MRStep(reducer=self.reducer_find_percentage)
        ]
 
    def mapper_get_ratings(self, _, line):
        words = line.split()
        for word in words:
            yield word, 1

    def combiner_count_words(self, word, counts):
        # sum the words we've seen so far
        yield (word, sum(counts))

    def reducer_count_words(self, word, counts):
        # send all (num_occurrences, word) pairs to the same reducer.
        # num_occurrences is so we can easily use Python's max() function.
        yield None, (sum(counts), word)

    def reducer_find_percentage(self, _, word_count_pairs):
      try:
            s=0
            ls_cnt=[]
            w_cnt=[]
            for count, word in word_count_pairs:
                s+=int(count)  
                ls_cnt.append(count)
                w_cnt.append(word)
            i=0
            for w in w_cnt:
            # for  word,count in pairs:
               yield   w, (ls_cnt[i]/s)*100
               i+=1
      except ValueError:
            pass
if __name__ == '__main__':
    RatingsBreakdown.run()
