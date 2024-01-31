
FROM python:3.8

WORKDIR /app

# We copy just the requirements.txt first to leverage Docker cache
COPY requirements.txt requirements.txt
RUN pip3 install --no-cache-dir -r requirements.txt

# Copy all code files to working dir
COPY . .

EXPOSE 5000

# Start the main process.
CMD ["python3", "-m" , "flask", "run", "--host=0.0.0.0"]
