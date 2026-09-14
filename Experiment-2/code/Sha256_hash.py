import hashlib

def hash_file(filename):
    sha256_hash = hashlib.sha256()

    with open(filename, "rb") as f:
        for block in iter(lambda: f.read(4096), b""):
            sha256_hash.update(block)

    return sha256_hash.hexdigest()


def verify_file(filename, expected_hash):
    current_hash = hash_file(filename)
    return current_hash == expected_hash, current_hash


def hash_string(data):
    return hashlib.sha256(data.encode("utf-8")).hexdigest()


def compare_hashes(hash1, hash2):
    different = 0

    for a, b in zip(hash1, hash2):
        if a != b:
            different += 1

    return different


original_text = "Network Security is important."
modified_text = "Network Security is Important."
filename = "sample.txt"

# 1. Create and hash the original file
with open(filename, "w", encoding="utf-8") as f:
    f.write(original_text)

trusted_hash = hash_file(filename)

print("Original:", trusted_hash)
print("Before change:", verify_file(filename, trusted_hash)[0])

# 2. Modify one character and verify again
with open(filename, "w", encoding="utf-8") as f:
    f.write(modified_text)

modified_hash = hash_file(filename)

print("Modified:", modified_hash)
print("After change:", verify_file(filename, trusted_hash)[0])

# 3. Compare the two hashes
different = compare_hashes(trusted_hash, modified_hash)

print("Different hash characters:", different, "out of 64")
