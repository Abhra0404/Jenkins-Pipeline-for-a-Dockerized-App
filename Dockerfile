FROM python:3.9-slim

WORKDIR /app

ENV PIP_DISABLE_PIP_VERSION_CHECK=1

COPY requirements.txt .
RUN python -m pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 5000

CMD ["python", "app.py"]