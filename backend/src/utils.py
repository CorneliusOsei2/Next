import json

# Response Handler
def response(res={}, success = True, code = 200):
    if success: return json.dumps(res), code
    return json.dumps({"error": res}), code


def extract_token(request):
    """
    Helper to extract token from header of request.
    """
    auth_header = request.headers.get("Authorization")

    if auth_header is None:
        return False, response("Missing Authorization header", success=False, code=400)
    
    bearer_token = auth_header.replace("Bearer", "").strip()
    return True, bearer_token

