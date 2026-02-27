<!DOCTYPE html>
<html lang="fa" dir="rtl">
<head>
<meta charset="UTF-8">
<title>فروشگاه عسل بشارت</title>

<meta name="viewport" content="width=device-width, initial-scale=1">

<link href="https://cdn.jsdelivr.net/gh/rastikerdar/vazir-font@v33.0.3/Vazirmatn.css" rel="stylesheet">

<style>

*{
font-family:Vazirmatn,sans-serif;
box-sizing:border-box;
}

body{
background:#f6f6f6;
}

/* NAV */

nav{
display:flex;
justify-content:space-between;
align-items:center;
padding:18px 35px;
background:white;
position:sticky;
top:0;
border-bottom:1px solid #eee;
z-index:1000;
}

nav a{
text-decoration:none;
color:#222;
margin-left:20px;
font-weight:600;
}

/* PRODUCTS */

.products{
display:grid;
grid-template-columns:repeat(auto-fit,minmax(230px,1fr));
gap:25px;
max-width:1100px;
margin:60px auto;
padding:0 20px;
}

.card{
background:white;
padding:18px;
border-radius:22px;
text-align:center;
box-shadow:0 6px 20px rgba(0,0,0,.05);
transition:.3s;
}

.card:hover{
transform:translateY(-5px);
}

.card img{
width:100%;
height:180px;
object-fit:cover;
border-radius:15px;
margin-bottom:12px;
}

.card button{
background:#d4af37;
border:none;
padding:11px;
width:100%;
border-radius:14px;
cursor:pointer;
font-weight:600;
}

/* CART */

#cartBox{
max-width:600px;
margin:60px auto;
background:white;
padding:25px;
border-radius:25px;
box-shadow:0 5px 25px rgba(0,0,0,.06);
}

.cartItem{
display:flex;
justify-content:space-between;
padding:12px 0;
border-bottom:1px solid #eee;
}

.cartItem button{
margin-left:5px;
}

.removeBtn{
background:red;
color:white;
border:none;
padding:5px 10px;
border-radius:8px;
cursor:pointer;
}

.qtyBtn{
background:#4CAF50;
color:white;
border:none;
padding:5px 10px;
border-radius:8px;
cursor:pointer;
}

/* FORM */

input,textarea,select{
width:100%;
padding:12px;
margin:8px 0;
border-radius:12px;
border:1px solid #ddd;
}

.sendBtn{
background:#4CAF50;
color:white;
padding:14px;
border:none;
border-radius:14px;
width:100%;
font-size:16px;
cursor:pointer;
}

/* TOAST */

.sideToast{
position:fixed;
right:-400px;
bottom:40px;
background:white;
padding:18px 25px;
border-radius:16px;
box-shadow:0 5px 25px rgba(0,0,0,.2);
z-index:5000;
transition:.5s;
font-weight:600;
}

.sideToast.show{
right:20px;
}

</style>
</head>

<body>

<nav>
<div>
<a href="index.html">🏠 خانه</a>
<a href="شروع_2.html">📞 ارتباط با ما</a>
</div>

<div style="color:#d4af37;font-weight:700;font-size:20px;">
عسل بشارت
</div>
</nav>

<h2 style="text-align:center;margin-top:40px">🛒 محصولات عسل بشارت</h2>

<div class="products" id="products"></div>

<div id="cartBox">

<h2>🛍 سبد خرید</h2>

<div id="cartList"></div>

<h3 id="totalPrice"></h3>

<hr>

<h3>📦 ثبت سفارش</h3>

<input id="name" placeholder="نام و نام خانوادگی">
<input id="phone" placeholder="شماره تماس (11 رقم)">
<textarea id="address" placeholder="آدرس"></textarea>

<label>📅 زمان ارسال</label>

<select id="sendTime">
<option value="40000">8 اسفند - 40 تومان</option>
<option value="60000">9 اسفند - 60 تومان</option>
<option value="80000">10 اسفند - 80 تومان</option>
<option value="100000">11 اسفند - 100 تومان</option>
<option value="120000">12 اسفند - 120 تومان</option>
<option value="90000">13 اسفند - 90 تومان</option>
<option value="70000">14 اسفند - 70 تومان</option>
<option value="50000">15 اسفند - 50 تومان</option>
</select>

<button class="sendBtn" onclick="sendSMS()">
📩 ارسال سفارش
</button>

</div>

<div id="sideToast"></div>

