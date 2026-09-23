# Experiment 3: Simulate User Authentication and Replay Attack Handling Using Challenge-Response Protocol

## Objective

To develop a basic challenge-response authentication system to validate user identity and simulate replay attack detection.

## Brief Theory

### Challenge-Response Authentication

An authentication method in which the system sends a unique challenge, and the user generates a valid response using a shared secret.

### Nonce

A randomly generated value used only once during authentication to make each challenge unique and prevent replay attacks.

### HMAC

Hash-based Message Authentication Code (HMAC) uses a secret key with a hash function to verify the integrity and authenticity of a message.

### Replay Attack

An attack in which an attacker captures a valid authentication response and retransmits it to gain unauthorized access.

## Procedure

1. **Initialize the shared secret:** A common secret key is defined between the user and authentication system.

2. **Generate a challenge:** When authentication starts, a random 16-byte hexadecimal nonce is generated using the `secrets` module. The username and challenge timestamp are stored.

3. **Create the authentication response:** The username, nonce, and timestamp are combined into a message. HMAC-SHA256 is generated using the shared secret.

4. **Send the response:** The response consists of the username, nonce, timestamp, and HMAC tag.

5. **Verify the response:** The system checks whether the nonce has already been used, verifies that it belongs to the correct username, checks whether the timestamp is within the allowed 5-second limit, and compares a newly calculated HMAC with the received HMAC.

6. **Handle replay attacks:** After a nonce is used, it is added to the `used_nonces` set. If the same nonce is submitted again, the system identifies it as a replay attack.

7. **Handle delayed responses:** If the response is older than 5 seconds, it is rejected as an expired response.

8. **Apply the improvement:** A fresh challenge is generated and its HMAC tag is modified before verification. The system compares the modified tag with the expected HMAC and rejects the tampered response.

### Code

[View Replay.py Code](https://github.com/2024A7R019/Network-Security-Lab-5th-Sem/blob/main/Experiment-3/Codes/Replay.py)

### Output

[View Replay Attack Handling Output](https://github.com/2024A7R019/Network-Security-Lab-5th-Sem/raw/main/Experiment-3/Outputs/replay.png)

![Replay Attack Handling Output](https://github.com/2024A7R019/Network-Security-Lab-5th-Sem/raw/main/Experiment-3/Outputs/replay.png)

## Result

The legitimate authentication response was accepted with **"Authentication successful."** Reusing the same nonce was detected as a replay attack and rejected. A response with an older timestamp was rejected as an expired response. Modification of the HMAC tag caused the authentication to fail.

All 4 test cases produced the expected security outcomes, giving a **100% test-case verification rate**.

## Discussion

The legitimate response was accepted, while the replayed nonce, expired response, and modified HMAC were rejected. These results demonstrate how nonce tracking prevents replay, timestamp checking provides freshness, and HMAC verification detects response tampering.

## Improvements

Added an HMAC tampering test that modifies the received authentication tag and verifies that the altered response is rejected, demonstrating the integrity and authenticity protection provided by HMAC.

## Conclusion

The challenge-response mechanism demonstrated user authentication while detecting replay, expired, and tampered responses using nonce, timestamp, and HMAC-based verification.


