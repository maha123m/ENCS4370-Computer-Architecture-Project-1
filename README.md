# ENCS4370-Computer-Architecture
This project involves implementing a simple dictionary-based compression and decompression tool in MIPS assembly language using the MARS simulator. The tool uses a 16-bit code to substitute for words in an uncompressed text file. Here are the key details:
1) Dictionary-based Compression:
    * A unique 16-bit binary code is assigned to each word in the uncompressed file.
    * The code size is fixed at 16 bits, allowing encoding of up to 65,536 unique words.
    * The uncompressed file contains Unicode characters (16 bits per character).
    * The dictionary is stored in a text file called "dictionary.txt," with binary codes starting from 0x0000.
    * Initially, the dictionary is empty and is populated as more compression operations are performed.
    * The tool is case-sensitive, treating words like "project" and "Project" as distinct.
    * Special characters (e.g., spaces, punctuation marks) are also assigned codes in the dictionary.
