import sys
import os
import glob

try:
    spark_home = os.environ['SPARK_HOME']
    pathToPy4j = glob.glob(os.path.join(spark_home, "python", "lib", "py4j-*-src.zip"))[0]
    sys.path.append(os.path.join(os.environ['SPARK_HOME'], "python"))
    sys.path.append(pathToPy4j)
except KeyError:
    print("SPARK_HOME not set")
    sys.exit(1)
except IndexError:
    print("Could not find py4j library")
    sys.exit(1)
