<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE eagle SYSTEM "eagle.dtd">
<eagle version="6.2">
<drawing>
<settings>
<setting alwaysvectorfont="no"/>
<setting verticaltext="up"/>
</settings>
<grid distance="0.1" unitdist="inch" unit="inch" style="lines" multiple="1" display="no" altdistance="0.01" altunitdist="inch" altunit="inch"/>
<layers>
<layer number="1" name="Top" color="4" fill="1" visible="no" active="no"/>
<layer number="2" name="Route2" color="1" fill="3" visible="no" active="no"/>
<layer number="3" name="Route3" color="4" fill="3" visible="no" active="no"/>
<layer number="14" name="Route14" color="1" fill="6" visible="no" active="no"/>
<layer number="15" name="Route15" color="4" fill="6" visible="no" active="no"/>
<layer number="16" name="Bottom" color="1" fill="1" visible="no" active="no"/>
<layer number="17" name="Pads" color="2" fill="1" visible="no" active="no"/>
<layer number="18" name="Vias" color="2" fill="1" visible="no" active="no"/>
<layer number="19" name="Unrouted" color="6" fill="1" visible="no" active="no"/>
<layer number="20" name="Dimension" color="15" fill="1" visible="no" active="no"/>
<layer number="21" name="tPlace" color="7" fill="1" visible="no" active="no"/>
<layer number="22" name="bPlace" color="7" fill="1" visible="no" active="no"/>
<layer number="23" name="tOrigins" color="15" fill="1" visible="no" active="no"/>
<layer number="24" name="bOrigins" color="15" fill="1" visible="no" active="no"/>
<layer number="25" name="tNames" color="7" fill="1" visible="no" active="no"/>
<layer number="26" name="bNames" color="7" fill="1" visible="no" active="no"/>
<layer number="27" name="tValues" color="7" fill="1" visible="no" active="no"/>
<layer number="28" name="bValues" color="7" fill="1" visible="no" active="no"/>
<layer number="29" name="tStop" color="7" fill="3" visible="no" active="no"/>
<layer number="30" name="bStop" color="7" fill="6" visible="no" active="no"/>
<layer number="31" name="tCream" color="7" fill="4" visible="no" active="no"/>
<layer number="32" name="bCream" color="7" fill="5" visible="no" active="no"/>
<layer number="33" name="tFinish" color="6" fill="3" visible="no" active="no"/>
<layer number="34" name="bFinish" color="6" fill="6" visible="no" active="no"/>
<layer number="35" name="tGlue" color="7" fill="4" visible="no" active="no"/>
<layer number="36" name="bGlue" color="7" fill="5" visible="no" active="no"/>
<layer number="37" name="tTest" color="7" fill="1" visible="no" active="no"/>
<layer number="38" name="bTest" color="7" fill="1" visible="no" active="no"/>
<layer number="39" name="tKeepout" color="4" fill="11" visible="no" active="no"/>
<layer number="40" name="bKeepout" color="1" fill="11" visible="no" active="no"/>
<layer number="41" name="tRestrict" color="4" fill="10" visible="no" active="no"/>
<layer number="42" name="bRestrict" color="1" fill="10" visible="no" active="no"/>
<layer number="43" name="vRestrict" color="2" fill="10" visible="no" active="no"/>
<layer number="44" name="Drills" color="7" fill="1" visible="no" active="no"/>
<layer number="45" name="Holes" color="7" fill="1" visible="no" active="no"/>
<layer number="46" name="Milling" color="3" fill="1" visible="no" active="no"/>
<layer number="47" name="Measures" color="7" fill="1" visible="no" active="no"/>
<layer number="48" name="Document" color="7" fill="1" visible="no" active="no"/>
<layer number="49" name="Reference" color="7" fill="1" visible="no" active="no"/>
<layer number="51" name="tDocu" color="6" fill="9" visible="no" active="no"/>
<layer number="52" name="bDocu" color="7" fill="1" visible="no" active="no"/>
<layer number="91" name="Nets" color="2" fill="1" visible="yes" active="yes"/>
<layer number="92" name="Busses" color="1" fill="1" visible="yes" active="yes"/>
<layer number="93" name="Pins" color="2" fill="1" visible="no" active="yes"/>
<layer number="94" name="Symbols" color="4" fill="1" visible="yes" active="yes"/>
<layer number="95" name="Names" color="7" fill="1" visible="yes" active="yes"/>
<layer number="96" name="Values" color="7" fill="1" visible="yes" active="yes"/>
<layer number="97" name="Info" color="7" fill="1" visible="yes" active="yes"/>
<layer number="98" name="Guide" color="6" fill="1" visible="yes" active="yes"/>
</layers>
<schematic xreflabel="%F%N/%S.%C%R" xrefpart="/%S.%C%R">
<libraries>
<library name="atmel">
<description>&lt;b&gt;AVR Devices&lt;/b&gt;&lt;p&gt;
Configurable logic, microcontrollers, nonvolatile memories&lt;p&gt;
Based on the following sources:&lt;p&gt;
&lt;ul&gt;
&lt;li&gt;www.atmel.com
&lt;li&gt;CD-ROM : Configurable Logic Microcontroller Nonvolatile Memory
&lt;li&gt;CadSoft download site, www.cadsoft.de or www.cadsoftusa.com , file at90smcu_v400.zip
&lt;li&gt;avr.lbr
&lt;/ul&gt;
&lt;author&gt;Revised by librarian@cadsoft.de&lt;/author&gt;</description>
<packages>
<package name="DIL08">
<description>&lt;B&gt;Dual In Line&lt;/B&gt;</description>
<wire x1="-5.08" y1="-0.635" x2="-5.08" y2="0.635" width="0.1524" layer="21" curve="180"/>
<wire x1="-5.08" y1="-0.635" x2="-5.08" y2="-2.794" width="0.1524" layer="21"/>
<wire x1="-5.08" y1="-2.794" x2="5.08" y2="-2.794" width="0.1524" layer="21"/>
<wire x1="5.08" y1="-2.794" x2="5.08" y2="2.794" width="0.1524" layer="21"/>
<wire x1="5.08" y1="2.794" x2="-5.08" y2="2.794" width="0.1524" layer="21"/>
<wire x1="-5.08" y1="2.794" x2="-5.08" y2="0.635" width="0.1524" layer="21"/>
<pad name="1" x="-3.81" y="-3.81" drill="0.8128" shape="long" rot="R90"/>
<pad name="2" x="-1.27" y="-3.81" drill="0.8128" shape="long" rot="R90"/>
<pad name="3" x="1.27" y="-3.81" drill="0.8128" shape="long" rot="R90"/>
<pad name="4" x="3.81" y="-3.81" drill="0.8128" shape="long" rot="R90"/>
<pad name="5" x="3.81" y="3.81" drill="0.8128" shape="long" rot="R90"/>
<pad name="6" x="1.27" y="3.81" drill="0.8128" shape="long" rot="R90"/>
<pad name="7" x="-1.27" y="3.81" drill="0.8128" shape="long" rot="R90"/>
<pad name="8" x="-3.81" y="3.81" drill="0.8128" shape="long" rot="R90"/>
<text x="-5.3594" y="-2.54" size="1.27" layer="25" ratio="10" rot="R90">&gt;NAME</text>
<text x="-3.81" y="-0.9906" size="1.27" layer="27" ratio="10">&gt;VALUE</text>
</package>
<package name="8S1">
<description>&lt;b&gt;8S1&lt;/b&gt; 8-lead (0.150" Wide Body)&lt;p&gt;
Plastic Gull Wing Small Outline (JEDEC SOIC)&lt;br&gt;
Source: http://www.atmel.com/dyn/resources/prod_documents/2535S.pdf</description>
<wire x1="-2.425" y1="1.675" x2="-2.175" y2="1.925" width="0.1524" layer="51" curve="-90"/>
<wire x1="2.175" y1="1.925" x2="2.425" y2="1.675" width="0.1524" layer="51" curve="-90"/>
<wire x1="2.175" y1="-1.925" x2="2.425" y2="-1.675" width="0.1524" layer="51" curve="90"/>
<wire x1="-2.425" y1="-1.675" x2="-2.175" y2="-1.925" width="0.1524" layer="51" curve="90"/>
<wire x1="-1.59" y1="1.925" x2="-0.95" y2="1.925" width="0.1524" layer="51"/>
<wire x1="-2.165" y1="1.925" x2="2.185" y2="1.925" width="0.1524" layer="51"/>
<wire x1="0.95" y1="1.925" x2="1.59" y2="1.925" width="0.1524" layer="51"/>
<wire x1="2.21" y1="1.925" x2="2.185" y2="1.925" width="0.1524" layer="21"/>
<wire x1="2.2" y1="-1.925" x2="2.185" y2="-1.925" width="0.1524" layer="51"/>
<wire x1="2.185" y1="-1.925" x2="2.155" y2="-1.925" width="0.1524" layer="51"/>
<wire x1="1.59" y1="-1.925" x2="0.94" y2="-1.925" width="0.1524" layer="51"/>
<wire x1="0.32" y1="-1.925" x2="-0.33" y2="-1.925" width="0.1524" layer="51"/>
<wire x1="2.185" y1="-1.925" x2="-2.165" y2="-1.925" width="0.1524" layer="51"/>
<wire x1="-2.425" y1="1.675" x2="-2.425" y2="-1.665" width="0.1524" layer="21"/>
<wire x1="2.425" y1="-1.675" x2="2.425" y2="1.675" width="0.1524" layer="21"/>
<circle x="-1.42" y="-1.115" radius="0.5" width="0.0508" layer="21"/>
<smd name="1" x="-1.905" y="-2.654" dx="0.6" dy="1.6" layer="1"/>
<smd name="2" x="-0.645" y="-2.654" dx="0.6" dy="1.6" layer="1"/>
<smd name="3" x="0.625" y="-2.654" dx="0.6" dy="1.6" layer="1"/>
<smd name="4" x="1.895" y="-2.654" dx="0.6" dy="1.6" layer="1"/>
<smd name="8" x="-1.905" y="2.654" dx="0.6" dy="1.6" layer="1"/>
<smd name="7" x="-0.635" y="2.654" dx="0.6" dy="1.6" layer="1"/>
<smd name="6" x="0.635" y="2.654" dx="0.6" dy="1.6" layer="1"/>
<smd name="5" x="1.905" y="2.654" dx="0.6" dy="1.6" layer="1"/>
<text x="-2.8575" y="-2.159" size="1.27" layer="25" ratio="10" rot="R90">&gt;NAME</text>
<text x="4.064" y="-2.159" size="1.27" layer="27" ratio="10" rot="R90">&gt;VALUE</text>
<rectangle x1="-2.08" y1="1.975" x2="-1.73" y2="3.075" layer="51"/>
<rectangle x1="-0.81" y1="1.975" x2="-0.46" y2="3.075" layer="51"/>
<rectangle x1="0.46" y1="1.975" x2="0.81" y2="3.075" layer="51"/>
<rectangle x1="1.73" y1="1.975" x2="2.08" y2="3.075" layer="51"/>
<rectangle x1="1.72" y1="-3.075" x2="2.07" y2="-1.975" layer="51"/>
<rectangle x1="0.45" y1="-3.075" x2="0.8" y2="-1.975" layer="51"/>
<rectangle x1="-0.82" y1="-3.075" x2="-0.47" y2="-1.975" layer="51"/>
<rectangle x1="-2.08" y1="-3.075" x2="-1.73" y2="-1.975" layer="51"/>
</package>
<package name="8S2">
<description>&lt;b&gt;8S2&lt;/b&gt; 8-lead, 0.208 Body&lt;p&gt;
Plastic Small Outline Package (EIAJ)&lt;br&gt;
Source: http://www.atmel.com/dyn/resources/prod_documents/2535S.pdf</description>
<wire x1="-2.6" y1="2.65" x2="-2.35" y2="2.9" width="0.1524" layer="21" curve="-90"/>
<wire x1="2.35" y1="2.9" x2="2.6" y2="2.65" width="0.1524" layer="21" curve="-90"/>
<wire x1="2.35" y1="-2.925" x2="2.6" y2="-2.675" width="0.1524" layer="21" curve="90"/>
<wire x1="-2.6" y1="-2.675" x2="-2.35" y2="-2.925" width="0.1524" layer="21" curve="90"/>
<wire x1="2.36" y1="-2.925" x2="-2.34" y2="-2.925" width="0.1524" layer="51"/>
<wire x1="-2.34" y1="2.9" x2="2.36" y2="2.9" width="0.1524" layer="51"/>
<wire x1="-2.21" y1="2.9" x2="-2.34" y2="2.9" width="0.1524" layer="21"/>
<wire x1="-1.59" y1="2.9" x2="-0.95" y2="2.9" width="0.1524" layer="21"/>
<wire x1="-0.32" y1="2.9" x2="0.32" y2="2.9" width="0.1524" layer="21"/>
<wire x1="0.95" y1="2.9" x2="1.59" y2="2.9" width="0.1524" layer="21"/>
<wire x1="2.21" y1="2.9" x2="2.36" y2="2.9" width="0.1524" layer="21"/>
<wire x1="2.2" y1="-2.925" x2="2.33" y2="-2.925" width="0.1524" layer="21"/>
<wire x1="1.59" y1="-2.925" x2="0.94" y2="-2.925" width="0.1524" layer="21"/>
<wire x1="0.32" y1="-2.925" x2="-0.33" y2="-2.925" width="0.1524" layer="21"/>
<wire x1="-0.95" y1="-2.925" x2="-1.59" y2="-2.925" width="0.1524" layer="21"/>
<wire x1="-2.21" y1="-2.925" x2="-2.34" y2="-2.925" width="0.1524" layer="21"/>
<wire x1="-2.6" y1="2.65" x2="-2.6" y2="-2.665" width="0.1524" layer="21"/>
<wire x1="2.6" y1="-2.675" x2="2.6" y2="2.65" width="0.1524" layer="21"/>
<circle x="-1.42" y="-1.115" radius="0.5" width="0.0508" layer="21"/>
<smd name="1" x="-1.905" y="-3.404" dx="0.5" dy="1.4" layer="1"/>
<smd name="2" x="-0.645" y="-3.404" dx="0.5" dy="1.4" layer="1"/>
<smd name="3" x="0.625" y="-3.404" dx="0.5" dy="1.4" layer="1"/>
<smd name="4" x="1.895" y="-3.404" dx="0.5" dy="1.4" layer="1"/>
<smd name="8" x="-1.905" y="3.404" dx="0.5" dy="1.4" layer="1"/>
<smd name="7" x="-0.635" y="3.404" dx="0.5" dy="1.4" layer="1"/>
<smd name="6" x="0.635" y="3.404" dx="0.5" dy="1.4" layer="1"/>
<smd name="5" x="1.905" y="3.404" dx="0.5" dy="1.4" layer="1"/>
<text x="-2.8575" y="-2.159" size="1.27" layer="25" ratio="10" rot="R90">&gt;NAME</text>
<text x="4.064" y="-2.159" size="1.27" layer="27" ratio="10" rot="R90">&gt;VALUE</text>
<rectangle x1="-2.08" y1="2.95" x2="-1.73" y2="3.85" layer="51"/>
<rectangle x1="-0.81" y1="2.95" x2="-0.46" y2="3.85" layer="51"/>
<rectangle x1="0.46" y1="2.95" x2="0.81" y2="3.85" layer="51"/>
<rectangle x1="1.73" y1="2.95" x2="2.08" y2="3.85" layer="51"/>
<rectangle x1="1.72" y1="-3.85" x2="2.07" y2="-2.95" layer="51"/>
<rectangle x1="0.45" y1="-3.85" x2="0.8" y2="-2.95" layer="51"/>
<rectangle x1="-0.82" y1="-3.85" x2="-0.47" y2="-2.95" layer="51"/>
<rectangle x1="-2.08" y1="-3.85" x2="-1.73" y2="-2.95" layer="51"/>
</package>
</packages>
<symbols>
<symbol name="TINY13">
<wire x1="-17.78" y1="15.24" x2="25.4" y2="15.24" width="0.254" layer="94"/>
<wire x1="25.4" y1="15.24" x2="25.4" y2="-7.62" width="0.254" layer="94"/>
<wire x1="25.4" y1="-7.62" x2="-17.78" y2="-7.62" width="0.254" layer="94"/>
<wire x1="-17.78" y1="-7.62" x2="-17.78" y2="15.24" width="0.254" layer="94"/>
<text x="-17.78" y="16.51" size="1.778" layer="95">&gt;NAME</text>
<text x="-17.78" y="-10.16" size="1.778" layer="96">&gt;VALUE</text>
<pin name="PB5/PCINT5/!RESET!/ADC0/DW" x="-20.32" y="-2.54" length="short"/>
<pin name="PB3/PCINT3/CLKI/ADC3" x="-20.32" y="2.54" length="short"/>
<pin name="PB4/PCINT4/ADC2" x="-20.32" y="0" length="short"/>
<pin name="PB0/PCINT0/AIN0/OC0A/MOSI" x="-20.32" y="10.16" length="short"/>
<pin name="PB1/PCINT1/AIN1/OC0B/INT0/MISO" x="-20.32" y="7.62" length="short"/>
<pin name="PB2/PCINT2/SCK/ADC1/T0" x="-20.32" y="5.08" length="short"/>
<pin name="VCC" x="-20.32" y="12.7" length="short" direction="pwr"/>
<pin name="GND" x="-20.32" y="-5.08" length="short" direction="pwr"/>
</symbol>
</symbols>
<devicesets>
<deviceset name="TINY13" prefix="IC">
<description>&lt;b&gt; 8-bit AVR Microcontroller with 1K Bytes In-System Programmable Flash&lt;/b&gt;&lt;p&gt;
Source: http://www.atmel.com/dyn/resources/prod_documents/2535S.pdf</description>
<gates>
<gate name="G$1" symbol="TINY13" x="0" y="0"/>
</gates>
<devices>
<device name="PU" package="DIL08">
<connects>
<connect gate="G$1" pin="GND" pad="4"/>
<connect gate="G$1" pin="PB0/PCINT0/AIN0/OC0A/MOSI" pad="5"/>
<connect gate="G$1" pin="PB1/PCINT1/AIN1/OC0B/INT0/MISO" pad="6"/>
<connect gate="G$1" pin="PB2/PCINT2/SCK/ADC1/T0" pad="7"/>
<connect gate="G$1" pin="PB3/PCINT3/CLKI/ADC3" pad="2"/>
<connect gate="G$1" pin="PB4/PCINT4/ADC2" pad="3"/>
<connect gate="G$1" pin="PB5/PCINT5/!RESET!/ADC0/DW" pad="1"/>
<connect gate="G$1" pin="VCC" pad="8"/>
</connects>
<technologies>
<technology name="-20">
<attribute name="MF" value="" constant="no"/>
<attribute name="MPN" value="ATTINY13-20PU" constant="no"/>
<attribute name="OC_FARNELL" value="9171550" constant="no"/>
<attribute name="OC_NEWARK" value="96K6521" constant="no"/>
</technology>
<technology name="V-10">
<attribute name="MF" value="" constant="no"/>
<attribute name="MPN" value="ATTINY13V-10PU" constant="no"/>
<attribute name="OC_FARNELL" value="9171576" constant="no"/>
<attribute name="OC_NEWARK" value="96K6523" constant="no"/>
</technology>
</technologies>
</device>
<device name="SSU" package="8S1">
<connects>
<connect gate="G$1" pin="GND" pad="4"/>
<connect gate="G$1" pin="PB0/PCINT0/AIN0/OC0A/MOSI" pad="5"/>
<connect gate="G$1" pin="PB1/PCINT1/AIN1/OC0B/INT0/MISO" pad="6"/>
<connect gate="G$1" pin="PB2/PCINT2/SCK/ADC1/T0" pad="7"/>
<connect gate="G$1" pin="PB3/PCINT3/CLKI/ADC3" pad="2"/>
<connect gate="G$1" pin="PB4/PCINT4/ADC2" pad="3"/>
<connect gate="G$1" pin="PB5/PCINT5/!RESET!/ADC0/DW" pad="1"/>
<connect gate="G$1" pin="VCC" pad="8"/>
</connects>
<technologies>
<technology name="-20">
<attribute name="MF" value="" constant="no"/>
<attribute name="MPN" value="ATTINY13-20SSU" constant="no"/>
<attribute name="OC_FARNELL" value="1455133" constant="no"/>
<attribute name="OC_NEWARK" value="58M3771" constant="no"/>
</technology>
<technology name="V-10">
<attribute name="MF" value="" constant="no"/>
<attribute name="MPN" value="ATTINY13V-10SSU" constant="no"/>
<attribute name="OC_FARNELL" value="1455135" constant="no"/>
<attribute name="OC_NEWARK" value="58M3773" constant="no"/>
</technology>
</technologies>
</device>
<device name="SU" package="8S2">
<connects>
<connect gate="G$1" pin="GND" pad="4"/>
<connect gate="G$1" pin="PB0/PCINT0/AIN0/OC0A/MOSI" pad="5"/>
<connect gate="G$1" pin="PB1/PCINT1/AIN1/OC0B/INT0/MISO" pad="6"/>
<connect gate="G$1" pin="PB2/PCINT2/SCK/ADC1/T0" pad="7"/>
<connect gate="G$1" pin="PB3/PCINT3/CLKI/ADC3" pad="2"/>
<connect gate="G$1" pin="PB4/PCINT4/ADC2" pad="3"/>
<connect gate="G$1" pin="PB5/PCINT5/!RESET!/ADC0/DW" pad="1"/>
<connect gate="G$1" pin="VCC" pad="8"/>
</connects>
<technologies>
<technology name="-20">
<attribute name="MF" value="" constant="no"/>
<attribute name="MPN" value="ATTINY13-20SU" constant="no"/>
<attribute name="OC_FARNELL" value="9171568" constant="no"/>
<attribute name="OC_NEWARK" value="96K6522" constant="no"/>
</technology>
<technology name="V-10">
<attribute name="MF" value="" constant="no"/>
<attribute name="MPN" value="ATTINY13V-10SU" constant="no"/>
<attribute name="OC_FARNELL" value="9171584" constant="no"/>
<attribute name="OC_NEWARK" value="96K6524" constant="no"/>
</technology>
</technologies>
</device>
</devices>
</deviceset>
</devicesets>
</library>
<library name="74xx-little-de">
<description>&lt;b&gt;Single and Dual Gates Family, US symbols&lt;/b&gt;&lt;p&gt;
Little logic devices from Texas Instruments&lt;br&gt;
TinyLogic(R) from FAIRCHILD Semiconductor TM
&lt;p&gt;
&lt;author&gt;Created by evgeni@eniks.com&lt;/author&gt;&lt;br&gt;
&lt;author&gt;Extended by librarian@cadsoft.de&lt;/author&gt;</description>
<packages>
<package name="SOT23-5">
<description>&lt;b&gt;Small Outline Transistor&lt;/b&gt;&lt;p&gt;
SOT753 - Philips Semiconductors&lt;br&gt;
Source: http://www.semiconductors.philips.com/acrobat_download/datasheets/74HC_HCT1G66_3.pdf</description>
<wire x1="0" y1="-1.29" x2="0" y2="-1.3" width="0.01" layer="21"/>
<wire x1="1.42" y1="0.8" x2="1.42" y2="-0.8" width="0.127" layer="21"/>
<wire x1="1.42" y1="-0.8" x2="-1.42" y2="-0.8" width="0.127" layer="51"/>
<wire x1="-1.42" y1="-0.8" x2="-1.42" y2="0.8" width="0.127" layer="21"/>
<wire x1="-1.42" y1="0.8" x2="1.42" y2="0.8" width="0.127" layer="51"/>
<wire x1="-1.27" y1="0.65" x2="1.28" y2="0.65" width="0.075" layer="21"/>
<wire x1="1.28" y1="0.65" x2="1.28" y2="-0.66" width="0.075" layer="21"/>
<wire x1="1.28" y1="-0.66" x2="-1.27" y2="-0.66" width="0.075" layer="21"/>
<wire x1="-1.27" y1="-0.66" x2="-1.27" y2="0.65" width="0.075" layer="21"/>
<wire x1="-1.75" y1="2.25" x2="1.75" y2="2.25" width="0.254" layer="39"/>
<wire x1="1.75" y1="2.25" x2="1.75" y2="-2.25" width="0.254" layer="39"/>
<wire x1="1.75" y1="-2.25" x2="-1.75" y2="-2.25" width="0.254" layer="39"/>
<wire x1="-1.75" y1="-2.25" x2="-1.75" y2="2.25" width="0.254" layer="39"/>
<smd name="1" x="-0.95" y="-1.29" dx="0.69" dy="0.99" layer="1"/>
<smd name="2" x="0" y="-1.29" dx="0.69" dy="0.99" layer="1"/>
<smd name="3" x="0.95" y="-1.29" dx="0.69" dy="0.99" layer="1"/>
<smd name="4" x="0.95" y="1.3" dx="0.69" dy="0.99" layer="1"/>
<smd name="5" x="-0.95" y="1.3" dx="0.69" dy="0.99" layer="1"/>
<text x="-2.54" y="2.54" size="1.27" layer="25">&gt;NAME</text>
<text x="-2.54" y="-3.81" size="1.27" layer="27">&gt;VALUE</text>
<rectangle x1="-1.11" y1="0.68" x2="-0.78" y2="1.43" layer="51"/>
<rectangle x1="0.79" y1="0.67" x2="1.12" y2="1.42" layer="51"/>
<rectangle x1="-1.11" y1="-1.42" x2="-0.78" y2="-0.67" layer="51"/>
<rectangle x1="-0.16" y1="-1.42" x2="0.17" y2="-0.67" layer="51"/>
<rectangle x1="0.79" y1="-1.42" x2="1.12" y2="-0.67" layer="51"/>
</package>
<package name="SC70-5">
<description>&lt;b&gt;SMT SC70-5&lt;/b&gt;&lt;p&gt;
SOT353 - Philips Semiconductors&lt;br&gt;
Source: http://www.semiconductors.philips.com/acrobat_download/datasheets/74HC_HCT1G66_3.pdf</description>
<wire x1="1" y1="0.55" x2="-1" y2="0.55" width="0.127" layer="51"/>
<wire x1="-1" y1="0.55" x2="-1" y2="-0.55" width="0.127" layer="21"/>
<wire x1="-1" y1="-0.55" x2="1" y2="-0.55" width="0.127" layer="51"/>
<wire x1="1" y1="-0.55" x2="1" y2="0.55" width="0.127" layer="21"/>
<smd name="1" x="-0.65" y="-0.85" dx="0.4" dy="0.7" layer="1"/>
<smd name="2" x="0" y="-0.85" dx="0.4" dy="0.7" layer="1"/>
<smd name="3" x="0.65" y="-0.85" dx="0.4" dy="0.7" layer="1"/>
<smd name="4" x="0.65" y="0.85" dx="0.4" dy="0.7" layer="1"/>
<smd name="5" x="-0.65" y="0.85" dx="0.4" dy="0.7" layer="1"/>
<text x="-2.54" y="1.27" size="1.27" layer="25">&gt;NAME</text>
<text x="-2.54" y="-2.54" size="1.27" layer="27">&gt;VALUE</text>
<rectangle x1="-0.125" y1="-1.05" x2="0.125" y2="-0.6" layer="51"/>
<rectangle x1="-0.775" y1="-1.05" x2="-0.525" y2="-0.6" layer="51"/>
<rectangle x1="0.525" y1="-1.05" x2="0.775" y2="-0.6" layer="51"/>
<rectangle x1="-0.775" y1="0.6" x2="-0.525" y2="1.05" layer="51"/>
<rectangle x1="0.525" y1="0.6" x2="0.775" y2="1.05" layer="51"/>
</package>
</packages>
<symbols>
<symbol name="7400">
<wire x1="-2.54" y1="5.08" x2="-2.54" y2="-5.08" width="0.4064" layer="94"/>
<wire x1="-2.54" y1="5.08" x2="-2.54" y2="-5.08" width="0.4064" layer="94" curve="-180"/>
<text x="-2.54" y="5.715" size="1.778" layer="95">&gt;NAME</text>
<text x="-2.54" y="-7.62" size="1.778" layer="96">&gt;VALUE</text>
<pin name="I0" x="-5.08" y="2.54" visible="pad" length="short" direction="in" swaplevel="1"/>
<pin name="I1" x="-5.08" y="-2.54" visible="pad" length="short" direction="in" swaplevel="1"/>
<pin name="O" x="7.62" y="0" visible="pad" length="middle" direction="out" function="dot" rot="R180"/>
</symbol>
<symbol name="PWRN">
<text x="-0.635" y="-0.635" size="1.778" layer="95">&gt;NAME</text>
<text x="1.905" y="-6.35" size="1.27" layer="95" rot="R90">GND</text>
<text x="1.905" y="2.54" size="1.27" layer="95" rot="R90">VCC</text>
<pin name="GND" x="0" y="-7.62" visible="pad" length="middle" direction="pwr" rot="R90"/>
<pin name="VCC" x="0" y="7.62" visible="pad" length="middle" direction="pwr" rot="R270"/>
</symbol>
</symbols>
<devicesets>
<deviceset name="74*1G00" prefix="IC">
<description>2-input &lt;b&gt;NAND&lt;/b&gt; gate</description>
<gates>
<gate name="A" symbol="7400" x="20.32" y="0"/>
<gate name="P" symbol="PWRN" x="2.54" y="-5.08" addlevel="request"/>
</gates>
<devices>
<device name="DBV" package="SOT23-5">
<connects>
<connect gate="A" pin="I0" pad="1"/>
<connect gate="A" pin="I1" pad="2"/>
<connect gate="A" pin="O" pad="4"/>
<connect gate="P" pin="GND" pad="3"/>
<connect gate="P" pin="VCC" pad="5"/>
</connects>
<technologies>
<technology name="AHC"/>
<technology name="AHCT"/>
<technology name="AUC"/>
<technology name="LVC"/>
</technologies>
</device>
<device name="DCK" package="SC70-5">
<connects>
<connect gate="A" pin="I0" pad="1"/>
<connect gate="A" pin="I1" pad="2"/>
<connect gate="A" pin="O" pad="4"/>
<connect gate="P" pin="GND" pad="3"/>
<connect gate="P" pin="VCC" pad="5"/>
</connects>
<technologies>
<technology name="AHC"/>
<technology name="AHCT"/>
<technology name="AUC"/>
<technology name="LVC"/>
</technologies>
</device>
</devices>
</deviceset>
</devicesets>
</library>
<library name="LB1937M">
<packages>
<package name="SSOP10">
<description>&lt;b&gt;SSOP10&lt;/b&gt;&lt;p&gt;
Auto generated by &lt;i&gt;make-symbol-device-package-bsdl.ulp Rev. 43&lt;/i&gt;&lt;br&gt;</description>
<smd name="1" x="-3.2" y="2" dx="0" dy="0" layer="1"/>
<rectangle x1="-3.2" y1="1.825" x2="-2.2" y2="2.175" layer="51"/>
<smd name="2" x="-3.2" y="1" dx="0" dy="0" layer="1"/>
<rectangle x1="-3.2" y1="0.825" x2="-2.2" y2="1.175" layer="51"/>
<smd name="3" x="-3.2" y="0" dx="0" dy="0" layer="1"/>
<rectangle x1="-3.2" y1="-0.175" x2="-2.2" y2="0.175" layer="51"/>
<smd name="4" x="-3.2" y="-1" dx="0" dy="0" layer="1"/>
<rectangle x1="-3.2" y1="-1.175" x2="-2.2" y2="-0.825" layer="51"/>
<smd name="5" x="-3.2" y="-2" dx="0" dy="0" layer="1"/>
<rectangle x1="-3.2" y1="-2.175" x2="-2.2" y2="-1.825" layer="51"/>
<smd name="6" x="3.2" y="-2" dx="0" dy="0" layer="1"/>
<rectangle x1="2.2" y1="-2.175" x2="3.2" y2="-1.825" layer="51"/>
<smd name="7" x="3.2" y="-1" dx="0" dy="0" layer="1"/>
<rectangle x1="2.2" y1="-1.175" x2="3.2" y2="-0.825" layer="51"/>
<smd name="8" x="3.2" y="0" dx="0" dy="0" layer="1"/>
<rectangle x1="2.2" y1="-0.175" x2="3.2" y2="0.175" layer="51"/>
<smd name="9" x="3.2" y="1" dx="0" dy="0" layer="1"/>
<rectangle x1="2.2" y1="0.825" x2="3.2" y2="1.175" layer="51"/>
<smd name="10" x="3.2" y="2" dx="0" dy="0" layer="1"/>
<rectangle x1="2.2" y1="1.825" x2="3.2" y2="2.175" layer="51"/>
<wire x1="-2.0984" y1="-2.3984" x2="2.0984" y2="-2.3984" width="0.2032" layer="21"/>
<wire x1="2.0984" y1="-2.3984" x2="2.0984" y2="2.3984" width="0.2032" layer="21"/>
<wire x1="2.0984" y1="2.3984" x2="-2.0984" y2="2.3984" width="0.2032" layer="21"/>
<wire x1="-2.0984" y1="2.3984" x2="-2.0984" y2="-2.3984" width="0.2032" layer="21"/>
<text x="-3.2" y="0.635" size="1.27" layer="25">&gt;NAME</text>
<text x="-3.2" y="-1.905" size="1.27" layer="27">&gt;VALUE</text>
</package>
</packages>
<symbols>
<symbol name="LB1973M">
<pin name="VCC" x="-30.48" y="5.08" length="short" direction="pwr"/>
<pin name="IN4" x="-30.48" y="2.54" length="short" direction="in"/>
<pin name="IN3" x="-30.48" y="0" length="short" direction="in"/>
<pin name="IN1" x="-30.48" y="-2.54" length="short" direction="in"/>
<pin name="IN2" x="-30.48" y="-5.08" length="short" direction="in"/>
<pin name="GND" x="30.48" y="-5.08" length="short" direction="pwr" rot="R180"/>
<pin name="OUT2" x="30.48" y="-2.54" length="short" direction="out" rot="R180"/>
<pin name="OUT1" x="30.48" y="0" length="short" direction="out" rot="R180"/>
<pin name="OUT3" x="30.48" y="2.54" length="short" direction="out" rot="R180"/>
<pin name="OUT4" x="30.48" y="5.08" length="short" direction="out" rot="R180"/>
<wire x1="-27.94" y1="-7.62" x2="27.94" y2="-7.62" width="0.254" layer="94"/>
<wire x1="27.94" y1="-7.62" x2="27.94" y2="7.62" width="0.254" layer="94"/>
<wire x1="27.94" y1="7.62" x2="-27.94" y2="7.62" width="0.254" layer="94"/>
<wire x1="-27.94" y1="7.62" x2="-27.94" y2="-7.62" width="0.254" layer="94"/>
<text x="-2.54" y="1.27" size="1.778" layer="95">&gt;NAME</text>
<text x="-2.54" y="-2.54" size="1.778" layer="96">&gt;VALUE</text>
</symbol>
</symbols>
<devicesets>
<deviceset name="LB1973M" prefix="IC">
<description>&lt;b&gt;&lt;/b&gt; &lt;font color="red"&gt;edit this description&lt;/font&gt;&lt;p&gt;
Auto generated by &lt;i&gt;make-symbol-device-package-bsdl.ulp Rev. 43&lt;/i&gt;&lt;br&gt;
Source:</description>
<gates>
<gate name="G$1" symbol="LB1973M" x="0" y="0"/>
</gates>
<devices>
<device name="MFP10S" package="SSOP10">
<connects>
<connect gate="G$1" pin="GND" pad="6"/>
<connect gate="G$1" pin="IN1" pad="4"/>
<connect gate="G$1" pin="IN2" pad="5"/>
<connect gate="G$1" pin="IN3" pad="3"/>
<connect gate="G$1" pin="IN4" pad="2"/>
<connect gate="G$1" pin="OUT1" pad="8"/>
<connect gate="G$1" pin="OUT2" pad="7"/>
<connect gate="G$1" pin="OUT3" pad="9"/>
<connect gate="G$1" pin="OUT4" pad="10"/>
<connect gate="G$1" pin="VCC" pad="1"/>
</connects>
<technologies>
<technology name=""/>
</technologies>
</device>
</devices>
</deviceset>
</devicesets>
</library>
</libraries>
<attributes>
</attributes>
<variantdefs>
</variantdefs>
<classes>
<class number="0" name="default" width="0" drill="0">
</class>
</classes>
<parts>
<part name="IC1" library="atmel" deviceset="TINY13" device="SU" technology="-20"/>
<part name="IC2" library="74xx-little-de" deviceset="74*1G00" device="DCK" technology="AHC"/>
<part name="IC3" library="74xx-little-de" deviceset="74*1G00" device="DCK" technology="AHC"/>
<part name="IC4" library="LB1937M" deviceset="LB1973M" device="MFP10S"/>
</parts>
<sheets>
<sheet>
<plain>
</plain>
<instances>
<instance part="IC1" gate="G$1" x="30.48" y="78.74" rot="R180"/>
<instance part="IC2" gate="A" x="104.14" y="81.28"/>
<instance part="IC3" gate="A" x="104.14" y="63.5"/>
<instance part="IC4" gate="G$1" x="149.86" y="78.74"/>
</instances>
<busses>
</busses>
<nets>
<net name="N$1" class="0">
<segment>
<pinref part="IC3" gate="A" pin="O"/>
<pinref part="IC4" gate="G$1" pin="IN2"/>
<wire x1="111.76" y1="63.5" x2="119.38" y2="63.5" width="0.1524" layer="91"/>
<wire x1="119.38" y1="63.5" x2="119.38" y2="73.66" width="0.1524" layer="91"/>
</segment>
</net>
<net name="N$2" class="0">
<segment>
<pinref part="IC2" gate="A" pin="O"/>
<pinref part="IC4" gate="G$1" pin="IN4"/>
<wire x1="111.76" y1="81.28" x2="119.38" y2="81.28" width="0.1524" layer="91"/>
</segment>
</net>
<net name="N$3" class="0">
<segment>
<pinref part="IC1" gate="G$1" pin="PB0/PCINT0/AIN0/OC0A/MOSI"/>
<pinref part="IC3" gate="A" pin="I0"/>
<wire x1="50.8" y1="68.58" x2="99.06" y2="68.58" width="0.1524" layer="91"/>
<wire x1="99.06" y1="68.58" x2="99.06" y2="66.04" width="0.1524" layer="91"/>
<pinref part="IC3" gate="A" pin="I1"/>
<wire x1="99.06" y1="66.04" x2="99.06" y2="60.96" width="0.1524" layer="91"/>
<wire x1="99.06" y1="68.58" x2="99.06" y2="71.12" width="0.1524" layer="91"/>
<wire x1="99.06" y1="71.12" x2="114.3" y2="71.12" width="0.1524" layer="91"/>
<wire x1="114.3" y1="71.12" x2="114.3" y2="76.2" width="0.1524" layer="91"/>
<pinref part="IC4" gate="G$1" pin="IN1"/>
<wire x1="114.3" y1="76.2" x2="119.38" y2="76.2" width="0.1524" layer="91"/>
<junction x="99.06" y="68.58"/>
<junction x="99.06" y="66.04"/>
<junction x="99.06" y="60.96"/>
</segment>
</net>
<net name="N$4" class="0">
<segment>
<pinref part="IC4" gate="G$1" pin="IN3"/>
<wire x1="119.38" y1="78.74" x2="111.76" y2="78.74" width="0.1524" layer="91"/>
<wire x1="111.76" y1="78.74" x2="111.76" y2="73.66" width="0.1524" layer="91"/>
<pinref part="IC2" gate="A" pin="I1"/>
<wire x1="111.76" y1="73.66" x2="99.06" y2="73.66" width="0.1524" layer="91"/>
<wire x1="99.06" y1="73.66" x2="99.06" y2="78.74" width="0.1524" layer="91"/>
<pinref part="IC2" gate="A" pin="I0"/>
<wire x1="99.06" y1="78.74" x2="99.06" y2="83.82" width="0.1524" layer="91"/>
<wire x1="99.06" y1="73.66" x2="93.98" y2="73.66" width="0.1524" layer="91"/>
<wire x1="93.98" y1="73.66" x2="93.98" y2="71.12" width="0.1524" layer="91"/>
<pinref part="IC1" gate="G$1" pin="PB1/PCINT1/AIN1/OC0B/INT0/MISO"/>
<wire x1="93.98" y1="71.12" x2="50.8" y2="71.12" width="0.1524" layer="91"/>
<junction x="99.06" y="73.66"/>
<junction x="99.06" y="78.74"/>
<junction x="99.06" y="83.82"/>
</segment>
</net>
</nets>
</sheet>
</sheets>
</schematic>
</drawing>
</eagle>
