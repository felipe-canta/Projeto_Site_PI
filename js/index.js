function entrar() {
  const email = document.getElementById("email").value;
  const senha = document.getElementById("senha").value;

  fetch("http://localhost:3000/login", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({ email, senha }),
  })
    .then((response) => response.json())
    .then((data) => {
      const msgError = document.getElementById("msgError");

      if (data.msg === "Login bem-sucedido!") {
        msgError.style.color = "green";
        msgError.textContent = data.msg;
        window.location.href = "./home.html"; // Redireciona ao sucesso
      } else {
        msgError.style.color = "red";
        msgError.textContent = data.msg;
      }
    })
    .catch((error) => {
      console.error("Erro ao conectar com o servidor:", error);
    });
}
