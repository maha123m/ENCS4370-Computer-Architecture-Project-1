# ENCS4370-Computer-Architecture
## Project Description
This project involves implementing a simple dictionary-based compression and decompression tool in MIPS assembly language using the MARS simulator. The tool uses a 16-bit code to substitute for words in an uncompressed text file. Here are the key details:

1) Dictionary-Based Compression:
    * A unique 16-bit binary code is assigned to each word in the uncompressed file.
    * The code size is fixed at 16 bits, allowing encoding of up to 65,536 unique words.
    * The uncompressed file contains Unicode characters (16 bits per character).
    * The dictionary is stored in a text file called "dictionary.txt," with binary codes starting from 0x0000.
    * Initially, the dictionary is empty and is populated as more compression operations are performed.
    * The tool is case-sensitive, treating words like "project" and "Project" as distinct.
    * Special characters (e.g., spaces, punctuation marks) are also assigned codes in the dictionary.
  
2) Example:
   * An example is provided where a text is compressed, and the corresponding dictionary and compressed file are shown.
   * Compression ratio is calculated as the uncompressed file size divided by the compressed file size.

3) Program Menu (Program Usage Flow):
   * The program presents a menu in an infinite loop.
   * It checks if the "dictionary.txt" file exists and, if not, creates an empty one.
   * The user can choose between compression, decompression, or quitting.
     
4) In Compression:
   * The user provides the path to the file to be compressed.
   * The program compresses the file, adding new words to the dictionary as needed.
   * It computes and displays the compression ratio.
   * The compressed data is saved in a compressed file.
   * Changes to the dictionary are saved.
      
5) In Decompression:
    * The user provides the path to the file to be decompressed.
    * The program checks for codes not present in the dictionary and handles errors.
    * It decompresses the file and saves the result in an uncompressed file.

## Summary
This project aims to create a dictionary-based compression and decompression tool in MIPS assembly language, offering users the ability to compress and decompress text files while maintaining a dictionary of words and their corresponding binary codes.

## Result 

<div>
  <img src ="https://github.com/maha123m/ENCS4370-Computer-Architecture-Project-1/assets/99613493/1b623321-80bb-4940-b9ef-241140b75f41" width="900" height="400"> 
</div>

