## Semi Major Axis Matching

The main idea: when the keplerian deprit hamiltonian and the full J2 hamiltonians match by value for the **leader**, 
we assume it is a special position and want the **follower** satellite to give a control pulse there.

We do that by finding the true anomaly (in keplerian deprit space) at the equilibrium of the hamiltonians,
Then  at that true anomaly for the follower we pulse for the follower

### Implementation Note
The bridge function is chosen by hard coding inside, this is ugly, TODO: fix this 