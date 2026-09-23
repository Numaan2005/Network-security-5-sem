#!/bin/bash

# Experiment 4: X.509 Self-Signed Digital Certificate
# This file contains the OpenSSL commands used during the experiment
# with comments explaining the purpose of each command.

# --------------------------------------------------
# 1. Check the installed OpenSSL version
# --------------------------------------------------
# Verifies that OpenSSL is installed and available.
openssl version


# --------------------------------------------------
# 2. Create and enter the working directory
# --------------------------------------------------
# Creates a separate directory for the X.509 certificate experiment.
mkdir x509_lab
cd x509_lab

# Lists the contents of the directory to confirm it is empty.
ls


# --------------------------------------------------
# 3. Generate a 2048-bit RSA private key
# --------------------------------------------------
# Generates the private key that will be used to create
# the self-signed X.509 certificate.
openssl genpkey -algorithm RSA -out tanish.key -pkeyopt rsa_keygen_bits:2048

# Displays the generated private-key file and its permissions.
ls -l


# --------------------------------------------------
# 4. Validate the generated private key
# --------------------------------------------------
# Checks whether the RSA private key is valid.
openssl pkey -in tanish.key -check -noout


# --------------------------------------------------
# 5. Generate the self-signed X.509 certificate
# --------------------------------------------------
# Creates a certificate using the private key.
# The certificate is valid for 365 days and uses SHA-256.
# Subject Alternative Name, CA constraint, key usage,
# and extended key usage are also configured.
openssl req -new -x509 -sha256 \
-key tanish.key -out certificate.crt -days 365 \
-subj "/C=IN/ST=Jammu/L=Jammu/O=MIET/OU=CSE/CN=localhost" \
-addext "subjectAltName=DNS:localhost,IP:127.0.0.1" \
-addext "basicConstraints=critical,CA:FALSE" \
-addext "keyUsage=critical,digitalSignature,keyEncipherment" \
-addext "extendedKeyUsage=serverAuth"

# Displays the generated certificate and private-key files.
ls -l


# --------------------------------------------------
# 6. Inspect the complete certificate
# --------------------------------------------------
# Displays detailed information about the certificate,
# including version, issuer, subject, validity, public key,
# extensions, and signature.
openssl x509 -in certificate.crt -text -noout


# --------------------------------------------------
# 7. Display important certificate information
# --------------------------------------------------
# Displays the subject, issuer, validity dates, and serial number.
openssl x509 -in certificate.crt -noout \
-subject -issuer -dates -serial


# --------------------------------------------------
# 8. Display important certificate extensions
# --------------------------------------------------
# Displays the Subject Alternative Name, Basic Constraints,
# Key Usage, and Extended Key Usage extensions.
openssl x509 -in certificate.crt -noout \
-ext subjectAltName,basicConstraints,keyUsage,extendedKeyUsage


# --------------------------------------------------
# 9. Generate the SHA-256 certificate fingerprint
# --------------------------------------------------
# Generates a SHA-256 fingerprint used to identify the certificate.
openssl x509 -in certificate.crt \
-noout -fingerprint -sha256


# --------------------------------------------------
# 10. Verify the certificate without explicitly trusting it
# --------------------------------------------------
# Attempts normal certificate verification.
# Since the certificate is self-signed and not part of a trusted
# certificate chain, verification is expected to fail.
openssl verify certificate.crt


# --------------------------------------------------
# 11. Verify the certificate using itself as a trusted CA
# --------------------------------------------------
# Explicitly treats certificate.crt as a trusted certificate
# for this local verification test.
openssl verify -CAfile certificate.crt certificate.crt


# --------------------------------------------------
# 12. Generate SHA-256 digest of the private key's public key
# --------------------------------------------------
# Extracts the public key from the private key and generates
# a SHA-256 digest for comparison with the certificate public key.
openssl pkey -in tanish.key -pubout -outform DER 2>/dev/null \
| openssl dgst -sha256


# --------------------------------------------------
# 13. Generate SHA-256 digest of the certificate's public key
# --------------------------------------------------
# Extracts the public key from the certificate and generates
# a SHA-256 digest for comparison with the private-key result.
openssl x509 -in certificate.crt -pubkey -noout \
| openssl pkey -pubin -outform DER 2>/dev/null \
| openssl dgst -sha256
