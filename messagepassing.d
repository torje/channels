import std.concurrency, std.stdio, std.typecons, core.thread;
import channels;
void spawnMe2(shared BlockingChannel!int ch){
  bool cont = true;
  while ( cont ){
    int rec =  ch.extract() ;
    if ( rec != 0 ){
      writeln("I received something on my channel! : " ,rec);
      if ( rec == 10 ){
        writeln("I have to quit");
        return;
      }
    }
  }
}

void sender(shared BlockingChannel!int ch){
  foreach(i;0..10){
    Thread.sleep(dur!"msecs"(50));
    ch.insert(i);
  }
}
void main(){
  shared BlockingChannel!int ch = new BlockingChannel!int;
  spawn(&spawnMe2, ch);
  spawn(&sender,ch);
  Thread.sleep(dur!"msecs"(500));
  ch.insert(1);
  Thread.sleep(dur!"msecs"(500));
  ch.insert(2);
  Thread.sleep(dur!"msecs"(500));
  ch.insert(3);
  Thread.sleep(dur!"msecs"(500));
  ch.insert(10);
  Thread.sleep(dur!"msecs"(500));
}
