import std.typecons;
synchronized class NonBlockingChannel(t){
  private shared t[] queue;
  void insert(t i){
    queue ~= i;
  }
  t extract( t defaultTo ){
    if ( queue.length == 0){
      return defaultTo;
    }else{
      t ret = queue[0];
      queue = queue[1..$];
      return ret;
    }
  }
}

class BlockingChannel(MessageType){
  alias Bundle = Tuple!(bool,MessageType);
  private shared NonBlockingChannel!Bundle queue;
  this(){
    queue = new NonBlockingChannel!Bundle;
  }
  void insert(MessageType msg)shared{
    Bundle bundle = tuple(true,msg);
    queue.insert(bundle);
  }
  MessageType extract()shared{
    Bundle bundle;
    bundle[0] = false;
    while ( false == bundle[0] ){
      bundle = queue.extract( bundle );
    }
    return bundle[1];
  }
}
