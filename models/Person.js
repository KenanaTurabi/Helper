const mongoose=require('mongoose');
const Schema = mongoose.Schema;
const personSchema=new Schema({
   name:String,
   id:Number,
   email:String,
   FullAddress:String,
   gender:String,
   age: Number,
   image: String,
   mobileNumber:Number,
});
const Person=mongoose.model('Person',personSchema);
module.exports=Person;
