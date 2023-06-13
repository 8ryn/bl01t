cd "$(TOP)"

dbLoadDatabase "dbd/ioc.dbd"
ioc_registerRecordDeviceDriver(pdbbase)

# simDetectorConfig(portName, maxSizeX, maxSizeY, dataType, maxBuffers, maxMemory)
simDetectorConfig("bar.CAM", 2560, 2160, 1, 50, 0)

# NDPvaConfigure(portName, queueSize, blockingCallbacks, NDArrayPort, NDArrayAddr, pvName, maxMemory, priority, stackSize)
NDPvaConfigure("bar.PVA", 2, 0, "bar.CAM", 0, "bar-EA-TST-01:IMAGE", 0, 0, 0)
startPVAServer

# instantiate Database records for Sim Detector
dbLoadRecords (simDetector.template, "P=bar-EA-TST-01, R=:CAM:, PORT=bar.CAM, TIMEOUT=1, ADDR=0")
dbLoadRecords (NDPva.template, "P=bar-EA-TST-01, R=:PVA:, PORT=bar.PVA, ADDR=0, TIMEOUT=1, NDARRAY_PORT=bar.CAM, NDARRAY_ADR=0, ENABLED=1")
# also make Database records for DEVIOCSTATS
dbLoadRecords(iocAdminSoft.db, "IOC=bar-EA-IOC-01")
dbLoadRecords(iocAdminScanMon.db, "IOC=bar-EA-IOC-01")

# start IOC shell
iocInit

# poke some records
dbpf "bar-EA-TST-01:CAM:AcquirePeriod", "0.1"
