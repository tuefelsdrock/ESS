
Hello, this is a project I am working on to learn Ruby.

This application uses a genetic algorithm to solve the 'knapsack' problem, e.g.:
The goal is to breed a reasonably optimal choice from a large domain of options
within a certain boundary.

So far, the application contains a hypothetical inventory of items from an
electronics store, where the goal is to select the maximum value that will fit
in a finite shopping cart.

The reason I chose a genetic approach is that the number of options increases
exponentially with each item.  In the demonstration, an inventory of 115 items 
poses 41538374868278621028243970633760767 possible choices (2^115 - 1) so a 
brute force approach can become computationally expensive.

The reason I chose this particular problem is that I originally wrote it in 
Java and wanted to see what refactoring it in ruby would present as challenges.
I was pleasantly surprised at the speed and intuitiveness of using Ruby!




To start, 
bundle
rake
open a browser, enter: http://127.0.0.1:4567/ess


more to do: 

* add a csv reader
* put a real UI (rails) on it.

tested with 1.9.2.  probably requires 1.9 at least.
