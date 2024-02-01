class FFTContainer {
  // head of list
  FFTLine head = null;

  // next
  FFTLine next = null;
  
  int max_size = 0;

  // constructor
  FFTContainer(int max_size_)
  {
    head = new FFTLine(points_per_line);
    max_size = max_size_;
  }

  void add(FFTLine line)
  {
    // we always add onto the head.
    // so set the current head, to the 'next' of this new one,
    line.next = head;

    // and set the new one as the new head.
    head = line;
  }

  FFTLine get(int index) {
    FFTLine line;
    
    if ((index < (size() - 1)) && (index >= 0)) {
      line = head;
      
      if(index == 0) {
        return line;
      }
      
      for (int i = 0; i < index; i++) {
        line = line.next;
      }
      
      return (line);
    }

    return null;
  }

  int size() {
    int count = 0;
    
    FFTLine line = head;
    
    while (line != null) {
      count++;
      line = line.next;
    }
    
    return(count);
  }
  
  void trim() {
    int count = 0;
    
    FFTLine line = head;
    
    while (line != null) {
      count++;
      
      line = line.next;
      
      if(count >= max_size) {
       line = null; 
      }
    }
  }
}
