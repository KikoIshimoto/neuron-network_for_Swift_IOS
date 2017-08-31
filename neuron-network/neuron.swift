//
//  neuron.swift
//  neuron-network
//
//  Created by IshimotoKiko on 2016/10/05.
//  Copyright © 2016年 IshimotoKiko. All rights reserved.
//

import Foundation/*
class neuronNetwork
{
    init(){}
    var perceptrons:[[neuron]] = []
    func set(layer:Int,num:[Int])
    {
        for l in 0..<layer
        {
            var neu:[neuron] = [];
            for _ in 0..<num[l]
            {
                let n = neuron()
                if l == 0
                {
                    n.set(<#T##innum: Int##Int#>, innum2: <#T##Int#>, outTecher: <#T##[Double]#>)
                }
                neu.append(n)
            }
            perceptrons.append(neu)
        }
    }
    func update()
    {
        
    }
    func training()
    {
        
    }
}*/
class neuronNetwork
{
    var neurons:[[neuron]] = []
    var output:Matrix = Matrix()
    var inputMatrix:Matrix = Matrix()
    var line:[Matrix] = []
    init()
    {}
    init(num:[Int])
    {
        set(num)
    }
    func set(_ num:[Int])
    {
        neurons = []
        for n in 1..<num.count
        {
            var neu:[neuron] = []
            for _ in 0..<num[n]
            {
                let temp = neuron()
                temp.set(num[n-1])
                neu.append(temp)
            }
            //print(neu)
            neurons.append(neu)
        }
    }
    func inputSet(_ mat:Matrix)
    {
        for neu in neurons[0]
        {
            neu.inputSet(mat)
        }
    }
    func update()
    {
        var line = Matrix()
        
        for neuronLine in 0..<neurons.count
        {
           
            if neuronLine != 0
            {
                for neuron in 0..<neurons[neuronLine].count
                {
                    neurons[neuronLine][neuron].inputSet(line)
                }
            }
            line = Matrix()
            line.DATA.append([])
            for neuron in 0..<neurons[neuronLine].count
            {
                neurons[neuronLine][neuron].update()
                line.DATA[0].append(neurons[neuronLine][neuron].output)
                //print(neurons[neuronLine][neuron].weigthMatriX)
            }
            if neuronLine == neurons.count - 1
            {
                output = line
            }
        }
    }
    var teacher:[Double] = []
    func back()
    {
        var tempE = Matrix()
        var tempWeigth = Matrix()
        var line = Matrix()
        for neuronLine in (0..<neurons.count).reversed()
        {
            line = Matrix()
            line.DATA.append([])
            tempWeigth = Matrix()
            tempWeigth.DATA.append([])
            if neuronLine == neurons.count - 1
            {
                //print(neuronLine)
                for neuron in 0..<neurons[neuronLine].count
                {
                    neurons[neuronLine][neuron].teacher = teacher[neuron]
                    tempE = neurons[neuronLine][neuron].back()
                    
                }
            }
            else
            {
                for neuron2 in 0..<neurons[neuronLine].count
                {
                    
                    line = Matrix()
                    line.DATA.append([])
                    tempWeigth = Matrix()
                    tempWeigth.DATA.append([])
                    var deltaSum = 0.0
                    for neuron in 0..<neurons[neuronLine+1].count
                    {
                        deltaSum += neurons[neuronLine+1][neuron].delta
                        line.DATA[0].append(neurons[neuronLine+1][neuron].delta)
                        tempWeigth.DATA[0].append(neurons[neuronLine+1][neuron].weigthMatriX.DATA[0][neuron2])
                    }
                    line.invert()
                    deltaSum = tempWeigth.pro(line).DATA[0][0]
                    
                    //print(neuronLine.description + " " + deltaSum.description)
                    
                    neurons[neuronLine][neuron2].back(deltaSum)
                }
                
            }
        }
    }
}
class neuron
{
    var inputMatriX = Matrix()
    var weigthMatriX = Matrix()
    var E = Matrix()
    var prevWeigthMatriX = Matrix()
    var alpha = 0.5
    var delta = 0.0
    init(){}
    init(num:Int)
    {
        set(num)
    }
    var output:Double = 0
    var teacher:Double = 0
    func set(_ inputNum:Int)
    {
        E = Matrix(column: 1, row: inputNum+1)
        inputMatriX = Matrix(column: 1, row: inputNum+1)
        inputMatriX.DATA[0][inputNum] = 1.0
        weigthMatriX = Matrix(column: 1, row: inputNum+1)
        weigthMatriX.random()
        //print(weigthMatriX)
        //print(inputMatriX)
    }
    func inputSet(_ mat:Matrix)
    {
        var temp = mat
        temp.DATA[0].append(1)
        inputMatriX = temp
    }
    var outTemp = 0.0
    func update()
    {
        inputMatriX.invert()
        weigthMatriX = weigthMatriX + E
        outTemp = weigthMatriX.pro(inputMatriX).DATA[0][0]
        output = activation(outTemp)
        //print(inputMatriX)
        E.invert()
    }
    func back() -> Matrix
    {
        //var E = Matrix()
        inputMatriX.invert()
        E = Double.random(0.01, max: 0.1) * (teacher - output)*activation_dt(outTemp) * inputMatriX
        //weigthMatriX = weigthMatriX + (E)
        //print(inputMatriX)
        delta = (teacher - output)
        return E
    }
    func back(_ delta:Double) -> Matrix
    {
        //var E = Matrix()
        inputMatriX.invert()
        E = Double.random(0.01, max: 0.1) * delta*activation_dt(outTemp) * inputMatriX
        //weigthMatriX = weigthMatriX + (E)
        //print(inputMatriX)
        self.delta = delta
        return E
        
    }
    func activation(_ x:Double) -> Double
    {
        return lamp(x);
    }
    func activation_dt(_ x:Double) -> Double
    {
        return lamp_dt(x);
    }
    func lamp(_ x:Double) -> Double
    {
        return /*tanh(x)*/x < 0.0 ? 0.0 : x
    }
    func lamp_dt(_ x:Double) -> Double
    {
        return/* 1 - tanh(x) * tanh(x)*/x < 0.0 ? 0.0 : 1.0
    }
    func sigmoid(_ x:Double) -> Double
    {
        return 1.0/(1.0 + exp(-x));
    }
    func sigmoid_dt(_ x:Double) -> Double
    {
        return sigmoid(x) * (1 - sigmoid(x))
    }
}

