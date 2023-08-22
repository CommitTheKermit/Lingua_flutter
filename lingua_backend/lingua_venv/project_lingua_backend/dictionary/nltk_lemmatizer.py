import nltk
from nltk.corpus import wordnet
from nltk.stem import WordNetLemmatizer
import os

# NLTK POS 태그를 WordNet 품사로 변환
def get_wordnet_pos(treebank_tag):
    if treebank_tag.startswith('J'):
        return wordnet.ADJ
    elif treebank_tag.startswith('V'):
        return wordnet.VERB
    elif treebank_tag.startswith('N'):
        return wordnet.NOUN
    elif treebank_tag.startswith('R'):
        return wordnet.ADV
    else:
        return wordnet.NOUN  # Default to noun as it's the safest bet
    

def download_necessaries():
    # WordNet 데이터 다운로드
    if not nltk.data.find(os.path.join('corpora', 'wordnet.zip')):
        nltk.download('wordnet')
        print('wordnet downloaded')
    else:
        print('wordnet already downloaded')

    if not nltk.data.find(os.path.join('taggers', 'averaged_perceptron_tagger.zip')):
        nltk.download('averaged_perceptron_tagger')
        print('averaged_perceptron_tagger downloaded')
    else:
        print('averaged_perceptron_tagger already downloaded')

def lemmatizer(word) -> str:
    wordnet_lemmatizer  = WordNetLemmatizer()

    pos_tag = nltk.pos_tag([word])[0][1]
    wordnet_pos = get_wordnet_pos(pos_tag)

    lemma = wordnet_lemmatizer.lemmatize(word, pos=wordnet_pos)

    return lemma