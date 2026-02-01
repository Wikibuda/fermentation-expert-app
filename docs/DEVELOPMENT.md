# Development Guide

## Getting Started

### Prerequisites
- Python 3.8+
- Git
- Text editor/IDE
- Modern web browser

### Initial Setup
\`\`\`bash
# Clone repository
git clone https://github.com/yourusername/fermentation-expert-app.git
cd fermentation-expert-app

# Setup environment
python3 -m venv venv
source venv/bin/activate  # Linux/Mac
pip install -r requirements.txt
\`\`\`

## Development Workflow

### Branch Strategy
- \`main\` - Production-ready code
- \`develop\` - Integration branch
- \`feature/*\` - New features
- \`bugfix/*\` - Bug fixes

### Testing
\`\`\`bash
# Run tests
python -m pytest tests/ -v

# Check code quality
flake8 .
black --check .
\`\`\`