struct Matrix
{
    var DATA:[[Double]] = []
    init(){}
    init(column:Int,row:Int)
    {
        for _ in 0..<column
        {
            var n:[Double] = [];
            for _ in 0..<row
            {
                n.append(0)
            }
            DATA.append(n)
        }
    }
    
    init(data:[[Double]])
    {
        DATA = data
    }
    mutating func random()
    {
        for i in 0..<DATA.count
        {
            for j in 0..<DATA[i].count
            {
                repeat
                {
                DATA[i][j] = Double.random(-0.1, max: 0.1)
                }while DATA[i][j] == 0
            }
        }
    }
    mutating func add(_ left:Matrix)
    {
        if(DATA.count == 0 || left.DATA.count == 0)
        {
            return;
        }
        if(DATA[0].count == 0 || left.DATA[0].count == 0)
        {
            return;
        }
        for i in 0..<DATA.count
        {
            for j in 0..<DATA[i].count
            {
                DATA[i][j] += left.DATA[i][j]
            }
        }
    }
    mutating func sub(_ left:Matrix)
    {
        if(DATA.count == 0 || left.DATA.count == 0)
        {
            return;
        }
        if(DATA[0].count == 0 || left.DATA[0].count == 0)
        {
            return;
        }
        for i in 0..<DATA.count
        {
            for j in 0..<DATA[i].count
            {
                DATA[i][j] -= left.DATA[i][j]
            }
        }
    }
    mutating func pro(_ left:Matrix) -> Matrix
    {

        if(DATA.count == 0 || left.DATA.count == 0)
        {
            print("not count1")
            return Matrix();
        }
        if(DATA[0].count == 0 || left.DATA[0].count == 0)
        {
            print("not count2")
            return Matrix();
        }
        if(DATA[0].count != left.DATA.count)
        {
            print("not count3")
            return Matrix();
        }
        var ans = Matrix(column: DATA.count, row: left.DATA[0].count)
        for ans_y in 0..<ans.DATA.count
        {
            for ans_x in 0..<ans.DATA[0].count
            {
                for y in 0..<DATA[0].count
                {
                    ans.DATA[ans_y][ans_x] += DATA[ans_y][y] * left.DATA[y][ans_x]
                }
            }
        }
        var mat = Matrix()
        mat.DATA = ans.DATA
        return mat
    }
    mutating func invert()
    {
        var ans:[[Double]] = [];
        for y in 0..<DATA[0].count
        {
            let d:[Double] = []
            ans.append(d)
        }
        for y in 0..<DATA[0].count
        {
            for x in 0..<DATA.count
            {
                ans[y].append(0)
            }
        }
        for x in 0..<ans.count
        {
            for y in 0..<ans[x].count
            {
                ans[x][y] = DATA[y][x]
            }
        }
        DATA = ans
    }
}
func * (left:Double , rigth:Matrix) -> Matrix
{
    var matrix = rigth
    for x in 0..<rigth.DATA.count
    {
        for y in 0..<rigth.DATA[x].count
        {
            matrix.DATA[x][y] *= left
        }
    }
    return matrix
}
func + (left:Matrix,rigth:Matrix) -> Matrix
{
    var matrix = left
    matrix.add(rigth)
    return matrix
}
public extension Double {
    /// Returns a random floating point number between 0.0 and 1.0, inclusive.
    public static var random:Double {
        get {
            return Double(arc4random()) / 0xFFFFFFFF
        }
    }
    /**
     Create a random number Double
     
     - parameter min: Double
     - parameter max: Double
     
     - returns: Double
     */
    public static func random(_ min: Double, max: Double) -> Double {
        return Double.random * (max - min) + min
    }
}
