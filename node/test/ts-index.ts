const add: (a: number, b: number) => number = require('../build/Debug/VscodeVcDemo.node').add

console.log("break hear")
console.log(add(0.1, 0.2))
