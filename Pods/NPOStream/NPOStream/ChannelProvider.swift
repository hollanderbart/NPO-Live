//
//  ChannelProvider.swift
//  NPOStream
//
//  Created by Bart den Hollander on 23/07/16.
//  Copyright © 2016 Bart den Hollander. All rights reserved.
//

import Foundation

public enum ChannelStreamTitle: String {
    case NPO1 = "LI_NL1_4188102"
    case NPO2 = "LI_NL2_4188105"
    case NPO3 = "LI_NL3_4188107"
    case NPONieuws = "LI_NEDERLAND1_221673"
    case NPOPolitiek = "LI_NEDERLAND1_221675"
    case NPO101 = "LI_NEDERLAND3_221683"
    case NPOCultura = "LI_NEDERLAND2_221679"
    case NPOZappXtra = "LI_NEDERLAND3_221687"
    case NPORadio1 = "LI_RADIO1_300877"
    case NPORadio2 = "LI_RADIO2_300879"
    case NPO3FM = "LI_3FM_300881"
    case NPORadio4 = "LI_RA4_698901"
    case NPOFunX = "LI_3FM_603983"
}

public struct ChannelProvider {
    
    public static let streams = [
        Channel(
            title: "NPO 1",
            streamTitle: ChannelStreamTitle.NPO1,
            url: nil),
        Channel(
            title: "NPO 2",
            streamTitle: ChannelStreamTitle.NPO2,
            url: nil),
        Channel(
            title: "NPO 3",
            streamTitle: ChannelStreamTitle.NPO3,
            url: nil),
        Channel(
            title: "NPO Nieuws",
            streamTitle: ChannelStreamTitle.NPONieuws,
            url: nil),
        Channel(
            title: "NPO Politiek",
            streamTitle: ChannelStreamTitle.NPOPolitiek,
            url: nil),
        Channel(
            title: "NPO 101",
            streamTitle: ChannelStreamTitle.NPO101,
            url: nil),
        Channel(
            title: "NPO Cultura",
            streamTitle: ChannelStreamTitle.NPOCultura,
            url: nil),
        Channel(
            title: "NPO Zapp",
            streamTitle: ChannelStreamTitle.NPOZappXtra,
            url: nil),
        Channel(
            title: "NPO Radio 1",
            streamTitle: ChannelStreamTitle.NPORadio1,
            url: nil),
        Channel(
            title: "NPO Radio 2",
            streamTitle: ChannelStreamTitle.NPORadio2,
            url: nil),
        Channel(
            title: "NPO 3FM",
            streamTitle: ChannelStreamTitle.NPO3FM,
            url: nil),
        Channel(
            title: "NPO Radio 4",
            streamTitle: ChannelStreamTitle.NPORadio4,
            url: nil),
        Channel(
            title: "NPO FunX",
            streamTitle: ChannelStreamTitle.NPOFunX,
            url: nil)
    ]
}
