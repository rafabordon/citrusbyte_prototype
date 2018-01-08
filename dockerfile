FROM alpine:3.7

# Update Python
RUN apk add --update python py-pip

# Dependencies
RUN pip install FLASK

# App source
COPY webapp.py /src/webapp.py

# Port opening
EXPOSE 5555

# Run app
CMD ["python", "/src/webapp.py"]

