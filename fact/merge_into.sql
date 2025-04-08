from delta.tables import DeltaTable
from pyspark.sql.functions import col, lead
from pyspark.sql.window import Window

preproc_equipment_df = spark.read.table("preproc_equipmentstatechange")
preproc_amount_df = spark.read.table("prepoc_amountchange")

window_spec = Window.partitionBy("EQUIPMENTNAME").orderBy("DATETIME")

esc_df = preproc_equipment_df.withColumn("starttime", col("DATETIME")) \
    .withColumn("endtime", lead("DATETIME").over(window_spec)) \
    .withColumn("elapse_time", col("endtime").cast("long") - col("starttime").cast("long"))

merged_df = esc_df.join(preproc_amount_df,
                         (esc_df.EQUIPMENTNAME == preproc_amount_df.EQUIPMENTNAME) &
                         (preproc_amount_df.DATETIME >= esc_df.starttime) &
                         (preproc_amount_df.DATETIME < esc_df.endtime),
                         "left") \
    .select(esc_df.EQUIPMENTNAME, "starttime", "endtime", "elapse_time", preproc_amount_df.OUTPUTCOUNT)

delta_table = DeltaTable.forPath(spark, "path_to_hourly_tb")

delta_table.alias("target").merge(
    merged_df.alias("source"),
    "target.EQUIPMENTNAME = source.EQUIPMENTNAME AND target.starttime = source.starttime"
).whenMatchedUpdate(set={
    "endtime": col("source.endtime"),
    "elapse_time": col("source.elapse_time"),
    "OUTPUTCOUNT": col("source.OUTPUTCOUNT")
}).whenNotMatchedInsert(values={
    "EQUIPMENTNAME": col("source.EQUIPMENTNAME"),
    "starttime": col("source.starttime"),
    "endtime": col("source.endtime"),
    "elapse_time": col("source.elapse_time"),
    "OUTPUTCOUNT": col("source.OUTPUTCOUNT")
}).execute()
