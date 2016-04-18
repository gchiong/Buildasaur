//
//  BotNaming.swift
//  Buildasaur
//
//  Created by Honza Dvorsky on 16/05/2015.
//  Copyright (c) 2015 Honza Dvorsky. All rights reserved.
//

import Foundation
import XcodeServerSDK
import BuildaGitServer

class BotNaming {
    
    class func isBuildaBot(bot: Bot) -> Bool {
        return bot.name.hasPrefix(self.prefixForBuildaBot())
    }
    
    class func isBuildaBotBelongingToRepoWithName(bot: Bot, repoName: String) -> Bool {
        return bot.name.hasPrefix(self.prefixForBuildaBotInRepoWithName(repoName))
    }
    
    class func nameForBotWithBranch(branch: BranchType, repoName: String) -> String {
        return "\(self.prefixForBuildaBotInRepoWithName(repoName)) |-> \(branch.name)"
    }
    
    class func nameForBotWithPR(pr: PullRequestType, repoName: String) -> String {
//        return "\(self.prefixForBuildaBotInRepoWithName(repoName)) PR #\(pr.number)"
        let name = "\(self.prefixForBuildaBotInRepoWithName(repoName)) \(pr.headName)"
        return name
    }
    
    class func prefixForBuildaBotInRepoWithName(repoName: String) -> String {
        let repoNameComponents = repoName.componentsSeparatedByString("/")
        if repoNameComponents.count > 0 {
            // For BitBucket Server, repoName will be "<project>/<repo>"
            return "\(self.prefixForBuildaBot()) [\(repoNameComponents[1])]"
        } else {
            return "\(self.prefixForBuildaBot()) [\(repoName)]"
        }
    }
    
    class func prefixForBuildaBot() -> String {
        return "β"
    }
}
