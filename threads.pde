import ddf.minim.*;
import ddf.minim.analysis.*;

Minim        minim;
AudioPlayer  player;
FFT          fft;
FFTContainer fftc;

int line_separation = 96;
int points_per_line = 32;

ArrayList<Line> lines = new ArrayList<Line>();

int num_lines = 8;

int scale_factor = 15;

String audio_file = "threads.mp3";

void setup() {
  size(800, 700, P3D);
  stroke(255);
  strokeWeight(3); 

  minim = new Minim(this);
  frameRate(30);

  setup_audio();
}

void setup_audio() {
  player = minim.loadFile(audio_file, 2048);

  player.loop();

  fft = new FFT(player.bufferSize(), player.sampleRate());

  // build the array of lines
  for (int i = 0; i < num_lines; i++) {
    // step down in y by 'line_separation'
    int y = (i * line_separation);

    Line my_line = new Line(new Point(0, y, 0), new Point(800, y, 0), 100, 25);
    lines.add(my_line);
  }

  fftc = new FFTContainer(points_per_line);
}

void draw() {
  translate(0, 0, -300); 
  background(0); // black background
  fill(0);

  fft.forward(player.mix);

  FFTLine fft_line = new FFTLine(points_per_line);

  for (int j = 0; j < points_per_line; j++) {
    float fft_point = fft.getBand(int(map(j, 0, points_per_line, 0, fft.specSize()))) * scale_factor;
    fft_line.add_at(j, fft_point);
  }

  fftc.add(fft_line);
  fftc.trim();


  FFTLine fft_this_line;

  for (int i = 0; i < num_lines; i++) {
    // get the appropriate line in the fft linked list
    fft_this_line = fftc.get(i);

    // start drawing the shape
    beginShape();

    // now loop through the remaining points, setting the z from the fft_list we populated
    // at the start of draw()
    for (int pt = 1; pt < points_per_line - 1; pt ++) {
      Point my_point = lines.get(i).get_point(pt);
      
      float y = 0;

      if (fft_this_line == null) {
        y = 0;
      } else {
        // set a proper value from the fft_list
        y = fft_this_line.get_at(pt);
      }
      // set the vertex
      curveVertex(my_point.x, my_point.y, y * 2);
    }

    // set the last point manually, so we can set z to 0
    Point last_point = lines.get(i).get_point(points_per_line - 1);
    
    curveVertex(last_point.x, last_point.y, 0);
    
    endShape();
  }
}
