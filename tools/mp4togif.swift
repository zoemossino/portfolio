// usage: swift mp4togif.swift in.mp4 out.gif maxWidth fps
import AVFoundation
import ImageIO
import UniformTypeIdentifiers

let a = CommandLine.arguments
let input = URL(fileURLWithPath: a[1]), output = URL(fileURLWithPath: a[2])
let maxW = Double(a[3]) ?? 480, fps = Double(a[4]) ?? 12

let asset = AVURLAsset(url: input)
let sem = DispatchSemaphore(value: 0)
var duration = 0.0
var natural = CGSize.zero
Task {
  duration = (try? await asset.load(.duration))?.seconds ?? 0
  if let t = try? await asset.loadTracks(withMediaType: .video).first,
     let s = try? await t.load(.naturalSize), let tr = try? await t.load(.preferredTransform) {
    let r = s.applying(tr); natural = CGSize(width: abs(r.width), height: abs(r.height))
  }
  sem.signal()
}
sem.wait()

let gen = AVAssetImageGenerator(asset: asset)
gen.appliesPreferredTrackTransform = true
gen.requestedTimeToleranceBefore = .zero
gen.requestedTimeToleranceAfter = .zero
let w = min(maxW, natural.width)
gen.maximumSize = CGSize(width: w, height: natural.height * w / max(natural.width, 1))

let n = max(1, Int((duration * fps).rounded(.down)))
guard let dest = CGImageDestinationCreateWithURL(output as CFURL, UTType.gif.identifier as CFString, n, nil) else { exit(1) }
CGImageDestinationSetProperties(dest, [kCGImagePropertyGIFDictionary: [kCGImagePropertyGIFLoopCount: 0]] as CFDictionary)
let frameProps = [kCGImagePropertyGIFDictionary: [kCGImagePropertyGIFDelayTime: 1.0 / fps, kCGImagePropertyGIFUnclampedDelayTime: 1.0 / fps]] as CFDictionary
var count = 0
for i in 0..<n {
  let t = CMTime(seconds: Double(i) / fps, preferredTimescale: 600)
  if let img = try? gen.copyCGImage(at: t, actualTime: nil) {
    CGImageDestinationAddImage(dest, img, frameProps); count += 1
  }
}
print(CGImageDestinationFinalize(dest) ? "ok \(count) images \(Int(gen.maximumSize.width))px" : "échec")
