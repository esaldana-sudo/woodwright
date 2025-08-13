import 'dart:math' as math;
import '../../domain/services/joinery_engine.dart';

double inchesToMm(double inches) => inches * 25.4;

class Part {
  final String category;
  final double tMm;
  final double wMm;
  final double lMm;
  final String notes;

  Part(this.category, this.tMm, this.wMm, this.lMm, {this.notes = ''});

  static Part side(double t, double w, double l) => Part('side', t, w, l);
  static Part fixedShelf(double t, double w, double l) => Part('fixed_shelf', t, w, l);
  static Part back(double t, double w, double h) => Part('back', t, w, h);
  static Part faceFrame(double t, double w, double l) => Part('face_frame', t, w, l);
}

class BookshelfParts {
  final List<Part> parts;
  final List<PartConnection> connections;

  const BookshelfParts({required this.parts, required this.connections});
}

class PartConnection {
  final Part partA;
  final Part partB;
  final String loadClass;
  final String rackingExposure;
  final List<String> toolset;
  final JoineryRecommendation joinery;

  PartConnection({
    required this.partA,
    required this.partB,
    required this.loadClass,
    required this.rackingExposure,
    required this.toolset,
    required this.joinery,
  });
}

class BookshelfInput {
  final double widthMm;
  final double heightMm;
  final double depthMm;
  final double thicknessMm;
  final bool framed; // <– NEW

  const BookshelfInput({
    required this.widthMm,
    required this.heightMm,
    required this.depthMm,
    this.thicknessMm = 19,
    this.framed = true, // <– default true
  });
}

Future<BookshelfParts> generateBookshelf(BookshelfInput i) async {
  final parts = <Part>[];
  final connections = <PartConnection>[];
  final joineryEngine = JoineryEngine();
  final t = i.thicknessMm;

  parts.add(Part.side(t, i.depthMm, i.heightMm)); // sideL
  parts.add(Part.side(t, i.depthMm, i.heightMm)); // sideR

  final clearWidth = i.widthMm - 2 * t;
  final top = Part('top', t, clearWidth, i.depthMm);
  final bottom = Part('bottom', t, clearWidth, i.depthMm);
  parts.add(top);
  parts.add(bottom);

  final shelf = Part.fixedShelf(t, clearWidth, i.depthMm);
  parts.add(shelf);

  final back = Part.back(6.0, i.widthMm - 2, i.heightMm - 2);
  parts.add(back);

  final sideL = parts[0];

  const loadClass = 'medium';
  const racking = 'medium';
  const toolset = ['pocket_hole', 'dowel'];

  Future<void> connect(Part a, Part b, String load, String rack) async {
    final j = await joineryEngine.suggest(
      partACategory: a.category,
      partBCategory: b.category,
      partAThicknessMm: a.tMm,
      partBThicknessMm: b.tMm,
      loadClass: load,
      rackingExposure: rack,
      toolset: toolset,
    );
    connections.add(PartConnection(
      partA: a,
      partB: b,
      loadClass: load,
      rackingExposure: rack,
      toolset: toolset,
      joinery: j,
    ));
  }

  await connect(shelf, sideL, loadClass, racking);
  await connect(top, sideL, loadClass, racking);
  await connect(bottom, sideL, loadClass, racking);
  await connect(back, sideL, 'light', 'high');

  if (i.framed) {
    final faceFrame = Part.faceFrame(t, i.widthMm, t);
    parts.add(faceFrame);
    await connect(faceFrame, sideL, 'light', 'low');
  }

  return BookshelfParts(parts: parts, connections: connections);
}