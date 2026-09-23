import hashlib
import hmac
import secrets
import time

SHARED_SECRET = b"network_secret_key"
MAX_AGE_SECONDS = 5
pending_challenges = {}
used_nonces = set()

def issue_challenge(username):
    nonce = secrets.token_hex(16)
    pending_challenges[nonce] = (username, time.time())
    return nonce

def create_response(username, nonce, timestamp=None):
    if timestamp is None:
        timestamp = int(time.time())
    message = f"{username}:{nonce}:{timestamp}".encode("utf-8")
    tag = hmac.new(SHARED_SECRET, message, hashlib.sha256).hexdigest()
    return timestamp, tag

def verify_response(username, nonce, timestamp, received_tag):
    if nonce in used_nonces:
        return False, "Replay detected: nonce already used"
    challenge = pending_challenges.get(nonce)
    if challenge is None or challenge[0] != username:
        return False, "Unknown challenge"
    if abs(time.time() - timestamp) > MAX_AGE_SECONDS:
        pending_challenges.pop(nonce, None)
        used_nonces.add(nonce)
        return False, "Expired response"
    message = f"{username}:{nonce}:{timestamp}".encode("utf-8")
    expected = hmac.new(SHARED_SECRET, message, hashlib.sha256).hexdigest()
    valid = hmac.compare_digest(received_tag, expected)
    pending_challenges.pop(nonce, None)
    used_nonces.add(nonce)
    return valid, "Authentication successful" if valid else "Failed"

username = "student1"
nonce = issue_challenge(username)
timestamp, tag = create_response(username, nonce)
captured = (username, nonce, timestamp, tag)

print("First use:", verify_response(*captured))
print("Replay:", verify_response(*captured))

delayed_nonce = issue_challenge(username)
delayed_timestamp, delayed_tag = create_response(
    username, delayed_nonce, int(time.time()) - 10
)
delayed = (username, delayed_nonce, delayed_timestamp, delayed_tag)

print("Delayed:", verify_response(*delayed))

# HMAC tampering test
tampered_nonce = issue_challenge(username)
tampered_timestamp, tampered_tag = create_response(username, tampered_nonce)

tampered_tag = "0" + tampered_tag[1:]
tampered = (username, tampered_nonce, tampered_timestamp, tampered_tag)

print("Tampered HMAC:", verify_response(*tampered))
