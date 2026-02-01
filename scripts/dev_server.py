#!/usr/bin/env python3
"""Development server for Fermentation Expert App"""

import http.server
import socketserver
import os

PORT = 8000

def main():
    os.chdir('.')
    with socketserver.TCPServer(("", PORT), http.server.SimpleHTTPRequestHandler) as httpd:
        print(f"Server running at http://localhost:{PORT}")
        print("Press Ctrl+C to stop")
        httpd.serve_forever()

if __name__ == "__main__":
    main()
