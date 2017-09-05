//
//  ViewController.swift
//  neuron-network
//
//  Created by IshimotoKiko on 2016/10/05.
//  Copyright © 2016年 IshimotoKiko. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    let input:[[Double]] = [[0.0,0.0],[0.0,1.0],[1.0,0.0],[1.0,1.0]]
    let teacher:[[Double]] = [[0],[1],[1],[0]]
    var neu = neuron()
    override func viewDidLoad() {
        super.viewDidLoad()
        var x1 = Matrix(data: [[1,4,2],[6,7,2],[3,9,4]])
        let x2 = Matrix(data: [[3,2,1],[8,7,6],[5,4,3]])
        //print(x1)
        //print(x2)
        x1.pro(x2)
        print(x1)
        
        neu.set(2)
        let ne = neuronNetwork(num: [2,3,1])
        var count = 0
        for num in 0...8000
        {
            //neu.inputsSet(input[num % 4])
            neu.inputSet( Matrix.init(data: [input[num % 4]]))
            //neu.setNumber(num % 4)
            ne.inputSet(Matrix.init(data: [input[num % 4]]))
            ne.update()
            ne.teacher = teacher[num%4]
            ne.back()
            //print(ne.output)
            /*
            neu.teacher = teacher[num % 4][1]
            neu.update()
            neu.back()*/
            //neu.training()
            print("  " + teacher[num % 4].description + "  " + ne.output.DATA.description)
            count += 1
        }
        // Do any additional setup after loading the view.
    }



}

