// This is a test harness for your module
// You should do something interesting in this harness 
// to test out the module and to provide instructions 
// to users on how to use it by example.


// open a single window
var win = Ti.UI.createWindow({
	backgroundColor:'white'
});

// TODO: write your module tests here
var macarnativecode = require('ma.car.nativecode');
Ti.API.info("module is => " + macarnativecode);


//var foo = macarnativecode.createSlideView({
var foo2 = Ti.UI.createView({
  "backgroundColor":"#c0c",
  "top": 0,
  "left": 0, 
  "width":100,
  "height":300,
});	
	
var foo3 = Ti.UI.createView({
  "backgroundColor":"#cc0",
  "top": 0,
  "left": 100, 
  "width":100,
  "height":300,
});		
	
var foo1 = Ti.UI.createView({
  "backgroundColor":"#0cc",
  "top": 0,
  "left": 0, 
  "width":200,
  "height":300,
});
foo1.add(foo2);
foo1.add(foo3);

var foo = macarnativecode.createSlideView({
  "color":"#c00",
  "top": 50,
  "left": 100, 
  "width":200,
  "height":300,
  "touchWidth":100,
  "pageWidth":100,
  "viewContainer": foo1,
  "pageNum": 2,
  "touchEndCallback": function(res){
  	console.log( res );
  }
});
//foo.add( foo1 );
win.add(foo);

win.open();

