mmInterface "I2cMaster" 0x00000000 {
    mmRegister "Status" 0x0000 {
        mmField "Enabled" 0 0 R {}
        mmField "Error" 4 7 RW {}
    }
    mmRegister "Control" 0x0004 {
        mmField "Control" 0 0 RW {}
    }
    mmRegister "Data" 0x000C {
        trAddAttribute   repeat 3
        trAddAttribute   repeatoffset 4
        
        mmField "Byte" 0 7 R {
            trAddAttribute   repeat 4
            trAddAttribute   repeatoffset 8
        }
        
    }
}