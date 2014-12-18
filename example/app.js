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
  "backgroundColor":"#00c",
  "top": 20,
  "left": 0, 
  "width":100,
  "height":300,
});	
	
var foo3 = Ti.UI.createView({
  "backgroundColor":"#0c0",
  "top": 20,
  "left": 100, 
  "width":100,
  "height":300,
});		
	
var foo1 = Ti.UI.createView({
  "backgroundColor":"#c00",
  "top": 0,
  "left": 100, 
  "width":200,
  "height":400,
});
foo1.add(foo2);
foo1.add(foo3);

var foo = macarnativecode.createSlideView({
  //"color":"#c00",
  "top": 50,
  "left": 0, 
  "width":320,
  "height":350,
  "touchWidth":100,
  "pageWidth":100,
  "viewContainer": foo1,
  "pageNum": 2,
  "startLeft": 100,
  "zoomAnim": false,
  "touchEndCallback": function(res){
  	console.log( res );
  }
});
//foo.add( foo1 );
win.add(foo);

win.open();

