# Invoicer

TODO: Return total amounts in float or decimal format

Simple invoice calculator with a special emphasis on rounding

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'invoicer', git: 'https://github.com/uncoder/invoicer.git'
```

And then execute:

    $ bundle

## Usage

```ruby
items = [
  { article: 'PRINGLES CEBOLLA 190 GR', qty: 2, unitary_amount: 1.7364, vat: 10 },
  { article: 'BARRITAS HUESITOS PACK 12X20GR', qty: 1, unitary_amount: 2.3000, vat: 10 },
  { article: 'COOKIE AVELL CHOC CARREF 200G', qty: 2, unitary_amount: 0.7364, vat: 10 },
  { article: 'G.SANDW.YOGUR DIET NAT.GUL220G', qty: 1, unitary_amount: 1.7273, vat: 10 },
  { article: 'BARRITA TWIX 6 UNDS X 58 GR', qty: 2, unitary_amount: 2.5455, vat: 10 },
  { article: 'CHOC.SNICKERS 4X 50 GRS', qty: 1, unitary_amount: 1.7909, vat: 10 },
  { article: 'PASTAS DE TE DELITEA 400 GR', qty: 1, unitary_amount: 1.7909, vat: 10 },
  { article: 'TE FRUTAS DEL BOSQUE LIPTON 20', qty: 1, unitary_amount: 1.7727, vat: 10 },
  { article: 'PALMERITAS EL PONTON 380 GRS', qty: 2, unitary_amount: 2.5455, vat: 10 },
  { article: 'CHEETOS STICKS 96 GRS', qty: 2, unitary_amount: 1.0727, vat: 10 },
  { article: 'CHEETOS RIZOS 125GR', qty: 2, unitary_amount: 1.4909, vat: 10 },
  { article: 'CHEETOS CRUNCHETOS 130 GRS', qty: 2, unitary_amount: 1.0182, vat: 10 },
  { article: 'TUC QUESO 100 GRS', qty: 2, unitary_amount: 1.0000, vat: 10 },
  { article: 'TUC CREAM&ONION 100 GRS', qty: 2, unitary_amount: 1.0000, vat: 10 },
  { article: 'ENERG.MONSTER ZERO 500ML', qty: 5, unitary_amount: 0.5091, vat: 10 },
  { article: 'ENERG.MONSTER ZERO 500ML', qty: 5, unitary_amount: 1.0364, vat: 10 },
  { article: 'CROISSANT CACAO CASADO 360G', qty: 2, unitary_amount: 1.1727, vat: 10 },
  { article: 'ALMENDRA TOSTAD.COMUN CRF 200G', qty: 1, unitary_amount: 2.5455, vat: 10 },
  { article: 'SNATTS PIPAS 4X40 GR', qty: 1, unitary_amount: 1.9091, vat: 10 },
  { article: 'TORTITAS MAIZ OLIVAS/CEBOLLINO', qty: 1, unitary_amount: 1.6545, vat: 10 },
  { article: 'TORTITA MAIZ QUESO&ALBAHACA124', qty: 1, unitary_amount: 1.6727, vat: 10 },
  { article: 'ENERGETICO RED BULL 25 CL P-8', qty: 3, unitary_amount: 6.6455, vat: 10 },
  { article: '20 CUCHA TRANSPARENTES API CA', qty: 2, unitary_amount: 0.8182, vat: 21 },
  { article: 'AZUCAR BLANCA AZUCARERA 1,5 KG', qty: 1, unitary_amount: 0.9727, vat: 10 },
  { article: 'GOMINOLA HARIBO OSITO ORO 275G', qty: 1, unitary_amount: 2.0818, vat: 10 },
  { article: 'PRINGLES XTRA BARBACOA 175G', qty: 1, unitary_amount: 1.8636, vat: 10 },
  { article: 'PRINGLES ORIGINAL 190 GR', qty: 2, unitary_amount: 1.7364, vat: 10 },
  { article: 'CAFE INTENSO CRF CAPSULAS 30UD', qty: 1, unitary_amount: 4.9091, vat: 10 },
  { article: 'CAFE EXTRAFUERTE CRF CAPS 30UD', qty: 1, unitary_amount: 4.9091, vat: 10 },
  { article: 'CAFE SUAVE CRF CAPSULAS 30UDS', qty: 1, unitary_amount: 4.9091, vat: 10 },
  { article: 'TORTITA ARR C/CHO BICEN 210 G', qty: 1, unitary_amount: 1.7273, vat: 10 },
  { article: 'GASTOS DE ENVIO', qty: 1, unitary_amount: 4.9587, vat: 21 }
]

invoicer = Invoicer.define do
  add_items items, unit_amount: :unitary_amount, qty: :qty, vat: :vat
end

invoicer.calculate

#invoicer.group_totals
{
  10 => {
    :amount => "98.31",
    :vat_amount => "9.83",
    :total_amount => "108.14"
  },
  21 => {
    :amount => "6.59",
    :vat_amount => "1.39",
    :total_amount => "7.98"
  }
}

#invoicer.invoice_totals
{
  :amount => "104.90",
  :vat_amount => "11.22",
  :total_amount => "116.12"
}
```
