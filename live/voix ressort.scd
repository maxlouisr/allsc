C.crawl("/Users/maxlouisraugel/Documents/son/voix_ressort/");

Pbindef(\a, \instrument, \play, \buffer, Pseq(C.get(\voix_ressort, [0, 2, 4, 7]), inf), \amp, 1).play;

Pbindef(\k, \instrument, \kick, \dur, 1/2, \amp, 1, \freq, 50 + Pseq([0, 20, 40, 70], inf)).play;
