//
//  Package.swift
//  PerfectCRUD 
//
//  Created by Jonathan Guthrie on 2016-09-23.
//	Copyright (C) 2016 PerfectlySoft, Inc.
//
//===----------------------------------------------------------------------===//
//
// This source file is part of the Perfect.org open source project
//
// Copyright (c) 2015 - 2016 PerfectlySoft Inc. and the Perfect project authors
// Licensed under Apache License v2.0
//
// See http://perfect.org/licensing.html for license information
//
//===----------------------------------------------------------------------===//
//

import PackageDescription

let package = Package(
	name: "PerfectPostgresCRUD",
	targets: [],
	dependencies: [
		.Package(url: "https://github.com/PerfectlySoft/Perfect-PostgreSQL.git", majorVersion: 2, minor: 0),
		.Package(url: "https://github.com/PerfectCRUD/PerfectCRUD.git", majorVersion: 0, minor: 0),
	],
	exclude: []
)
