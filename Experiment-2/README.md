# Experiment 2:  Generate SHA-256 Hash and Verify Data intergrity
EXPERIMENT 2: GENERATE SHA-256 HASH AND VERIFY DATA INTEGRITY
1. Aim / Objective

To use hashing techniques to generate secure SHA-256 hashes to verify data integrity and detect tampering.

This is taken directly from the Experiment 2 description in your syllabus.

2. Brief Theory

SHA-256:
SHA-256 (Secure Hash Algorithm 256-bit) is a cryptographic hash function that converts input data of any length into a fixed 256-bit (64 hexadecimal character) hash value.

Hashing:
Hashing is a one-way process that converts data into a fixed-length digital fingerprint. The same input always produces the same hash, while a small change in the input produces a different hash.

Data Integrity:
Data integrity ensures that data has not been altered or tampered with. It can be verified by comparing the current hash of the data with a trusted reference hash.

3. Methodology / Procedure
Create sample.txt with the original text “Network Security is important.”
Read the file in binary mode and generate its SHA-256 hash using Python's hashlib module.
Store the original hash as the trusted reference hash and verify that the original file produces a MATCH.
Modify one character in the file by changing “important” to “Important”.
Generate the SHA-256 hash of the modified file and compare it with the trusted hash.
Report MATCH/MISMATCH to detect whether the file was changed.
Compare the original and modified hashes character by character and count the differing hash characters.

This follows the faculty's seven-stage workflow of creating the file, hashing, recording the digest, tampering, verifying, and analyzing the result.

4. Result

The original file produced a 64-character SHA-256 hash and returned MATCH before modification. After changing only one character, the verification returned MISMATCH, and 59 out of 64 (92.19%) hexadecimal hash characters changed.

Detailed outputs and screenshots can be viewed by scanning the QR code below.

Your actual output:
Original: f32ae5557549491c671874b08fae4ba1211aa670e1adf4e86046b8094475b16d
Before change: True

Modified: 6e9fcfd7ae725c842a3724bcab5f82ee849549064456fac1509a01b2574ac99d
After change: False

Different hash characters: 59 out of 64

The faculty PPT also uses the same original and modified text and demonstrates the resulting different digests.

5. Discussion

The original file produced a MATCH, while changing only one character resulted in a MISMATCH. The comparison showed that 59 of 64 hash characters changed, demonstrating the change-sensitive nature of SHA-256. Thus, the hash can be used to detect data modification, provided the reference hash is trusted.

6. Improvements

Added a compare_hashes() function that compares the original and modified SHA-256 hashes character by character and reports the number of differing hexadecimal characters. This provides an additional measure of how significantly the hash changes after data modification.

7. Conclusion

SHA-256 hashing was used to verify data integrity, and the change in the hash after a single-character modification demonstrated its effectiveness in detecting tampering.
