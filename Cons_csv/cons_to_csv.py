from scipy.io import loadmat
import csv
import numpy as np
import catmaid
import time
try:
    import gspread
except:
    gspread = None
import getpass


def writeUrl(x, y, z, pid=1012):
    return 'http://catmaid.hms.harvard.edu/?pid={}&zp={}&yp={}&xp={}&tool=tracingtool&sid0=6&s0=-2'.format(pid,z,y,x)


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


def WriteListFromCatmaid():
    c = catmaid.Connection('http://catmaid.hms.harvard.edu',
                           'thomas.lo',
                           'asdfjkl;',
                           'Validation Tracing DR5_7L')
    Conn_Load = loadmat("cons_to_seed.mat")
    loaded = np.asarray(Conn_Load['cons_to_seed'])

    wd = c.wiring_diagram()
    f = open('Conn_spreadsheet_catmaid.csv', 'w+')
    csv_writer = csv.writer(f)
    csv_writer.writerow(rowMake(c))
    for edge in wd['data']['edges']:
        rows = rowMake(c, [edge['source'], edge['target']], loaded)
        for row in rows:
            csv_writer.writerow(row)
    f.close()


def WriteCatmaidGoogle(sht_name="Conn_spreadsheet_catmaid"):
    c = catmaid.Connection('http://catmaid.hms.harvard.edu',
                           'thomas.lo',
                           'asdfjkl;',
                           'Validation Tracing DR5_7L')

    UN = str(raw_input("Enter Google UserName: "))
    PW = getpass.getpass("Enter Google Password: ")
    gc = gspread.login(UN, PW)
    sht = gc.open(sht_name).sheet1

    Conn_Load = loadmat("cons_to_seed.mat")
    loaded = np.asarray(Conn_Load['cons_to_seed'])

    wd = c.wiring_diagram()
    for edge in wd['data']['edges']:
        n = len(sht.col_values(1))
        rows = rowMake(c, n, [edge['source'], edge['target']], loaded)
        for row in rows:
            sht.append_row(row)


def rowMake(c, row_numb, vals=[], loaded=None):
    Head = ['Skeleton ID', 'Pre or Post', 'Date Began Tracing',
            'Original Annotator', '# of Nodes', 'If Soma=1',
            'Cell Type', 'Comments', 'Date Finished Tracing',
            'Reviewer', 'Date Began Reviewing',
            '# of Nodes Post-Review', 'TAGS_TO-CHECK', 'checked?',
            'INITIALS', '# of branches added by reviewer',
            '# of branches CBR', '# of distal nodes tagged CBR',
            '# of branches removed by reviewer', '# of synapses altered',
            'Date Finished', 'Reviewing Comments', 'Status', 'Date Seeded',
            'Connector ID', 'Original Connector ID']
    if vals == []:
        return Head
    else:
        # vals should be [Sid_pre,Sid_post]
        t = time.localtime()
        date = "{}/{}/{}".format(t[0], t[1], t[2])
        con_get = getConnector(vals[0], vals[1], c)
        conID = con_get[0]
        origID = getOrigConnector(con_get[1]['x'], con_get[1]['y'],
                                  con_get[1]['z'], loaded)
        link = writeUrl(con_get[1]['x'], con_get[1]['y'], con_get[1]['z'])
        link_old = writeUrl(con_get[1]['x'], con_get[1]['y'],
                            con_get[1]['z'], 9)
        if_state = '=IF(Z{0}="UHOH","uhoh",IF(C{0}="","Ready",IF(I{0}="","In progress",IF(K{0}="","needs Review",IF(U{0}="","In progress","Reviewed")))))'.format(row_numb+1)
        if_state2 = '=IF(Z{0}="UHOH","uhoh",IF(C{0}="","Ready",IF(I{0}="","In progress",IF(K{0}="","needs Review",IF(U{0}="","In progress","Reviewed")))))'.format(row_numb+2)

        row_1 = [vals[0], '=HYPERLINK("{}", "PRE")'.format(link),
                 '', '', '', '', 'e', '', '', '', '',
                 '', '', '', '', '', '', '', '', '', '', '',
                 if_state, date, conID, origID]
        row_2 = [vals[1], '=HYPERLINK("{}", "POST")'.format(link),
                 '', '', '', '', 'e', '', '', '', '',
                 '', '', '', '', '', '', '', '', '', '', '',
                 if_state2, date, conID,
                 '=HYPERLINK("{}","{}")'.format(link_old, origID)]
        return row_1, row_2


def getConnector(sid_1, sid_2, c):
    sk1 = c.skeleton(sid_1)
    sk2 = c.skeleton(sid_2)
    verts1 = sk1['vertices'].keys()
    verts2 = sk2['vertices'].keys()
    for v1 in verts1:
        for v2 in verts2:
            if v1 == v2:
                return v1, sk1['vertices'][v1]


def getOrigConnector(conx, cony, conz, loadedList):
    for row in loadedList:
        diff = row[3:]-[conx, cony, conz]
        if(all(abs(i) <= 250 for i in diff)):
            print row[0]
            return row[0]
    print "UHOH"
    return "UHOH"


def updateSheet():
    UN = str(raw_input("Enter Google UserName: "))
    PW = getpass.getpass("Enter Google Password: ")
    gc = gspread.login(UN, PW)
    worksheet = gc.open("Conn_spreadsheet_catmaid").sheet1
    usedSkels = worksheet.col_values(1)

    c = catmaid.Connection('http://catmaid.hms.harvard.edu',
                           'thomas.lo',
                           'asdfjkl;',
                           'Validation Tracing DR5_7L')
    Conn_Load = loadmat("cons_to_seed.mat")
    loaded = np.asarray(Conn_Load['cons_to_seed'])

    wd = c.wiring_diagram()

    for edge in wd['data']['edges']:
        if ((edge['target'] not in usedSkels) or (edge['source']
                                                  not in usedSkels)):
                rows = rowMake(c, 1, [edge['source'], edge['target']], loaded)
                if edge['source'] not in usedSkels:
                    n = len(worksheet.col_values(1))
                    rows[0][22]='=IF(Z{0}="UHOH","uhoh",IF(C{0}="","Ready",IF(I{0}="","In progress",IF(K{0}="","needs Review",IF(U{0}="","In progress","Reviewed")))))'.format(n+1)
                    worksheet.append_row(rows[0])
                if edge['target'] not in usedSkels:
                    n = len(worksheet.col_values(1))
                    rows[1][22]='=IF(Z{0}="UHOH","uhoh",IF(C{0}="","Ready",IF(I{0}="","In progress",IF(K{0}="","needs Review",IF(U{0}="","In progress","Reviewed")))))'.format(n+1)
                    worksheet.append_row(rows[1])

if __name__ == "__main__":
    WriteConnectorList();
