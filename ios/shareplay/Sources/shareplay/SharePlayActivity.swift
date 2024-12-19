//
//  SharePlayActivity.swift
//  shareplay
//
//  Created by Dimitri Dessus on 02/12/2022.
//

import Foundation
import GroupActivities

@available(iOS 15, *)
struct SharePlayActivity: GroupActivity {
  let title: String
  var metadata: GroupActivityMetadata {
    var meta = GroupActivityMetadata()
    
    meta.title = NSLocalizedString(self.title, comment: "")
    meta.type = .generic
    
    return meta
  }
}