#!/usr/bin/perl -w
#
# Quick and Simple User Generator
#
# Returns N number of random users (email addresses) using the format
# FirstName.LastName<RANDNUM>@Domain. Data is drawn from:
#
# * Domain names of Fortune 100 companies found at:
#    http://money.cnn.com/magazines/fortune/fortune500/2009/full_list/
#
# * 200 most common last names found at:
#    http://www.census.gov/genealogy/names/dist.all.last
#
# * 100 most common female names + 100 most common male names found at:
#    http://www.census.gov/genealogy/names/dist.female.first
#    http://www.census.gov/genealogy/names/dist.male.first
#
# There is no provision to check for duplicate users being generated
# but based on testing, none are seen for counts of <= 3000 users.
#
# Copyright (c) 2017 - Brown Consulting Services
#
use strict;


# Add a random number to the generated name to help prevent it
# from matching a possible real person.
my $RANDOM_NUMBER_MAX = 98;


my @domains = (
    "3m.com",                "abbott.com",
    "admworld.com",          "aetna.com",
    "alcoa.com",             "allstate.com",
    "americanexpress.com",   "amerisourcebergen.com",
    "apple.com",             "att.com",
    "bankofamerica.com",     "berkshirehathaway.com",
    "bestbuy.com",           "boeing.com",
    "cardinal.com",          "cat.com",
    "chevron.com",           "chsinc.com",
    "cisco.com",             "citigroup.com",
    "comcast.com",           "conocophillips.com",
    "costco.com",            "cvscaremark.com",
    "dell.com",              "disney.com",
    "dow.com",               "dupont.com",
    "emerson.com",           "enterprisegp.com",
    "exxonmobil.com",        "fedex.com",
    "ford.com",              "ge.com",
    "generaldynamics.com",   "gm.com",
    "gmacfs.com",            "gs.com",
    "hcahealthcare.com",     "hess.com",
    "homedepot.com",         "honeywell.com",
    "hp.com",                "humana.com",
    "ibm.com",               "ingrammicro.com",
    "intel.com",             "internationalpaper.com",
    "jnj.com",               "johndeere.com",
    "johnsoncontrols.com",   "jpmorganchase.com",
    "kraftfoodscompany.com", "kroger.com",
    "libertymutual.com",     "lockheedmartin.com",
    "lowes.com",             "macysinc.com",
    "marathon.com",          "mckesson.com",
    "medco.com",             "metlife.com",
    "microsoft.com",         "morganstanley.com",
    "motorola.com",          "murphyoilcorp.com",
    "newscorp.com",          "newyorklife.com",
    "northropgrumman.com",   "oxy.com",
    "paalp.com",             "pepsico.com",
    "pfizer.com",            "pg.com",
    "pmintl.com",            "prudential.com",
    "riteaid.com",           "safeway.com",
    "searsholdings.com",     "sprint.com",
    "statefarm.com",         "sunocoinc.com",
    "supervalu.com",         "sysco.com",
    "target.com",            "thecoca-colacompany.com",
    "tiaa-cref.org",         "timewarner.com",
    "travelers.com",         "tsocorp.com",
    "tysonfoodsinc.com",     "unitedhealthgroup.com",
    "ups.com",               "utc.com",
    "valero.com",            "verizon.com",
    "walgreens.com",         "walmartstores.com",
    "wellpoint.com",         "wellsfargo.com"
);

my @lastNames = (
    "Smith",     "Johnson",    "Williams",   "Jones",
    "Brown",     "Davis",      "Miller",     "Wilson",
    "Moore",     "Taylor",     "Anderson",   "Thomas",
    "Jackson",   "White",      "Harris",     "Martin",
    "Thompson",  "Garcia",     "Martinez",   "Robinson",
    "Clark",     "Rodriguez",  "Lewis",      "Lee",
    "Walker",    "Hall",       "Allen",      "Young",
    "Hernandez", "King",       "Wright",     "Lopez",
    "Hill",      "Scott",      "Green",      "Adams",
    "Baker",     "Gonzalez",   "Nelson",     "Carter",
    "Mitchell",  "Perez",      "Roberts",    "Turner",
    "Phillips",  "Campbell",   "Parker",     "Evans",
    "Edwards",   "Collins",    "Stewart",    "Sanchez",
    "Morris",    "Rogers",     "Reed",       "Cook",
    "Morgan",    "Bell",       "Murphy",     "Bailey",
    "Rivera",    "Cooper",     "Richardson", "Cox",
    "Howard",    "Ward",       "Torres",     "Peterson",
    "Gray",      "Ramirez",    "James",      "Watson",
    "Brooks",    "Kelly",      "Sanders",    "Price",
    "Bennett",   "Wood",       "Barnes",     "Ross",
    "Henderson", "Coleman",    "Jenkins",    "Perry",
    "Powell",    "Long",       "Patterson",  "Hughes",
    "Flores",    "Washington", "Butler",     "Simmons",
    "Foster",    "Gonzales",   "Bryant",     "Alexander",
    "Russell",   "Griffin",    "Diaz",       "Hayes",
    "Myers",     "Ford",       "Hamilton",   "Graham",
    "Sullivan",  "Wallace",    "Woods",      "Cole",
    "West",      "Jordan",     "Owens",      "Reynolds",
    "Fisher",    "Ellis",      "Harrison",   "Gibson",
    "Mcdonald",  "Cruz",       "Marshall",   "Ortiz",
    "Gomez",     "Murray",     "Freeman",    "Wells",
    "Webb",      "Simpson",    "Stevens",    "Tucker",
    "Porter",    "Hunter",     "Hicks",      "Crawford",
    "Henry",     "Boyd",       "Mason",      "Morales",
    "Kennedy",   "Warren",     "Dixon",      "Ramos",
    "Reyes",     "Burns",      "Gordon",     "Shaw",
    "Holmes",    "Rice",       "Robertson",  "Hunt",
    "Black",     "Daniels",    "Palmer",     "Mills",
    "Nichols",   "Grant",      "Knight",     "Ferguson",
    "Rose",      "Stone",      "Hawkins",    "Dunn",
    "Perkins",   "Hudson",     "Spencer",    "Gardner",
    "Stephens",  "Payne",      "Pierce",     "Berry",
    "Matthews",  "Arnold",     "Wagner",     "Willis",
    "Ray",       "Watkins",    "Olson",      "Carroll",
    "Duncan",    "Snyder",     "Hart",       "Cunningham",
    "Bradley",   "Lane",       "Andrews",    "Ruiz",
    "Harper",    "Fox",        "Riley",      "Armstrong",
    "Carpenter", "Weaver",     "Greene",     "Lawrence",
    "Elliott",   "Chavez",     "Sims",       "Austin",
    "Peters",    "Kelley",     "Franklin",   "Lawson"
);

