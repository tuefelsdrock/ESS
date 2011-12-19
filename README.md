
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
So far, I've spent about 6 hours on the project.

It has a minimal Sinatra Frontend.


To start:

* bundle

* rake

* open a browser, enter: http://127.0.0.1:4567/ess

* click on the Go button.

You'll see several lines like this:

|----|--|----|--|------|---|--|-----|--||-------|----|----------------|-------------------|-|--------|----------|--
Gen:   1 Sol:  18 value:  2005.59 volume:   992.00 

The "|---|--" line represents a single character for each item in the inventory, with the | representing a choice.

this is the sum of the chosen items -> value:  2005.59 

this is the size of the chosen items -> volume:   992.00 

Reload the page for another try.

the 'solution' link shows the actual items chosen from inventory.


tested with 1.9.2.  probably requires 1.9 at least.

Classes:

* Choice List   Inventory Attributes and methods, fitness function
* Sgenome  A flyweight instance of one selection
* Culture  Population of sgenomes, inheritance, mutation functions
* Ess  Evolutionary methods
* Rpjwh Number methods

more to do: 

* add a csv reader
* put a real UI (rails) on it.

