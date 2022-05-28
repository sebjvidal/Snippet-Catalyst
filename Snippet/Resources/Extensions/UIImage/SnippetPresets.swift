//
//  SnippetPresets.swift
//  Snippet
//
//  Created by Seb Vidal on 04/02/2022.
//

import UIKit

extension UIImage {
    static let presetNames = [
        "SnowLeopard",
        "Lion",
        "Mavericks",
        "Yosemite",
        "ElCapitan",
        "Sierra",
        "HighSierra",
        "Mojave",
        "Catalina",
        "BigSur-1",
        "BigSur-2",
        "Monterey"
    ]
    
    static let presetURLs = [
        "SnowLeopard": ["https://firebasestorage.googleapis.com/v0/b/snippet-4371d.appspot.com/o/Wallpapers%2FSnowLeopard.jpg?alt=media&token=5318e0ce-7c01-48fe-ab34-fa58dad377f3"],
        "Lion": ["https://firebasestorage.googleapis.com/v0/b/snippet-4371d.appspot.com/o/Wallpapers%2FLion.jpg?alt=media&token=4cbe826d-6d71-4926-8229-f2308dd90ef0"],
        "Mavericks": ["https://firebasestorage.googleapis.com/v0/b/snippet-4371d.appspot.com/o/Wallpapers%2FMavericks.jpg?alt=media&token=3c419aa0-a337-4a5e-969f-af3753a9c271"],
        "Yosemite": ["https://firebasestorage.googleapis.com/v0/b/snippet-4371d.appspot.com/o/Wallpapers%2FYosemite.jpg?alt=media&token=9453219f-d6ab-4b21-bca8-baadf004605a"],
        "ElCapitan": ["https://firebasestorage.googleapis.com/v0/b/snippet-4371d.appspot.com/o/Wallpapers%2FElCapitan.jpg?alt=media&token=c53a839f-a44d-44c5-8fc2-2e1afe4d756c"],
        "Sierra": ["https://firebasestorage.googleapis.com/v0/b/snippet-4371d.appspot.com/o/Wallpapers%2FSierra.jpg?alt=media&token=2c18ca41-917a-4c15-a9f2-67bc1e580670"],
        "HighSierra": ["https://firebasestorage.googleapis.com/v0/b/snippet-4371d.appspot.com/o/Wallpapers%2FHighSierra.jpg?alt=media&token=28086e92-a49a-484e-a108-8a0ea0d3343b"],
        "Mojave": [
            "https://firebasestorage.googleapis.com/v0/b/snippet-4371d.appspot.com/o/Wallpapers%2FMojave-Light.jpg?alt=media&token=2aea9624-4be8-494a-884a-15ba7fb6a321",
            "https://firebasestorage.googleapis.com/v0/b/snippet-4371d.appspot.com/o/Wallpapers%2FMojave-Dark.jpg?alt=media&token=2cfbd432-2a03-4aee-be19-588f8338ad26"
        ],
        "Catalina": [
            "https://firebasestorage.googleapis.com/v0/b/snippet-4371d.appspot.com/o/Wallpapers%2FCatalina-Light.jpg?alt=media&token=fc3d438e-d9c7-41a5-a675-0b8c60937c04",
            "https://firebasestorage.googleapis.com/v0/b/snippet-4371d.appspot.com/o/Wallpapers%2FCatalina-Dark.jpg?alt=media&token=b2af027d-6c15-4660-a82e-928f446a915e"
        ],
        "BigSur-1": [
            "https://firebasestorage.googleapis.com/v0/b/snippet-4371d.appspot.com/o/Wallpapers%2FBigSur-1-Light.jpg?alt=media&token=3453f08a-1f6a-4a8d-940a-4b3994b6bdc6",
            "https://firebasestorage.googleapis.com/v0/b/snippet-4371d.appspot.com/o/Wallpapers%2FBigSur-1-Dark.jpg?alt=media&token=5f2f0f9f-9f9b-4cb1-8a32-f0afd044aace"
        ],
        "BigSur-2": [
            "https://firebasestorage.googleapis.com/v0/b/snippet-4371d.appspot.com/o/Wallpapers%2FBigSur-2-Light.jpg?alt=media&token=1db6925d-607e-46d8-afc6-d24851a02d40",
            "https://firebasestorage.googleapis.com/v0/b/snippet-4371d.appspot.com/o/Wallpapers%2FBigSur-2-Dark.jpg?alt=media&token=9832d021-285d-4024-a026-9a13411b0380"
        ],
        "Monterey": [
            "https://firebasestorage.googleapis.com/v0/b/snippet-4371d.appspot.com/o/Wallpapers%2FMonterey-Light.jpg?alt=media&token=9f63f754-94e2-4375-bd09-f7d108365b13",
            "https://firebasestorage.googleapis.com/v0/b/snippet-4371d.appspot.com/o/Wallpapers%2FMonterey-Dark.jpg?alt=media&token=89f2c58b-106d-4800-83d6-ea54e720c1d6"
        ]
    ]
    
    static let presetThumbnail1 = UIImage(named: "SnowLeopard-Thumbnail")
    static let presetThumbnail2 = UIImage(named: "Lion-Thumbnail")
    static let presetThumbnail3 = UIImage(named: "Mavericks-Thumbnail")
    static let presetThumbnail4 = UIImage(named: "Yosemite-Thumbnail")
    static let presetThumbnail5 = UIImage(named: "ElCapitan-Thumbnail")
    static let presetThumbnail6 = UIImage(named: "Sierra-Thumbnail")
    static let presetThumbnail7 = UIImage(named: "HighSierra-Thumbnail")
    static let presetThumbnail8 = UIImage(named: "Mojave-Thumbnail")
    static let presetThumbnail9 = UIImage(named: "Catalina-Thumbnail")
    static let presetThumbnail10 = UIImage(named: "BigSur-1-Thumbnail")
    static let presetThumbnail11 = UIImage(named: "BigSur-2-Thumbnail")
    static let presetThumbnail12 = UIImage(named: "Monterey-Thumbnail")
    
    static let presets = [
        presetThumbnail1,
        presetThumbnail2,
        presetThumbnail3,
        presetThumbnail4,
        presetThumbnail5,
        presetThumbnail6,
        presetThumbnail7,
        presetThumbnail8,
        presetThumbnail9,
        presetThumbnail10,
        presetThumbnail11,
        presetThumbnail12
    ]
}
