n=size();
function unescape(text){
  return text.split("\\").join("\\\\").split("\n").join("\\\\n");
}
for (i=0; i<n; i++) {
  print("[" + str(i) + "] " + unescape(str(read(i)))  + "\n");
}