my @firstNames = (
    "Aaron",      "Adam",      "Alan",      "Albert",
    "Alice",      "Amanda",    "Amy",       "Andrea",
    "Andrew",     "Angela",    "Ann",       "Anna",
    "Anne",       "Annie",     "Anthony",   "Antonio",
    "Arthur",     "Ashley",    "Barbara",   "Benjamin",
    "Betty",      "Beverly",   "Billy",     "Bobby",
    "Bonnie",     "Brandon",   "Brenda",    "Brian",
    "Bruce",      "Carl",      "Carlos",    "Carol",
    "Carolyn",    "Catherine", "Charles",   "Cheryl",
    "Chris",      "Christina", "Christine", "Christopher",
    "Clarence",   "Craig",     "Cynthia",   "Daniel",
    "David",      "Deborah",   "Debra",     "Denise",
    "Dennis",     "Diana",     "Diane",     "Donald",
    "Donna",      "Doris",     "Dorothy",   "Douglas",
    "Earl",       "Edward",    "Elizabeth", "Emily",
    "Eric",       "Ernest",    "Eugene",    "Evelyn",
    "Frances",    "Frank",     "Fred",      "Gary",
    "George",     "Gerald",    "Gloria",    "Gregory",
    "Harold",     "Harry",     "Heather",   "Helen",
    "Henry",      "Howard",    "Irene",     "Jack",
    "Jacqueline", "James",     "Jane",      "Janet",
    "Janice",     "Jason",     "Jean",      "Jeffrey",
    "Jennifer",   "Jeremy",    "Jerry",     "Jesse",
    "Jessica",    "Jimmy",     "Joan",      "Joe",
    "John",       "Johnny",    "Jonathan",  "Jose",
    "Joseph",     "Joshua",    "Joyce",     "Juan",
    "Judith",     "Judy",      "Julia",     "Julie",
    "Justin",     "Karen",     "Katherine", "Kathleen",
    "Kathryn",    "Kathy",     "Keith",     "Kelly",
    "Kenneth",    "Kevin",     "Kimberly",  "Larry",
    "Laura",      "Lawrence",  "Lillian",   "Linda",
    "Lisa",       "Lois",      "Lori",      "Louis",
    "Louise",     "Margaret",  "Maria",     "Marie",
    "Marilyn",    "Mark",      "Martha",    "Martin",
    "Mary",       "Matthew",   "Melissa",   "Michael",
    "Michelle",   "Mildred",   "Nancy",     "Nicholas",
    "Nicole",     "Norma",     "Pamela",    "Patricia",
    "Patrick",    "Paul",      "Paula",     "Peter",
    "Philip",     "Phillip",   "Phyllis",   "Rachel",
    "Ralph",      "Randy",     "Raymond",   "Rebecca",
    "Richard",    "Robert",    "Robin",     "Roger",
    "Ronald",     "Rose",      "Roy",       "Ruby",
    "Russell",    "Ruth",      "Ryan",      "Samuel",
    "Sandra",     "Sara",      "Sarah",     "Scott",
    "Sean",       "Sharon",    "Shawn",     "Shirley",
    "Stephanie",  "Stephen",   "Steve",     "Steven",
    "Susan",      "Tammy",     "Teresa",    "Terry",
    "Theresa",    "Thomas",    "Timothy",   "Tina",
    "Todd",       "Victor",    "Virginia",  "Walter",
    "Wanda",      "Wayne",     "William",   "Willie"
);


# Script takes one arg which is the number of users to generate
if ($#ARGV < 0) {
    print "Usage: generate_sample_users.pl <count>\n";
    exit(1);
}

my $counter = int(shift);

($counter >= 1) or die "ERROR: Passed value $counter must be at least 1!";


# Generate random user names based on real names/domains
while ($counter) {
    my $userDomain    = $domains[ int( rand($#domains) + 1 ) ];
    my $userFirstName = $firstNames[ int( rand($#firstNames) + 1 ) ];
    my $userLastName  = $lastNames[ int( rand($#lastNames) + 1 ) ];
    my $userRandNumber = int(rand($RANDOM_NUMBER_MAX) + 1);
    print $userFirstName. "." . $userLastName . $userRandNumber . "@" .
          $userDomain . "\n";
    $counter--;
}
