// Leibniz formula for PI

#include <iostream>
#include <pthread.h>

#define THREADS_NUM 4 // 4 threads
#define N 100000000 // 1e8

double pi = 0.0; 

struct thread_args { // struct to pass arguments to thread
    long start; 
    long end;
    double sum;
};

void *leibnizPi(void *arg) { // compute pi using Leibniz formula
    struct thread_args targs = (struct thread_args)arg; // cast void* to struct thread_args*
    for (long i = targs.start; i < targs.end; i++) { // compute sum of terms
        double sign = i % 2 == 0 ? 1.0 : -1.0; // 1.0 if i is even, -1.0 if i is odd
        double term = sign / (2 * i + 1); // this is doing 1/(2i+1) if i is even, -1/(2i+1) if i is odd
        targs.sum += term; // add term to sum
    }
    pi += targs.sum; // add sum to global pi
    free(arg); // free memory
    return NULL; // return NULL
}

int main() {
    pthread_t threads[THREADS_NUM]; // create array of threads
    for (int i = 0; i < THREADS_NUM; i++) { // create threads
        struct thread_args *targs = new struct thread_args; // create struct thread_args
        targs->start = i * (N / THREADS_NUM); // compute start and end of range
        targs->end = (i + 1) * (N / THREADS_NUM); // compute start and end of range
        targs->sum = 0.0; // initialize sum to 0
        pthread_create(&threads[i], NULL, leibnizPi, targs); // create thread
    }
    for (int i = 0; i < THREADS_NUM; i++) { // join threads
        pthread_join(threads[i], NULL); // join thread
    }
    pi *= 4.0; // multiply by 4
    std::cout << "pi = " << pi << std::endl; // print pi
    return 0;
}