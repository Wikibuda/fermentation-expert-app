# API Documentation

## DeepSeek API Integration

### Authentication
\`\`\`python
import os
import requests

API_KEY = os.getenv('DEEPSEEK_API_KEY')
HEADERS = {
    'Authorization': f'Bearer {API_KEY}',
    'Content-Type': 'application/json'
}
\`\`\`

### Basic Request
\`\`\`python
def query_deepseek(prompt, max_tokens=1000):
    url = 'https://api.deepseek.com/v1/chat/completions'
    
    data = {
        'model': 'deepseek-chat',
        'messages': [{'role': 'user', 'content': prompt}],
        'max_tokens': max_tokens
    }
    
    try:
        response = requests.post(url, json=data, headers=HEADERS, timeout=30)
        return response.json()
    except Exception as e:
        print(f'Error: {e}')
        return None
\`\`\`
