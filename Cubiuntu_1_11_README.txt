影像檔名稱
cubiuntu_ct_1.11_sd_062c9bc17099e1d7ceb80e341da7fd71.img

使用的u-boot名稱
u-boot-sunxi-with-spl-ct-20140107.bin

步驟：
請先用Gparted把MicroSD卡上面所有分割區都刪掉
然後用root權限執行

(格式化卡片，假設/dev/sdb是你的MicroSD卡）
# mkfs.ext2 /dev/sdb		

(清空卡片前面的磁區）
# dd if=/dev/zero of=${card} bs=512 seek=1 count=2047		

（寫入bootloader）
# dd if=$bootloader of=$card bs=1024 seek=8

（將影像檔寫入MicroSD卡）
# dd if=$image of=$card bs=1M
# sync

（修改uEnv.ct，讓影像檔開機後是VGA輸出）
# mkdir /tmp/sdb1
# mount /dev/sdb1 /tmp/sdb1
# ls -al
# vi uEnv.ct

接著把uEnv.ct的設定改成這樣
這是實際拿來開機的uEnv.ct檔案設定，一字不漏照抄，我的LCD螢幕是15 pin的VGA頭
extraargs=disp.screen0_output_type=4 disp.screen0_output_mode=4 consoleblank=0 cubietruck 
sunxi_ve_mem_reserve=128 
root=/dev/mmcblk0p2 rootwait 
partition=0:1
kernel=/uImage.3.4.79-sun7i+
script=script-ct.bin

改好就存檔，然後再
# sync
# umount /tmp/sdb1

這樣就完成了，把MicroSD卡拔出筆電，然後插到CubieTruck裡面開機就可以了～啦啦啦啦

登入帳號密碼linaro/linaro或是root/root（預設是不會叫你登入，開機後直接進桌面）

記得我剛燒好影像檔，把SD卡插到CubieTruck，可是沒畫面
所以我發問了

Dear ikeeki
I have downloaded the image for my cubietruck
( 1.11 XBMC edition for Cubietruck (CT) sdcard 12-may-2014 )
and I followed the tutorial here to flash a bootable SD card
http://cubiuntu.com/2014/04/30/how-to-flash-a-cubiuntu-sdcard-image/
and when I boot my cubietruck with this SD card,
no VGA output , the only thing I can see is a black screen,
but my Cubietruck’s Led is still twinkling, I don’t know what happened so I shutdown my Cubietruck, unplug my SD card,
and insert SD card into my Laptop , I dumped the script-ct.bin to 1.fex and I modified the screen0_output_type from 4 to 1 (because the monitor I connected with cubietruck is LCD screen), then I use fex2bin tool to convert the 1.fex to overriden script-ct.bin , unplug the SD card , and insert the SD card back to cubietruck and boot again , But I still get an BLACK SCREEN , I can not figure out where is the problem , would you give me any suggestion? thank you very much , sorry for my bad English

然後弄這個影像檔的人也就是ikeeki回答了

Hi, try to add one of the following lines in uEnv, replacing the similar one, thanks

extraargs=disp.screen0_output_type=4 disp.screen0_output_mode=3 cubietruck
extraargs=disp.screen0_output_type=4 disp.screen0_output_mode=4 cubietruck
extraargs=disp.screen0_output_type=4 disp.screen0_output_mode=10 cubietruck
