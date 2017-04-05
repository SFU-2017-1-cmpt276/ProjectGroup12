//
//  RunViewControllerDelegate.swift
//	AdventureSFU: Make Your Path
//	Created for SFU CMPT 276, Instructor Herbert H. Tsang, P.Eng., Ph.D.
//	AdventureSFU was a project created by Group 12 of CMPT 276
//
//  Created by Group 12 on 3/19/17.
//  Copyright © 2017 . All rights reserved.
//
//	RunViewControllerDelegate - gives headers that must be implemented by methods inheriting this protocol
//	Programmers: Karan Aujla, Carlos Abaffy, Eleanor Lewis, Chris Norris-Jones
//
//	Known Bugs:
//	Todo:
//


import Foundation

protocol RunViewControllerDelegate: NSObjectProtocol {
    func dismissMapView()
    func deleteAllPoints()
    func handleRoute()
}
