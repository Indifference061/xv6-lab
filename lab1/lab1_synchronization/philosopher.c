#include "philosopher.h"

pthread_mutex_t chopsticks[NUMBER_OF_PHILOSOPHERS];
pthread_t philosophers[NUMBER_OF_PHILOSOPHERS];
pthread_attr_t attributes[NUMBER_OF_PHILOSOPHERS];

void pickUp(int philosopherNumber)
{
	printf("Philosopher %d wait for chopsticks\n",philosopherNumber);
	sem_wait(&leftup);
	pthread_mutex_lock(&chopsticks[philosopherNumber]);
	printf("Philosopher %d pick up chopsticks %d\n",philosopherNumber,philosopherNumber);
	pthread_mutex_lock(&chopsticks[(philosopherNumber+1)%NUMBER_OF_PHILOSOPHERS]);
	printf("Philosopher %d pick up chopsticks %d\n",philosopherNumber,(philosopherNumber+1)%NUMBER_OF_PHILOSOPHERS);
}
void putDown(int philosopherNumber)
{
	pthread_mutex_unlock(&chopsticks[philosopherNumber]);
	pthread_mutex_unlock(&chopsticks[(philosopherNumber+1)%NUMBER_OF_PHILOSOPHERS]);
	sem_post(&leftup);
	printf("Philosopher %d put dowm chopsticks %d and %d\n",philosopherNumber,philosopherNumber,(philosopherNumber+1)%NUMBER_OF_PHILOSOPHERS);
}
void philosopher(int philosopherNumber) {
	while (1) {
		int i = (int)philosopherNumber;
		think(philosopherNumber);
		// TODO
		pickUp(philosopherNumber);
		// 实现pickUp()函数
		eat(philosopherNumber);
		// TODO
		putDown(philosopherNumber);
		// 实现putDown()函数
	}
}

void think(int philosopherNumber) {
	int sleepTime = rand() % 3 + 1;
	printf("Philosopher %d will think for %d seconds\n", philosopherNumber, sleepTime);
	sleep(sleepTime);
}

		
void eat(int philosopherNumber) {
	int eatTime = rand() % 3 + 1;
	printf("Philosopher %d will eat for %d seconds\n", philosopherNumber, eatTime);
	sleep(eatTime);
}