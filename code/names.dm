var/list/ai_names = file2list("strings/ai.txt")
var/list/first_names_male = file2list("strings/first_male.txt")
var/list/first_names_female = file2list("strings/first_female.txt")
var/list/last_names = file2list("strings/last.txt")
var/list/clown_names = file2list("strings/clown.txt")
var/list/operation_titles = file2list("strings/operation_title.txt")
var/list/operation_prefixes = file2list("strings/operation_prefix.txt")
var/list/operation_postfixes = file2list("strings/operation_postfix.txt")

var/list/verbs = file2list("strings/verbs.txt")
//loaded on startup because of "
//would include in rsc if ' was used


var/list/first_names_male_clf = list("Alan","Jack","Bil","Jonathan","John","Shiro","Gareth","Clark","Sam", "Lionel", "Aaron", "Charlie", "Scott", "Winston", "Aidan", "Ellis", "Mason", "Wesley", "Nicholas", "Calvin", "Nishikawa", "Hiroto", "Chiba", "Ouchi", "Furuse", "Takagi", "Oba", "Kishimoto")
var/list/first_names_female_clf = list("Emma", "Adelynn", "Mary", "Halie", "Chelsea", "Lexie", "Arya", "Alicia", "Selah", "Amber", "Heather", "Myra", "Heidi", "Charlotte", "Oliva", "Lydia", "Tia", "Riko", "Ari", "Machida", "Ueki", "Mihara", "Noda")
var/list/last_names_clf = list("Hawkins","Rickshaw","Elliot","Billard","Cooper","Fox", "Barlow", "Barrows", "Stewart", "Morgan", "Green", "Stone", "Burr", "Hunt", "Yuko", "Gesshin", "Takanibu", "Tetsuzan", "Tomomi", "Bokkai", "Takesi")

var/list/first_names_male_colonist = list("Alan","Jack","Bil","Jonathan","John","Shiro","Gareth","Clark","Sam", "Lionel", "Aaron", "Charlie", "Scott", "Winston", "Aidan", "Ellis", "Mason", "Wesley", "Nicholas", "Calvin", "Nishikawa", "Hiroto", "Chiba", "Ouchi", "Furuse", "Takagi", "Oba", "Kishimoto")
var/list/first_names_female_colonist = list("Emma", "Adelynn", "Mary", "Halie", "Chelsea", "Lexie", "Arya", "Alicia", "Selah", "Amber", "Heather", "Myra", "Heidi", "Charlotte", "Ashley", "Raven", "Tori", "Anne", "Madison", "Oliva", "Lydia", "Tia", "Riko", "Ari", "Machida", "Ueki", "Mihara", "Noda")
var/list/last_names_colonist = list("Hawkins","Rickshaw","Elliot","Billard","Cooper","Fox", "Barlow", "Barrows", "Stewart", "Morgan", "Green", "Stone", "Titan", "Crowe", "Krantz", "Pathillo", "Driggers", "Burr", "Hunt", "Yuko", "Gesshin", "Takanibu", "Tetsuzan", "Tomomi", "Bokkai", "Takesi")

