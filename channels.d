import std.typecons;
synchronized class NonBlockingChannel(t){
  private shared t[] queue;
  void insert(t i){
    queue ~= i;
  }
  bool extract( ref  t  defaultTo ){
    if ( queue.length == 0){
      return false;
    }else{
      t ret = queue[0];
      queue = queue[1..$];
      defaultTo = ret;
      return true;
    }
  }
}

class BlockingChannel(MessageType){
  private shared NonBlockingChannel!MessageType queue;
  this(){
    queue = new NonBlockingChannel!MessageType;
  }
  void insert(MessageType msg)shared{
    queue.insert(msg);
  }
  bool extract(ref MessageType msg)shared{
    while ( false == queue.extract(msg) ) {
    }
    return true;
  }
}
