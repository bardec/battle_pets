# BattlePets

## How to run...

### App

I tried to make it as idiomatic as possible in this regard:
1. `./bin/setup`
2. `./bin/rails s`

I wrote a test script that runs through a successful flow of the service
interaction. After starting the server you can run:

`./script/integration_script.rb`

### Tests

Should be as simple as `rake`!

## Discussion

(feel free to skim or ignore this, but I like writing these to explain my
rationale)

### Contests

I chose to opt for a pattern which would hopefully make the coding problem
easier when/if I go onsite. Contests themselves are very agnostic - they have
two competitors, a state (in_progress or completed), and a type (which explains
what type of contest it is). If the contest is done then obviously a winner is
recorded with a time!

Since I kept that just a basic data object, it gave me flexibility on how to
compute the scores. For that I came up with the concept of a ContestType, which
basically has a `name` and a `score_competitor`. The name is used to match up
with the type from the contest, and `score_competitor` is a method that just
gets a score for a pet passed in.

Since the ContestType does not actually choose the winner, and only the scores,
there is a service `ContestPlayService` that is called directly from the
ActiveJob that handles the running of the contest, and picking a winner
(randomly if a tie).

### Blacklisting ContestTypes

One thing I thought was interesting was the concept of being able to add/remove
ContestTypes easily. Adding them is easy, you just make a new one and deploy the
code. Removing them is a little more tricky.

When you remove a code dependency that is coupled to a job, you need to make
sure that you give time for all the Contests that rely on that ContestType to
finish. If you were just to delete the code, then you would get exceptions when
a ContestType was not found when the `ContestPlayService` triggered. 

To handle this, I rolled out a `ContestTypeListService` which maintains a hash
of names -> ContestType. There is a contest_type.yml which maintains a
black_list. If you wanted to remove a contest_type without incurring downtime,
you could add it to the black list, restart the server (making it so new
Contests can't have that type), and then remove the ContestType once all contests 
of that type are done.

~Easy!
