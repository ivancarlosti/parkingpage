<?php
// Read environment variables or set default values
$logoUrl = getenv('LOGO_URL') ?: 'logo.png';
$title = getenv('TITLE') ?: 'Landing Page';
$subtext = getenv('SUBTEXT') ?: '- em construção -';
$email = getenv('EMAIL') ?: 'email@example.com';
$phone = getenv('PHONE') ?: '+55 11 98765-4321';
$whatsappLink = getenv('WHATSAPP_LINK') ?: 'https://wa.me/5511987654321';
$creditLogoUrl = getenv('CREDIT_LOGO_URL') ?: 'https://s3.sa-east-1.amazonaws.com/envio.icc.gg/seeig5j8jnoc.png';
$creditLink = getenv('CREDIT_LINK') ?: 'https://ivancarlos.com.br/';
?>
<!DOCTYPE html>
<html lang="pt-br">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
<title><?= htmlspecialchars($title) ?></title>
<link rel="icon" type="image/png" href="/favicon-96x96.png" sizes="96x96" />
<link rel="icon" type="image/svg+xml" href="/favicon.svg" />
<link rel="shortcut icon" href="/favicon.ico" />
<link rel="apple-touch-icon" sizes="180x180" href="/apple-touch-icon.png" />
<meta name="apple-mobile-web-app-title" content="<?= htmlspecialchars($title) ?>" />
<style>
body {
  margin: 0;
  font-family: 'Segoe UI', sans-serif;
  background-color: #121212;
  color: #f0f0f0;
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100vh;
  position: relative;
}
.container {
  max-width: 600px;
  width: 90%;
  background-color: #1e1e1e;
  border-radius: 12px;
  padding: 2rem;
  text-align: center;
  box-shadow: 0 0 20px rgba(0,0,0,0.5);
}
.logo {
  width: 300px;
  height: 200px;
  margin: 0 auto 1.5rem;
  background-image: url('<?= htmlspecialchars($logoUrl) ?>');
  background-size: contain;
  background-repeat: no-repeat;
  background-position: center;
  border-radius: 8px;
}
h1 {
  margin: 0.5rem 0;
  font-size: 2rem;
  color: #ffffff;
}
p {
  margin: 0.5rem 0 1.5rem;
  color: #bbbbbb;
  font-size: 1rem;
}
.contact {
  font-size: 1.1rem;
  color: #dddddd;
}
.contact a {
  color: #dddddd;
  text-decoration: none;
}
.contact a:hover {
  text-decoration: underline;
}
.contact span {
  display: block;
  margin-bottom: 0.5rem;
}
.credit-logo {
  position: fixed;
  bottom: 10px;
  right: 10px;
}
.credit-logo img {
  width: 16px;
  height: 16px;
  opacity: 0.6;
  transition: opacity 0.2s;
}
.credit-logo img:hover {
  opacity: 1;
}
@media (max-width: 480px) {
  .logo {
    width: 100%;
    height: 150px;
  }
  h1 {
    font-size: 1.5rem;
  }
}
</style>
</head>
<body>
<div class="container">
  <div class="logo"></div>
  <!-- Uncomment below line to display title -->
  <!-- <h1><?= htmlspecialchars($title) ?></h1> -->
  <p><?= htmlspecialchars($subtext) ?></p>
  <div class="contact">
    <span>📧 <a href="mailto:<?= htmlspecialchars($email) ?>"><?= htmlspecialchars($email) ?></a></span>
    <span>📞 <a href="<?= htmlspecialchars($whatsappLink) ?>" target="_blank" rel="noopener noreferrer"><?= htmlspecialchars($phone) ?></a></span>
  </div>
</div>
<a href="<?= htmlspecialchars($creditLink) ?>" target="_blank" class="credit-logo" aria-label="Site de Ivan Carlos" rel="noopener noreferrer">
  <img src="<?= htmlspecialchars($creditLogoUrl) ?>" alt="Ivan Carlos Logo" />
</a>
</body>
</html>
