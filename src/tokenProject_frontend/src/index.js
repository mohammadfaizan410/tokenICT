import { tokenProject_backend } from "../../declarations/tokenProject_backend";
import { Principal } from "@dfinity/principal";

$("#balanceBtn").click(async function (e) { 
  $("#balanceError").text("");
  const principalID = $("#principal").val();
  if (principalID === "") {
    $("#balanceError").text("Please enter a princial id!");
    $("#principal").val("");
  }
  else {
    const balance = await tokenProject_backend.balanceOf(Principal.fromText(principalID));
    if (balance === null) {
      $("#balanceShow").text("Your balance is 0");
    }
    else {
      console.log(balance)
      $("#balanceShow").text("Your balance is " + balance.toLocaleString() + "FIZZ");
    }
    $("#principal").val("");
  }
  
});

$("#faucetBtn").click(async function (e) { 
  e.preventDefault();
  $('#faucetBtn').prop('disabled', true);
  const result = await tokenProject_backend.payFree();
  console.log(result)
  $("#faucetResult").text(result.toLocaleString());
});

$("#balanceTransfer").click(async function (e) {
  e.preventDefault();
  $("#transferError").text("");
  const id = $("#transferID").val();
  const amount = $("#transferAmount").val();
  if (id == "" || amount == "") {
    $("#transferError").text("id or amount cannot be empty");
  }
  else {
    $("#transferID").val("");
    $("#transferAmount").val("");
    const result = await tokenProject_backend.tranfer(Principal.fromText(id), Number(amount));
    $("#transferResult").text(result.toLocaleString());
  }
});