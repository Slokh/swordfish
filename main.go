package main

import (
	"encoding/json"
	"errors"
	"fmt"
	"log"
	"net/http"
	"os"
	"os/exec"
	"strings"
)

type ValidationRequest struct {
	RpcUrl          string `json:"rpcUrl"`
	ContractAddress string `json:"contractAddress"`
	TokenId         string `json:"tokenId"`
}

type ValidationResponse struct {
	Valid bool `json:"valid"`
}

func validate(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		w.WriteHeader(http.StatusMethodNotAllowed)
		return
	}

	if r.Header.Get("Content-Type") != "application/json" {
		w.WriteHeader(http.StatusUnsupportedMediaType)
		return
	}

	decoder := json.NewDecoder(r.Body)
	var req ValidationRequest
	err := decoder.Decode(&req)
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		return
	}

	out, err := exec.Command("./validate.sh", req.RpcUrl, req.ContractAddress, req.TokenId).Output()
	if err != nil {
		log.Fatal(err)
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(ValidationResponse{Valid: strings.TrimSpace(string(out)) == "1"})
}

func main() {
	http.HandleFunc("/validate", validate)
	err := http.ListenAndServe(":5000", nil)
	fmt.Println("running on port 5000")
	if errors.Is(err, http.ErrServerClosed) {
		fmt.Printf("server closed\n")
	} else if err != nil {
		fmt.Printf("error starting server: %s\n", err)
		os.Exit(1)
	}
}
