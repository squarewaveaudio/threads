class FFTLine {
  int size;
  float[] ffts;
  FFTLine next;

  FFTLine(int size_) {
    size = size_;
    ffts = new float[size];
  }

  int get_size() { 
    return size;
  }

  void add_at(int index, float value) {
    if (index < size) {
      ffts[index] = value;
    }
  }

  float get_at(int index) {
    float value = 0;
    
    if (index < size) {
      value = ffts[index];
    }
 
    return (value);
  }
}
