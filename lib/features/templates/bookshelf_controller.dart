import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'bookshelf_template.dart';

final bookshelfProvider = FutureProvider.family<BookshelfParts, bool>((ref, framed) async {
  return generateBookshelf(
    BookshelfInput(
      widthMm: 762,
      heightMm: 1219,
      depthMm: 305,
      framed: framed,
    ),
  );
});
