# Start from a small official Python image
FROM python:3.11-slim

# Set the working directory inside the container
WORKDIR /app

# Install uv (the package manager this project uses)
RUN pip install uv

# Copy dependency files first (Docker caches this layer if they don't change)
COPY pyproject.toml uv.lock ./
RUN uv sync --frozen

# Now copy the rest of the app code
COPY python/ ./python/

# Tell Docker the container listens on port 5000
EXPOSE 5000

# The command that runs when the container starts
CMD ["uv", "run", "flask", "--app", "python/app.py", "run", "--host=0.0.0.0"]
