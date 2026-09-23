
# Check that the original files exist
if [ ! -f "tanish.key" ] || [ ! -f "certificate.crt" ]; then
    echo "[ERROR] tanish.key or certificate.crt not found."
    exit 1
fi

echo "[1] Generating a separate test RSA private key..."
openssl genpkey -algorithm RSA \
    -out mismatch.key \
    -pkeyopt rsa_keygen_bits:2048 2>/dev/null

if [ $? -ne 0 ]; then
    echo "[ERROR] Failed to generate test key."
    exit 1
fi

echo "[OK] Separate test key generated."
echo

echo "[2] Calculating public-key hash from original private key..."
original_hash=$(openssl pkey -in tanish.key -pubout -outform DER 2>/dev/null \
    | openssl dgst -sha256 \
    | awk '{print $2}')

echo "Original key hash:"
echo "$original_hash"
echo

echo "[3] Calculating public-key hash from unrelated test key..."
test_hash=$(openssl pkey -in mismatch.key -pubout -outform DER 2>/dev/null \
    | openssl dgst -sha256 \
    | awk '{print $2}')

echo "Unrelated key hash:"
echo "$test_hash"
echo

echo "[4] Calculating public-key hash from certificate..."
certificate_hash=$(openssl x509 -in certificate.crt -pubkey -noout 2>/dev/null \
    | openssl pkey -pubin -outform DER 2>/dev/null \
    | openssl dgst -sha256 \
    | awk '{print $2}')

echo "Certificate public-key hash:"
echo "$certificate_hash"
echo

echo "========================================"
echo " Results"
echo "========================================"

if [ "$original_hash" = "$certificate_hash" ]; then
    echo "[PASS] Original private key matches certificate."
else
    echo "[FAIL] Original private key does NOT match certificate."
fi

if [ "$test_hash" != "$certificate_hash" ]; then
    echo "[PASS] Unrelated private key does NOT match certificate."
else
    echo "[FAIL] Unexpected match."
fi

echo
echo "Negative test completed."
echo "========================================"
