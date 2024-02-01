class FFTContainer {
  FFTLine head = null;
  FFTLine next = null;
  
  int max_size = 0;

  FFTContainer(int max_size_) {
    head = new FFTLine(32); // Default to 32 points per line
    max_size = max_size_;
  }

  void add(FFTLine line) {
    line.next = head;
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
