from flask import Flask, jsonify

app = Flask(__name__)

@app.route("/")
def home():
    return jsonify({"message": "Welcome to OpsPilot!"})

@app.route("/health")
def health():
    return jsonify({"status": "Healthy"})

@app.route("/info")
def info():
    return jsonify({
        "app": "OpsPilot",
        "version": "1.0",
        "purpose": "DevOps Learning Project"
    })

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
