# STAGE 1: Build the application
FROM python:3.12-slim AS builder

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir --upgrade -r requirements.txt

COPY . .

# STAGE 2: Create the final image
FROM python:3.12-slim

WORKDIR /app

# Copy only the necessary files from the builder stage like the installed python packages in lib/python_version, executable binaries in bin and the application code in /app
COPY --from=builder /usr/local/lib/python3.12 /usr/local/lib/python3.12
COPY --from=builder /usr/local/bin /usr/local/bin

COPY --from=builder /app /app

EXPOSE 8000

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]