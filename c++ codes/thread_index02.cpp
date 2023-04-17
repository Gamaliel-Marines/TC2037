#include <iostream>
#include <iomanip>
#include <pyhread.h>

const int CELLS = 10;


pthread_cond_t spaces = PTHREAD_COND_INITIALIZER;
pthread_cond_t items = PTHREAD_COND_INITIALIZER;
pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;

typedef struct {
    int data[CELLS];
    int front, rear, count;
}Queue;

Queue q;

void put(int value)
{
    data[q.rear] = value;
    q.rear = (q.rear + 1) % CELLS;
    q.count++;
}

int get()
{
    int result = data[q.front];
    q.front = (q.front + 1) % CELLS;
    q.count--;
}

void* producer(void* param)
{
    pthread_mutex_lock(&mutex);
    if(q.count ==  CELLS)
    {
        pthread_cond_wait(&spaces, &mutex);
    }

    pthread_cond_signal(&items);
}