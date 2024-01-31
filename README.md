# **輪盤遊戲(Roulette) App**

# **遊戲介紹**

- 遊戲開始時，玩家會獲得一千美金的籌碼。

- 可下注區域包含
  - 範圍型：1ST12, 2ND12, 3RD12, 1-18, EVEN, 紅色數字, 黑色數字, ODD, 19-36, (2 : 1) *3
  - 單數字型：0 ~ 36 (含單數字下注, 分割下注, 角落下注, 街道下注)
    - 分割下注 : 在 2 個數字的中間 (比方放在 5 與 8 之間跟 12 與 15 之間)
    - 角落下注 : 將籌碼放在四個數字交叉的位置 (比方放在 4、5、7、8 之間)
    - 街道下注 : 將籌碼放在三個數字的邊緣 (比方放在 7 左邊的線)
    
- 賠率
  - 數字 1 ~ 36 以及數字 0, 賠率為 35 : 1
  - 分割下注, 賠率 17 : 1
  - 街道下注, 賠率 11 : 1
  - 角落下注, 賠率 8 : 1
  - 1st 12(數字 1 ~ 12), 2nd 12(數字 13 ~ 24), 3rd 12(數字 25 ~ 36), 賠率為 2 : 1
  - 三個 2 to 1, 賠率為 2 : 1
  - 1–18、19–36, 賠率為 1 : 1
  - Even、Odd, 賠率為 1 : 1 (0 不算偶數)
  - 紅色、黑色, 賠率為 1 : 1

- 下注前玩家可選擇不同金額的籌碼(chip)。
  - 選擇籌碼後, 點選投注的區域, 可重複投注多個區域直到總金額不夠為止, 並在畫面上顯示此次投注的總金額
  - 點選 SPIN 後隨機一個數字, 玩家猜對時依據賠率賺錢, 猜錯時損失籌碼
    
 - 清除投注(CLEAR BETS)。
   - 拿回放在投注區的籌碼，重新投注。
    
- 重覆上次的投注(REBET)。
   - 比方上一回合各放 10 美金的籌碼在 5 號和 10 號，這回合繼續投注同樣的金額跟區塊。
    

賠率例子說明。

當玩家投注 10 美金時，賠率 35 : 1  表示他會得到 350 美金。假設玩家原本有 100 美金，投注了 10 美金，猜對時他的錢會變成 450 美金，猜錯時會變成 90 美金。


# 
# **遊戲畫面**

![籌碼選擇](https://github.com/Howewuwu/Roulette/assets/115788868/96f86c9a-447f-4ebb-bce4-7784bfa51c5a)籌碼選擇
![籌碼面值對應下注](https://github.com/Howewuwu/Roulette/assets/115788868/e3ce8163-7d95-4713-8015-eb314d209fb8)籌碼面額對應下注
![取消下注](https://github.com/Howewuwu/Roulette/assets/115788868/528e75eb-fbac-4c98-bece-c85f114cb3af)取消下注
![數字區下注](https://github.com/Howewuwu/Roulette/assets/115788868/a5c9fc46-4392-4b1c-9b79-e89c97c33c0a)數字區下注
![非數字區下注](https://github.com/Howewuwu/Roulette/assets/115788868/b6d7f694-e055-4b87-9742-fac5670b6461)非數字區下注
![分割下注](https://github.com/Howewuwu/Roulette/assets/115788868/e3233232-005f-491f-9c5b-97ecca6753ed)分割下注
![街道下注](https://github.com/Howewuwu/Roulette/assets/115788868/3c66f388-ecc7-4bd6-9733-61e4529ad757)街道下注
![角落下注](https://github.com/Howewuwu/Roulette/assets/115788868/8bd8387c-2454-4cc5-aa28-57babeb897d3)角落下注
![顯示數字列](https://github.com/Howewuwu/Roulette/assets/115788868/937f7b8c-abe1-4048-9bac-332b6c64808b)儲存顯示開獎號碼
![閃爍區域](https://github.com/Howewuwu/Roulette/assets/115788868/2e4ba8d5-aaf6-47ae-9bd3-215539ea93e1)中獎號碼指示閃爍區域
![單區域重複下注](https://github.com/Howewuwu/Roulette/assets/115788868/e5f8aa85-4465-472e-afc0-e59282740614)單筆重複下注



