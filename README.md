# 📚 LangChain BookBot

A semantic book recommendation system powered by [LangChain](https://www.langchain.com/), [OpenAI](https://openai.com/), and [Gradio](https://gradio.app/).

## 🚀 Features

- Natural Language Book Search using LLMs
- Personalized recommendations with vector embeddings
- Gradio-powered UI
- Easily extendable with RAG pipelines and LangChain agents

## Project Structure

```text
langchain-bookbot/               # GitHub root
├── langchain_bookbot/           # Importable Python package
│   ├── __init__.py
│   ├── app.py
│   ├── recommender.py
│   └── utils.py
├── README.md
├── pyproject.toml
├── .gitignore
└── requirements.txt (optional)
```

## 📦 Installation

```bash
git clone https://github.com/your-org/langchain-bookbot.git
cd langchain-bookbot
python3.10 -m venv .venv
source .venv/bin/activate
pip install -e ".[dev]"
```
