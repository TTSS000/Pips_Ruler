//+------------------------------------------------------------------+
//|                                                Pips_Ruler_YA.mq4 |
//|                                                      googolyenfx |
//|                               http://googolyenfx.blog18.fc2.com/ |
//+------------------------------------------------------------------+
#property copyright "ttss000"
#property link      "https://twitter.com/ttss000"

#property indicator_chart_window

#define WM_MDIGETACTIVE 0x00000229
#import "user32.dll"
  int GetParent(int hWnd);
  int SendMessageW(int hWnd,int Msg,int wParam,int lParam);
#import

string indicator_sname = "Pips_Ruler_YA";
input unsigned int pips_integer = 20;
input unsigned int num_of_labels = 20;
input int LocationX = 2;
input int FontSize = 8;
input string FontName = "Segoe UI Semibold";  //"Segoe UI" "Console" "ＭＳ ゴシック"　"ＭＳ 明朝" "HG行書体" "GungsuhChe"
input color FontColor = DimGray;
string symbol_str;
string text ;

/*-- 変数の宣言 ----------------------------------------------------*/
int ClientHandle = 0; //クライアントウィンドウハンドル保持用
int ThisWinHandle = 0; //Thisウィンドウハンドル保持用
int ParentWinHandle = 0; //Parentウィンドウハンドル保持用

//+------------------------------------------------------------------+
bool ObjectSetTextMQL4(string name,
                       string text,
                       int font_size,
                       string font="",
                       color text_color=CLR_NONE)
  {
   int tmpObjType=(int)ObjectGetInteger(0,name,OBJPROP_TYPE);
   if(tmpObjType!=OBJ_LABEL && tmpObjType!=OBJ_TEXT) return(false);
   if(StringLen(text)>0 && font_size>0)
     {
      if(ObjectSetString(0,name,OBJPROP_TEXT,text)==true
         && ObjectSetInteger(0,name,OBJPROP_FONTSIZE,font_size)==true)
        {
         if((StringLen(font)>0)
            && ObjectSetString(0,name,OBJPROP_FONT,font)==false)
            return(false);
         if(text_color>-1
            && ObjectSetInteger(0,name,OBJPROP_COLOR,text_color)==false)
            return(false);
         return(true);
        }
      return(false);
     }
   return(false);
  }
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
{
//---- indicators
//----
  symbol_str = Symbol();
  return(0);
}
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
{
  for(int i = 1 ; i <= num_of_labels ; i++){
    ObjectDelete(0,indicator_sname + i + "p");
    ObjectDelete(0,indicator_sname + i + "n");
  }
  return(0);
}
//+------------------------------------------------------------------+
void draw_ruler()
{
  double Bid = SymbolInfoDouble(_Symbol,SYMBOL_BID); 
  double Ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK); 

  double avr_bid_ask = (Bid + Ask)/2;
  for(int i = 1 ; i <= num_of_labels ; i++){
    text = "";
    for(int j = 0 ; j < LocationX ; j++){
      text = text + " ";
    }
    text = text + "- " + IntegerToString(i * pips_integer);
	 //Print ("text="+text);
    if (ObjectFind(0,indicator_sname + i + "p") < 0){
      ObjectCreate(0,indicator_sname + i + "p", OBJ_TEXT, 0, iTime(NULL,0,0), avr_bid_ask + PipsToPrice(i*pips_integer));
    }else{
      //ObjectMove(0,indicator_sname + i + "p", OBJ_TEXT, 0, iTime(NULL,0,0), avr_bid_ask + PipsToPrice(i*pips_integer));
      ObjectMove(0,indicator_sname + i + "p",0,iTime(NULL,0,0), avr_bid_ask + PipsToPrice(i*pips_integer));
    }

    if (ObjectFind(0,indicator_sname + i + "n") < 0){
      ObjectCreate(0,indicator_sname + i + "n", OBJ_TEXT, 0, iTime(NULL,0,0), avr_bid_ask - PipsToPrice(i*pips_integer));
    }else{
      ObjectMove(0,indicator_sname + i + "n",  0, iTime(NULL,0,0), avr_bid_ask - PipsToPrice(i*pips_integer));
    }
    //ObjectDelete(0,indicator_sname + i + "p");
    //ObjectDelete(0,indicator_sname + i + "n");
    ObjectSetString(0,indicator_sname + i + "p",OBJPROP_TEXT,text);
    ObjectSetString(0,indicator_sname + i + "p",OBJPROP_FONT,FontName);
    ObjectSetInteger(0,indicator_sname + i + "p",OBJPROP_FONTSIZE,FontSize);
    ObjectSetInteger(0,indicator_sname + i + "p",OBJPROP_COLOR,FontColor);
    //ObjectSetTextMQL4(indicator_sname + i + "p", text, FontSize, FontName, FontColor);
    //ObjectSet(indicator_sname + i + "p", OBJPROP_XDISTANCE, LocationX);
    ObjectSetInteger(0,indicator_sname + i + "p",OBJPROP_ANCHOR,ANCHOR_LEFT);  
    //ObjectSet(indicator_sname + i + "p", OBJPROP_XDISTANCE, LocationX);
    ObjectSetInteger(0,indicator_sname + i + "p",OBJPROP_SELECTABLE,false);     // オブジェクトの選択可否設定

    //ObjectSetTextMQL4(indicator_sname + i + "n", text, FontSize, FontName, FontColor);
    ObjectSetString(0,indicator_sname + i + "n",OBJPROP_TEXT,text);
    ObjectSetString(0,indicator_sname + i + "n",OBJPROP_FONT,FontName);
    ObjectSetInteger(0,indicator_sname + i + "n",OBJPROP_FONTSIZE,FontSize);
    ObjectSetInteger(0,indicator_sname + i + "n",OBJPROP_COLOR,FontColor);
    //ObjectSet(indicator_sname + i + "n", OBJPROP_XDISTANCE, LocationX);
    ObjectSetInteger(0,indicator_sname + i + "n",OBJPROP_ANCHOR,ANCHOR_LEFT);  
    //ObjectSet(indicator_sname + i + "n", OBJPROP_XDISTANCE, LocationX);
    ObjectSetInteger(0,indicator_sname + i + "n",OBJPROP_SELECTABLE,false);     // オブジェクトの選択可否設定
  }
}

//+------------------------------------------------------------------+
void OnTimer()
{

}
//+------------------------------------------------------------------+

//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
//int start()
//{
//  draw_ruler();
//  return(0);
//}
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//---
  draw_ruler();
   
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
//| pipsを価格に換算する関数
//+------------------------------------------------------------------+
double PipsToPrice(double pips)
{
  double price = 0;

  // 現在の通貨ペアの小数点以下の桁数を取得
  //int digits = (int)MarketInfo(symbol_str, MODE_DIGITS);
  int digits = Digits();

  // 3桁・5桁のFXブローカー
  if(digits == 3 || digits == 5){
    price = pips / MathPow(10, digits) * 10;
  }
  // 2桁・4桁のFXブローカー
  if(digits == 2 || digits == 4){
    price = pips / MathPow(10, digits-1);
  }
  // 価格を有効桁数で丸める
  price = NormalizeDouble(price, digits);
  return(price);
}
//+------------------------------------------------------------------+
