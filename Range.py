import numpy as np
from functools import singledispatchmethod

class Range:
    def __init__(self, start, end, step, count = -1):
        self.start = start
        self.end = end
        self.step = step
        if (count == -1):
            self.count = int((end - start) / step) + 1
        else:
            self.count = int(count)
            
        self.range = np.linspace(start, start + step * self.count, self.count)
    def print(self):
        print("Printing the range")
        print(self.start, self.end, self.step, self.count)
        # print(self.range)



class Range2:
    @singledispatchmethod
    def __init__(self, something: any):
        print("Oh no!")
    
    @__init__.register(float)
    def _(self, step: float, start: float, end: float):
        self.start = start
        self.end = end
        self.step = step
        self.count = int((end - start) / step)
        self.range = np.linspace(self.start, self.start + self.step * self.count, self.count)
    
    @__init__.register(int)
    def _(self, count: int, start: float, end: float):
        self.start = start
        self.end = end
        self.step = (end - start) / count
        self.count = int(count)
        self.range = np.linspace(self.start, self.start + self.step * self.count, self.count)

    def print(self):
        print("Printing the range")
        print(self.start, self.end, self.step, self.count)
        print(self.range)


if __name__ == "__main__":
    r1 = Range2(0.1, 0, 1)
    r2 = Range2(10, 0, 1)
    r1.print()
    r2.print()
