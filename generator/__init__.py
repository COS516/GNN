from __future__ import print_function
import random
import numpy as np
from satispy import Variable, Cnf
from satispy.solver import Minisat

def sample(population, k):
    return [random.choice(population) for _ in range(k)]

def generate(numVariables, k, numClauses):
    # TODO: assert numVariables < k * numClauses?
    # Total number of possible literals
    numLiterals = 2 * numVariables

    # Literal 2n represents variable n, whereas literal (2n + 1) represents variable -n
    formula = [sample(range(numLiterals), k) for _ in range(numClauses)]

    # Get total number of variables actually used in formula
    variablesInFormula = set([literal / 2 for clause in formula for literal in clause])

    variables = [Variable(str(i)) for i in range(numVariables)]

    # Build CNF
    cnf = Cnf()
    for clause in formula:

        # Build DNF
        dnf = Cnf()
        for literal in clause:

            # Get variable using literal index
            variable = variables[literal / 2]

            # Again, negate variable as described above
            dnf |= variable if literal % 2 == 0 else -variable

        # Append DNF clause
        cnf &= dnf

    solver = Minisat()
    solution = solver.solve(cnf)
    # for dis in cnf.dis:
        # for var in dis:
            # print var.name
            # print var.inverted

    # TODO: consider external representation for 'formula'
    if solution.success:
        return (formula, [solution[variables[i]] for i in variablesInFormula])
    else:
        return (formula, None)

# TODO
# def shuffle by clause or by variable

# TODO
def write(numVariables, formula):
    # write formula in vector representation for NN input

    # Preallocate representation matrix
    matrix = np.array([[0]*len(formula) for _ in range(2*numVariables)])

    # Iterate along clauses (columns) marking the member literals
    for c in range(len(formula)):
        for l in formula[c]:
            matrix[l][c] = 1

    # Flatten to 1D representation
    return np.reshape(matrix, (1, 2*numVariables*len(formula)))
    

# TODO
# def read

# TODO
# Generate unique formulae (e.g., not same variables)



numVariables = 10
k = 3
numClauses = 10

res = generate(numVariables, k, numClauses)
formula = res[0]
solution = res[1]

# Print formula
print('{}|'.format(formula),end="")

# Print solution
print('0,{}'.format(solution[0]),end="")
for i in range(1,len(solution)):
    print(';{},{}'.format(2*i,solution[i]),end="") # note: uses print function from python 3+

# print formula
# print solution
# print(write(numVariables, formula))

