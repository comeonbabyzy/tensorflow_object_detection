%%writefile xml_to_csv.py

'''
只需修改三处，第一第二处改成对应的文件夹目录，
第三处改成对应的文件名，这里是train.csv
os.chdir('D:\\python3\\models-master\\research\\object_detection\\images\\train')
path = 'D:\\python3\\models-master\\research\\object_detection\\images\\train'
xml_df.to_csv('train.csv', index=None)
'''
import os
import glob
import pandas as pd
import xml.etree.ElementTree as ET
import tensorflow as tf

flags = tf.app.flags
flags.DEFINE_string('xml_path', '', 'Path to the xml input')
flags.DEFINE_string('csv_output', '', 'Path to output csv')
FLAGS = flags.FLAGS

'''
os.chdir('C:\\Users\\87703\\Desktop\\picture\\test')
path = 'C:\\Users\\87703\\Desktop\\picture\\test'
'''

def xml_to_csv(path):
    xml_list = []
    for xml_file in glob.glob(path + '/*.xml'):
        tree = ET.parse(xml_file)
        root = tree.getroot()
        for member in root.findall('object'):
            value = (root.find('filename').text,
                     int(root.find('size')[0].text),
                     int(root.find('size')[1].text),
                     member[0].text,
                     int(member[4][0].text),
                     int(member[4][1].text),
                     int(member[4][2].text),
                     int(member[4][3].text)
                     )
            xml_list.append(value)
    column_name = ['filename', 'width', 'height', 'class', 'xmin', 'ymin', 'xmax', 'ymax']
    xml_df = pd.DataFrame(xml_list, columns=column_name)
    return xml_df

def main():
    #train_path = '/content/traffic_police/train/annotations'
    #validation_path = '/content/traffic_police/validation/annotations'
    xml_df = xml_to_csv(FLAGS.xml_path)
    xml_df.to_csv(FLAGS.csv_output, index=None)
    #xml_df = xml_to_csv(validation_path)
    #xml_df.to_csv('validation.csv')
    print('Successfully converted xml to csv.')
    
main()
