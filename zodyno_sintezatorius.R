### sintetiniai lietuviu kalbos naujadarai
### Jonas B. 2017 Dec 20-30

library(markovchain)

# load a real LT dictionary
load("~/Dropbox/GIT/SYNTHETIC_DICTIONARIES/lt-LT.dic.RData")

# extract all real normal words
all_words = gsub("[0-9]|/| |\\.", "", a$V1)
bad_ixs = grep("[A-Z]{2}",all_words)  # get rid of ACRONYMS
all_words = all_words[-bad_ixs]; rm(bad_ixs)
all_words = unique(all_words)
all_words = tolower(all_words)


##########
########## REALŪS DAIKTAVARDZHIAI (gr.5)
##########

sub = a[which(a$V2==5),]
lst = lapply(sub$V1,function(x) unlist(strsplit(x,"/")))
sub = do.call(rbind.data.frame, lst)
colnames(sub) = c("zodis","tipas")
sub$tipas = as.numeric(sub$tipas) # will introduce NAs
sub$zodis = as.character(sub$zodis)

# ishmesti farmacinius-tarptautinius
sub = sub[which(! sub$tipas %in% c(77)),]; nrow(sub)

# word list
dic = unique(sub$zodis); length(dic) #; dic[1:100]

## clean
dic = dic[which(nchar(dic)>=3)]
dic = dic[which(nchar(dic)<=20)]
length(dic) # 40039

# shuffle
dic = sample(dic,replace = F)

##########
########## SINTETINTI NAUJADARUS
##########

## transform into a single string of consequtive characters
fun = function(x) unlist(strsplit(x,""))

strng = NULL
for (i in 1:length(dic)) { # length(dic)
        ltrs = fun(dic[i])
        strng = c(strng,ltrs,"_")
} # takes about a minute

w = data.frame(lggd=lag(strng,n = 1),strng,stringsAsFactors = F)
w = w[-1,] # default remove
head(w)

# group 1: no frameshift
w1 = w[c(1, seq(1,nrow(w),by=2), 1),]
w1[1,1] = ""   # head
w1[1,2] = "_"  # head
w1[nrow(w1),1] = "_"  # tail
w1[nrow(w1),2] = ""   # tail

# group 2: with frameshift
w2 = w[c(1, seq(2,nrow(w),by=2)),]
w2[1,2] = w2[1,1]
w2[1,1] = "_"

# combine back
w = rbind(w2,w1)
rm(w1,w2)

# recode
w$xtra1 = ";"
w$xtra2 = ""

# scenario 1
ix = which(w$lggd=="_")
tmp1 = w$strng[ix]
tmp2 = w$xtra1[ix]
w$strng[ix] = tmp2
w$xtra1[ix] = tmp1
w$xtra2[ix] = ";"
head(w)

# scenario 2
ix = which(w$strng=="_")
tmp1 = w$strng[ix]
tmp2 = w$xtra1[ix]
w$strng[ix] = tmp2
w$xtra1[ix] = tmp1
w$xtra2[ix] = ";"

# recode
ww = apply(w,1,function(x) paste(x,collapse=""))
ww = paste(ww,collapse="")
ww = unlist(strsplit(ww,";"))

# Markov model
m = createSequenceMatrix(ww, toRowProbs = TRUE, sanitize = TRUE)
mcB = new("markovchain", states=row.names(m), transitionMatrix=m)

## generate random string with data-driven markov model
sq = rmarkovchain(1000000, mcB)

## digest the string into words
wrds = unlist(strsplit(paste(sq,collapse=""),"_"))
wrds = unique(wrds)

# what is common length of real LT words
hist(nchar(all_words),breaks=100,col="grey")
round(table(nchar(all_words)) / sum(length(all_words)) *100 ,1)
quantile(nchar(all_words),probs = c(0.025,0.975)) # ->   5-15

# what is the length of sinthetic LT words
hist(nchar(wrds),breaks=100,col="grey")
table(nchar(wrds))

wrds = wrds[which(nchar(wrds)>=5)]
wrds = wrds[which(nchar(wrds)<=15)]

# eliminate existing words
sum(wrds %in% all_words)
wrds[which(wrds %in% all_words)]
wrds = wrds[which(!wrds %in% all_words)]
#table(nchar(wrds))

o = paste(wrds,collapse=", ")
write(o,file = "~/Biostuff/LT_DICT/designs/SINT_daiktav_-77_method2.txt",append = FALSE)

# for tracking the uniqueness
write.table(wrds,"~/Biostuff/LT_DICT/designs/SINT_daiktav_-77_method2.lst",sep="\t",quote=F,row.names = F,col.names = F)

##### export words in batches (1 batch = 1 poster)
# wrds= read.table("~/Biostuff/LT_DICT/designs/SINT_daiktav_-77_method2.lst",sep="\t",h=F,stringsAsFactors = F)
# which(wrds == "prekutojimas")
# o = paste(wrds[14111:(14111+15000)],collapse=", ") # batch 2
# tmp = wrds[14111:(14111+15000)]
# which(tmp == "pabrolė")
# o = paste(wrds[29112:(29112+15000)],collapse=", ") # batch 3
# tmp = wrds[29112:(29112+15000)]
# which(tmp=="okamumas")
# o = paste(wrds[44113:(44113+15000)],collapse=", ") # batch 4
# tmp = wrds[44113:(44113+15000)]
# which(tmp=="ruktorundymas")
# o = paste(wrds[59114:(59114+15000)],collapse=", ") # batch 5
# tmp = wrds[59114:(59114+15000)]
# which(tmp=="žilikas")
# write(o,file = "~/Biostuff/LT_DICT/designs/SINT_daiktav_-77_method2_batch5.txt",append = FALSE)

