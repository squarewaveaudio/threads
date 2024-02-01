import ddf.minim.*;
import ddf.minim.analysis.*;

Minim        minim;
AudioPlayer  player;
FFT          fft;
FFTContainer fftc;

ArrayList<Line> lines = new ArrayList<Line>();

void setup() {
  size(800, 700, P3D);
  pixelDensity(displayDensity());
  minim = new Minim(this);
  frameRate(30);
  setup_audio();
}

void setup_audio() {
  player = minim.loadFile("threads.mp3", 2048);
  player.loop();

  fft = new FFT(player.bufferSize(), player.sampleRate());

  // Iterate once for each of the 8 threads.
  for (int i = 0; i < 8; i++) {
    int dy = i * 96;
    
    Point p1 = new Point(0, dy, 0);
    Point p2 = new Point(800, dy, 0);

    Line line = new Line(p1, p2, 100, 25);
    
    lines.add(line);
  }

  fftc = new FFTContainer(32); // 32 points per line
}

void draw() {
  translate(0, 0, -300); 
  background(79, 26, 35);
  strokeWeight(4); 
  strokeCap(ROUND);
  noFill();

  fft.forward(player.mix);

  FFTLine fft_line = new FFTLine(32); // 32 points per line

  for (int j = 0; j < 32; j++) {
    int target = int(map(j, 0, 32, 0, fft.specSize()));
    
    float fft_point = fft.getBand(target) * 25; // multiplying the point height will give a more dramatic effect for lower amplitudes
    
    fft_line.add_at(j, fft_point);
  }

  fftc.add(fft_line);
  fftc.trim();

  FFTLine current_fft;

  // Iterate once for each of the 8 threads.
  for (int i = 0; i < 8; i++) {
    beginShape();
        
    current_fft = fftc.get(i);
    for (int pt = 1; pt < 32 - 1; pt ++) {
      Point p = lines.get(i).get_point(pt);
      float z = int(random(1, 10));

      if (current_fft == null) {
        z = int(random(1, 50));
      } else {
        z = current_fft.get_at(pt);
      }
      
      curveVertex(p.x, p.y, z);
      
      stroke(254 - (i * 3), 145 - (i * 10), 63 + (i * 10));
    }

    endShape();
  }
  
  //saveFrame();
}
