# Experiment 2: Generate SHA-256 Hash and Verify Data Integrity

## Objective

To use hashing techniques to generate secure SHA-256 hashes to verify data integrity and detect tampering.

## Brief Theory

### SHA-256

SHA-256 (Secure Hash Algorithm 256-bit) is a cryptographic hash function that converts input data of any length into a fixed 256-bit (64 hexadecimal character) hash value.

### Hashing

Hashing is a one-way process that converts data into a fixed-length digital fingerprint. The same input always produces the same hash, while a small change in the input produces a different hash.

### Data Integrity

Data integrity ensures that data has not been altered or tampered with. It can be verified by comparing the current hash of the data with a trusted reference hash.

## Procedure

1. Create `sample.txt` with the original text **"Network Security is important."**

2. Read the file in binary mode and generate its SHA-256 hash using Python's `hashlib` module.

3. Store the original hash as the trusted reference hash and verify that the original file produces a **MATCH**.

4. Modify one character in the file by changing **"important"** to **"Important"**.

5. Generate the SHA-256 hash of the modified file and compare it with the trusted hash to detect whether the file was changed.

6. Compare the original and modified hashes character by character and count the differing hash characters.

   [View Sha256_hash.py](Codes/Sha256_hash.py)

   ![sha256.jpeg](/Output/sha256.jpeg)

## Result

The original file produced a 64-character SHA-256 hash and returned **MATCH** before modification. After changing only one character, the verification returned **MISMATCH**, and **59 out of 64 (92.19%)** hexadecimal hash characters changed.

## Discussion

The original file produced a **MATCH**, while changing only one character resulted in a **MISMATCH**. The comparison showed that 59 of 64 hash characters changed, demonstrating the change-sensitive nature of SHA-256. Thus, the hash can be used to detect data modification, provided the reference hash is trusted.

## Improvements

Added a `compare_hashes()` function that compares the original and modified SHA-256 hashes character by character and reports the number of differing hexadecimal characters. This provides an additional measure of how significantly the hash changes after data modification.

## Conclusion

SHA-256 hashing was used to verify data integrity, and the change in the hash after a single-character modification demonstrated its effectiveness in detecting tampering.
