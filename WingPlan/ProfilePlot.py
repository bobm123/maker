import sys
import svgwrite
 
 
def main(argv, argc):
    if argc < 2:
        return
 
    fp = open(argv[1], 'r')
    print(fp.readline())
    polar = [[200-100*float(c) for c in line.split()] for line in fp]
    polar.append(polar[0])
    print(polar)
 
    dwg = svgwrite.Drawing('test.svg', profile='tiny')
    for i in range(len(polar)-1):
        dwg.add(dwg.line(polar[i], polar[i+1], stroke=svgwrite.rgb(10, 0, 0)))
    dwg.save()
 
 
if __name__ == '__main__':
    main(sys.argv, len(sys.argv))
