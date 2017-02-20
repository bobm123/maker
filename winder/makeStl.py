import os,sys
import re
from subprocess import call


def find_parts(project):
    parts_list = []
    p = re.compile('module.(.*)_stl')
    fp = open(project, 'r')
    for lines in fp:
        m = p.match(lines)
        if m:
            parts_list.append(m.group(1))
            
    return(parts_list)

    
def gen_stl_files(project, parts_list, scad_path):
    cmdList = []
    for part_name in parts_list:
        outfile = open("__%s.scad" % part_name, 'w')
        outfile.write("use <%s>\n%s_stl();\n" % (project, part_name))
        outfile.close()
        cmd = '"%s" -o %s.stl __%s.scad' % (scad_path, part_name, part_name)
        print(cmd)
        cmdList.append(cmd)

    for cmd in cmdList:
        print(cmd)
        call(cmd, shell=True)

        
def main(argv):
    '''
    Generates .stl files from 'parts' (modules with names 
    ending in _stl) found in a .scad file.
    '''
    if len(argv) < 2:
        print("generates .stl files from 'parts' (modules with names")
        print("ending in _stl) found in a .scad file")
        print("usage:\n\tpython makeStl.py myproject.scad [path to openSCAD]")
        exit(0)
        
    argv.append('')    
    #scad_path = os.path.join(argv[2], 'openscad')
    scad_path = '/usr/bin/openscad'
    parts_list = find_parts(argv[1])
    print(parts_list)
    gen_stl_files(argv[1], parts_list, scad_path)

    
if __name__ == "__main__":
    main(sys.argv)
    
