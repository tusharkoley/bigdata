from pyspark import SparkContext
from pyspark.sql import SQLContext

sc=SparkContext() 
path = "eventLogging/local-1588781816130.inprogress"
sqlConf = SQLContext(sc)
df=sqlConf.read.json(path)
df.createOrReplaceTempView("Events")

# The Number of events so far
print(f'The number of events So far = {df.count()}')

dist_events=df.groupBy('Event').count()
print(f'The number of distinct events So far = {dist_events.count()}')

event_list=[]
event_timestamp=dict()
for event in dist_events.collect(): 
    event_dict=event.asDict()  
    event_list.append(event_dict.['Event'])
    event_timestamp[event_dict.['Event']]=event_dict.['Event']

open_event=[]

for event in event_list:
    if event[-5:]=='Start':
        open_event.append(event[:-5])
        
    elif event[-3:]=='End':
        open_event.remove(event[:-3])

print(f'The events that are still open is {open_event}')


event_time_dict=dict()
for event in df.collect():
    
    event_d=event.asDict()
    try:
        start_time = event_d['Task Info']['Launch Time']
        end_time = event_d['Task Info']['Finish Time']
        
        if end_time > 0:            
            try:
                event_time_dict[event_d['Event']]+=','+ str(end_time-start_time)
            except:
                event_time_dict[event_d['Event']]=str(end_time-start_time)
    except:
        pass
            

for task, time in event_time_dict.items():
    
 s_time=time.split(',')

 avg=sum(list(map(int,s_time)))/len(s_time)
 print(f' The task {task} has the average time {avg}')
 

 for task, time in event_time_dict.items():
    
 s_time=time.split(',')

 l_time=list(map(int,s_time))
    
 long_job=[]
 
for e_time in l_time:
    if e_time > avg:
        long_job.append((task,e_time))
        
        
        
print(f'The long job list is {long_job}')
        
    
     