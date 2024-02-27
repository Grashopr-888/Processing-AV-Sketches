import ddf.minim.*;

Minim minim;
AudioPlayer player;

int numObjects;
float noiseScale = 0.02;
float t = 0.0;

void setup() {
  size(400, 400, P3D); // Create a 3D canvas
  randomSeed(millis()); // Seed the random number generator with current time
  numObjects = int(random(5, 15)); // Random number of objects between 5 and 15
  generatePattern();

  minim = new Minim(this); // Initialize Minim
  player = minim.loadFile("Moog Opus_v3_16.wav"); // Load the audio file
  player.loop(); // Loop the audio file
}

void draw() {
  // Set up vanishing point and grid
  background(random(255), random(255), random(255)); // Random background color

  // Vanishing point
  translate(width / 2, height / 2, -200);
  stroke(255);
  line(-width, -height, 0, width, height, 0);
  line(width, -height, 0, -width, height, 0);

  for (float x = -width; x <= width; x += 20) {
    for (float y = -height; y <= height; y += 20) {
      point(x, y, 0);
    }
  }

  // Generate 3D objects
  generatePattern();
}

void generatePattern() {
  for (int i = 0; i < numObjects; i++) {
    float x = random(-width / 2, width / 2); // Random x-coordinate within canvas bounds
    float y = random(-height / 2, height / 2); // Random y-coordinate within canvas bounds
    float z = random(-200, 200); // Random z-coordinate for 3D effect
    float size = random(20, 80); // Random size for the object

    color fillColor = color(random(255), random(255), random(255)); // Random fill color
    color borderColor = color(random(255), random(255), random(255)); // Random border color

    pushMatrix(); // Save the current transformation matrix
    translate(x, y, z); // Apply 3D translation

    stroke(borderColor); // Set border color
    fill(fillColor); // Set fill color

    float borderWeight = random(1, 5); // Random border weight
    strokeWeight(borderWeight); // Set border weight

    int shapeType = int(random(4)); // Randomly choose a shape type (0: box, 1: sphere, 2: rhombus, 3: octagon)
    switch (shapeType) {
      case 0:
        drawNoisyBox(size);
        break;
      case 1:
        drawNoisySphere(size / 2);
        break;
      case 2:
        drawNoisyRhombus(size);
        break;
      case 3:
        drawNoisyOctagon(size);
        break;
    }

    popMatrix(); // Restore the previous transformation matrix
  }
}

void drawNoisyBox(float s) {
  float n = noise(t) * 30;
  box(s + n);
  t += noiseScale;
}

void drawNoisySphere(float r) {
  float n = noise(t) * 30;
  sphere(r + n);
  t += noiseScale;
}

void drawNoisyRhombus(float s) {
  beginShape();
  float halfS = s / 2;
  for (float angle = 0; angle < TWO_PI; angle += radians(20)) {
    float xOffset = cos(angle) * halfS;
    float yOffset = sin(angle) * halfS;
    float noiseValue = noise(xOffset * noiseScale, yOffset * noiseScale, t * noiseScale);
    float jitter = map(noiseValue, 0, 1, -10, 10);
    float x = xOffset + jitter;
    float y = yOffset + jitter;
    vertex(x, y, 0);
  }
  endShape(CLOSE);
  t += noiseScale;
}

void drawNoisyOctagon(float s) {
  beginShape();
  float halfS = s / 2;
  for (float angle = 0; angle < TWO_PI; angle += radians(45)) {
    float xOffset = cos(angle) * halfS;
    float yOffset = sin(angle) * halfS;
    float noiseValue = noise(xOffset * noiseScale, yOffset * noiseScale, t * noiseScale);
    float jitter = map(noiseValue, 0, 1, -10, 10);
    float x = xOffset + jitter;
    float y = yOffset + jitter;
    vertex(x, y, 0);
  }
  endShape(CLOSE);
  t += noiseScale;
}

void mousePressed() {
  generatePattern(); // Generate a new random pattern and background color
}

void stop() {
  player.close(); // Close the audio player
  minim.stop();   // Stop Minim
  super.stop();
}
