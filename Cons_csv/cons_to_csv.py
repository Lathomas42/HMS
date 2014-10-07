from scipy.io import loadmat
import csv
import numpy as np

def writeUrl(x,y,z):
    return 'http://catmaid.hms.harvard.edu/?pid=1012&zp={}&yp={}&xp={}&tool=tracingtool&sid0=6&s0=-2'.format(z,y,x)


def WriteConnectorList(fn="cons_to_seed"):
    Conn_Load = loadmat(fn+".mat")
    connList = np.asarray(Conn_Load[fn])

    col_names = ['NR_name', 'tracer_id', 'date_started',
                 'date_completed', 'comments', 'ConnID',
                 'Conn_x', 'Conn_y', 'Conn_z', 'Pre_skel',
                 'Post_skel', 'URL']
    f = open('Conn_spreadsheet.csv', 'w+')
    csv_writer = csv.writer(f)
    csv_writer.writerow(col_names)
    for row in connList:
        csv_writer.writerow(['', '', '', '', '', row[0],
                             row[3], row[4], row[5], row[1],
                             row[2], writeUrl(row[3], row[4], row[5])])
    f.close()
