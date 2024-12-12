#include <iostream>
#include <fstream>
using namespace std;
void swap(int& a, int& b) {
    int temp = a;
    a = b;
    b = temp;
}
int partition(int array[], int low, int high) {
    int pivot = array[high];
    int i = (low - 1);
    for (int k = low; k < high; k++) {
        if (array[k] <= pivot) {
            i++;
            swap(array[i], array[k]);
        }
    }
    swap(array[i + 1], array[high]);
    return (i + 1);

}
void quickSort(int array[], int low, int high) {
    if (low < high) {
        int pivot = partition(array, low, high);
        quickSort(array, low, pivot - 1);
        quickSort(array, pivot + 1, high);
    }

}
int main() {
    int size = 50;
    int array[] = {
        -55, -20, -49, 77, 95, -21, -99, 42, 36, -64
        ,-29, 77, 43, -47, 45, 69, -5, 36, 80, 15
        ,49, 13, -88, 38, 12, 2, 77, 85, 73, -69
        ,-52, 12, 76, 5, -77, -81, 45, 68, 55, 56
        ,7, 17, 13, -16, 56, -22, -19, -67, -28, -13
    };
    quickSort(array, 0, size - 1);
}
