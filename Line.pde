class Line {
  Point[] points;
  Point start;
  Point end;
  int num_points = 0; 
  int point_sep = 0;
  
  Line(Point start_, Point end_, int num_points_, int point_sep_) {
    start = start_;
    end = end_;
    num_points = num_points_;
    point_sep = point_sep_;
    points = new Point[num_points];
    generate();
  }
  
  void generate() {
    for(int i = 0; i < num_points; i++) {
      int   dx = start.x + (point_sep * i);
      int   dy = start.y;
      float dz = 0;

      points[i] = new Point(dx, dy, dz);
    }
  }
  
  Point get_point(int i) {
    return points[i];
  }
}
