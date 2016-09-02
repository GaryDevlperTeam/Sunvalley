/**
*Dis:数据处理格式化
*Author：Gary_Hu
*Time:2013年3月28日10:25:13
**/
public class DataFormat {
    //输出指定长度的字符串,前面用0补充
    public String IntToString(Integer intNumber, Integer length)
    {
        String strNumber = String.valueOf(intNumber);
        String strFormat = '';
        Integer intNumberLength = strNumber.length();
        for(Integer i=0;i<length-intNumberLength; i++)
        {
            strFormat += '0';
        }
        return strFormat + strNumber;
    }
}