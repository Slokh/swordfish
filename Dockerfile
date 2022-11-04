FROM golang:latest

COPY . .

# Install Foundry
RUN curl -L https://foundry.paradigm.xyz | bash
RUN ~/.foundry/bin/foundryup

CMD [ "go", "run", "main.go"]