<script>

/* PRODUCTS */

const products=[
{
name:"عسل طبیعی ۵۰۰ گرم",
price:390000,
img:"STOAKS/AKS20.jpg"
},
{
name:"شهد خالص ۱۰۰۰ گرم",
price:890000,
img:"STOAKS/AKS22.jpg"
},
{
name:"ژله رویال",
price:250000,
img:"STOAKS/AKS24.jpg"
},
{
name:"عسل کنار",
price:450000,
img:"STOAKS/AKS23.jpg"
}
];

let cart=[];

/* ADD CART */

function addCart(name,price){

let exist=cart.find(p=>p.name===name);

if(exist){
exist.qty++;
}
else{
cart.push({name,price,qty:1});
}

renderCart();
showToast(name+" ➕ اضافه شد");

}

/* REMOVE */

function removeCart(index){
cart.splice(index,1);
renderCart();
}

/* CHANGE QTY */

function changeQty(index,amount){

cart[index].qty+=amount;

if(cart[index].qty<=0){
cart.splice(index,1);
}

renderCart();
}

/* RENDER PRODUCTS */

function renderProducts(){

let html="";

products.forEach(p=>{

html+=`
<div class="card">

<img src="${p.img}">

<h4>${p.name}</h4>

<p style="color:#d4af37;font-weight:bold">
${p.price.toLocaleString('fa-IR')} تومان
</p>

<button onclick="addCart('${p.name}',${p.price})">
➕ افزودن به سبد
</button>

</div>
`;

});

document.getElementById("products").innerHTML=html;
}

/* CART RENDER */

function renderCart(){

let html="";
let total=0;

cart.forEach((item,index)=>{

let price=item.price*item.qty;
total+=price;

html+=`
<div class="cartItem">

<span>
${item.name} × ${item.qty}
<br>
${price.toLocaleString('fa-IR')} تومان
</span>

<div>
<button class="qtyBtn" onclick="changeQty(${index},1)">➕</button>
<button class="qtyBtn" onclick="changeQty(${index},-1)">➖</button>
<button class="removeBtn" onclick="removeCart(${index})">❌</button>
</div>

</div>
`;
});

document.getElementById("cartList").innerHTML=
html || "<p>سبد خرید خالی است</p>";

document.getElementById("totalPrice").innerText=
"جمع محصولات: "+total.toLocaleString('fa-IR')+" تومان";

}

/* TOAST */

function showToast(msg){

let toast=document.getElementById("sideToast");

toast.innerHTML=msg;
toast.classList.add("show");

setTimeout(()=>{
toast.classList.remove("show");
},3500);

}

/* PHONE CHECK */

function checkPhone(phone){
return phone.length<=11;
}

/* RANDOM CODE */

function randomCode(){
return Math.floor(Math.random()*90000)+10000;
}

/* SEND SMS */

function sendSMS(){

if(cart.length==0){
alert("سبد خرید خالی است");
return;
}

let name=document.getElementById("name").value;
let phone=document.getElementById("phone").value;
let address=document.getElementById("address").value;

if(!name || !phone){
alert("نام و شماره را وارد کنید");
return;
}

if(!checkPhone(phone)){
alert("شماره نباید بیشتر از 11 رقم باشد");
return;
}

let code=randomCode();

let msg="\nکد پیگیری سفارش: "+code+"\n\n";

msg+="نام: "+name+"\n";
msg+="شماره: "+phone+"\n";
msg+="آدرس: "+address+"\n\n";

let productTotal=0;

msg+="محصولات:\n";

cart.forEach(p=>{
msg+=p.name+" - "+p.price+" تومان × "+p.qty+"\n";
productTotal+=p.price*p.qty;
});

let sendPrice=parseInt(document.getElementById("sendTime").value);

let totalPrice=productTotal+sendPrice;

msg+="\nهزینه ارسال: "+sendPrice+" تومان";
msg+="\nجمع کل: "+totalPrice.toLocaleString('fa-IR')+" تومان";

msg+="\n\nتا 1 تا 5 ساعت آینده پاسخ داده می شود.";

if(/Mobi|Android/i.test(navigator.userAgent)){
window.location.href="sms:0914549172?body="+encodeURIComponent(msg);
}else{
alert("⚠ ارسال SMS فقط روی موبایل امکان پذیر است");
}

}

/* START */

renderProducts();
renderCart();

</script>

</body>
</html>