var/list/first_names_male_upp = list("Badai","Mongkeemur","Alexei","Andrei","Artyom","Viktor","Xiangai","Ivan","Choban","Oleg", "Dayan", "Taghi", "Batu", "Arik", "Orda", "Ghazan", "Bala", "Gao", "Zhan", "Ren", "Hou", "Xue", "Serafim", "Luca", "Su", "György", "István", "Mihály", "Vladimir", "Aleksandr", "Fyodor", "Bhodar", "Qazem", "Łukasz", "Miłogost", "Radogost", "Uniegost", "Hostirad", "Hostimil", "Hostisvit", "Lubgost", "Gościsław", "Vseslav", "Bohuměr", "Bronisław", "Česćiměr", "Dobysław", "Horisław", "Jaroměr", "Mirosław", "Mječisław", "Radoměr", "Stanij", "Stanisław", "Wjeleměr", "Wójsław")
var/list/first_names_female_upp = list("Altani","Cirina","Anastasiya","Saran","Wei","Oksana","Ren","Svena","Tatyana","Yaroslava", "Izabella", "Kata", "Krisztina", "Miruna", "Flori", "Lucia", "Anica", "Li", "Yimu", "Alona", "Hsiau-Li", "Xiaoling", "Erhong", "Baśka", "Angela", "Angelina", "Angja", "Ankica", "Biljana", "Bisera", "Bistra", "Blaga", "Blagica", "Blagorodna", "Verka", "Vladica", "Denica", "Živka", "Zlata", "Jagoda", "Letka", "Ljupka", "Mila", "Mirjana", "Mirka", "Rada", "Radmila", "Slavica", "Slavka", "Snežana", "Stojna", "Ubavka", "Jaromir", "Mscëwòj", "Subisłôw", "Swiãtopôłk", "Ji-Sun", "Chaeyong", "Chaewon", "Saerom", "Seoyeong", "Jiheon", "Hayoung")
var/list/last_names_upp = list("Azarov","Bogdanov","Barsukov","Golovin","Davydov","Khan","Noica","Barbu","Zhukov","Ivanov","Mihai","Kasputin","Belov", "Belova","Melnikov", "Vasilevsky", "Aleksander", "Halkovich", "Stanislaw", "Proca", "Zaituc", "Arcos", "Kubat", "Kral", "Volf", "Xun", "Jia", "Bachoń", "Wang", "Ji", "Xiang", "Zhang", "Mei", "Ma", "Kim", "Yi", "Ri", "Pak", "Chong", "Baek", "Kwon", "Hwang", "Roh", "Lee", "Song")

var/list/first_names_pmc = list("Alpha", "Bravo", "Charlie", "Delta", "Echo", "Foxtrot", "Golf", "Hotel", "India", "Juliett", "Kilo", "Lima", "Mike", "November", "Oscar", "Papa", "Quebec", "Romeo", "Sierra", "Tango", "Uniform", "Victor", "Whiskey", "Xray", "Yankee", "Zulu", "Bravost", "Element", "Unit", "Hunter", "Outlaw", "Kronos", "Oni", "Kappa", "Noble", "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten")
var/list/last_names_pmc = list("Amaranth", "Amber", "Apricot", "Brown", "Blue", "Bronze", "Cerulean", "Crimson", "Charcoal", "Cyan", "Emerald", "Fuchsia", "Gold", "Gray", "Green", "Indigo", "Ivory", "Jade", "Lavender", "Lemon", "Lilac", "Magenta", "Maroon", "Navy", "Olive", "Orange", "Pink", "Purple", "Quartz", "Red", "Silver", "Tan", "Teal", "Ultramarine", "Violet", "White", "Yellow")

var/list/first_names_male_gladiator = list("Augustus", "Maximus", "Octavius", "Septimus", "Titus", "Brutus", "Caesar", "Justinian")
var/list/first_names_female_gladiator = list("Aelia", "Aquila", "Caecilia", "Camilla", "Claudia", "Flavia", "Martina", "Theodora")

var/list/first_names_male_dutch = list("Raymond", "Jesse", "Jack", "John", "Sam", "Aaron", "Charlie", "Ellis", "Nick", "Francis", "Louis")
var/list/first_names_female_dutch = list("Chelsea", "Mira", "Jessica", "Catherine", "Eliza", "Emma", "Ashley", "Annie", "Alicia", "Miranda", "Ellen")

var/list/monkey_names = list("Abu", "Aldo", "Bear", "Bingo", "Clyde", "Crystal", "Gordo", "George", "Koko", "Marcel", "Nim", "Rafiki", "Spike", "Banana", "Boots", "Bubbles", "Smiley", "Winston")

var/list/weapon_surnames = list("Adze", "Axe", "Bagh Nakha", "Bo", "Bola", "Bow", "Bowman", "Cannon", "Carbine", "Cestus", "Club", "Culverin", "Dagger", "Dao", "Derringer", "Dha", "Dussack", "Emeici", "Falchion", "Fan", "Flyssa", "Gauntlet", "Hammer", "Halberd", "Harquebus", "Hatchet", "Hwando", "Katar", "Kampilan", "Knuckles", "Lance", "Lancer", "Larim", "Maduvu", "Mace", "Maru", "Mauser", "Messer", "Mine", "Mubucae", "Nyepel", "Onager", "Pata", "Pike", "Ram", "Saber", "Seax", "Shamsir", "Sickle", "Sling", "Spear", "Spears", "Staff", "Sword", "Tekko")
