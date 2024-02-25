--了不起的杰弗里斯
local cm,m,o=GetID()
function cm.initial_effect(c)
	
end
--手坑
a1=14558127--灰流丽
a2=23434538--增殖的G
a3=10045474--无限泡影
a4=97268402--效果遮蒙者
a5=59438930--幽鬼兔
a6=73642296--屋敷童
a7=27204311--原始生命态 尼比鲁

--红坑
b1=61740673--王宫的敕命
b2=82732705--技能抽取
b3=41420027--神之宣告
b4=30241314--大宇宙
b5=24207889--千查万别

--先手
d1=24224830--墓穴的指名者
d2=65681983--抹杀之指名者

--后手对策
f1=12580477--雷击
f2=54693926--冥王结界波
f3=55063751--海龟坏兽 加美西耶勒
f4=14532163--闪电风暴
f5=4031928--心变
f6=18144506--鹰身女妖的羽毛扫

--我咋知道你要啥
h1=32909498--俱舍怒威族·芬里尔狼
h2=68304193--俱舍怒威族·独角兽
h3=15397015--冲浪检察官

--我要展开了
i1=50588353--水晶机巧-继承玻纤
i2=61665245--召唤女巫
i3=34945480--外神 阿撒托斯
i4=85243784--连接十字（暂不可用）
i5=84815190--鲜花女男爵（暂不可用）

--风中残烛
j1=55144522--强欲之壶
j2=67169062--贪欲之壶

--胜利的方程式
k1=19523799--昼夜的大火灾

--杂七杂八
z1=36584821--红莲魔兽 塔·伊沙
z2=3679218--梦幻崩影·人鱼

function cm.PerfectCards(e)
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	local rtab={}
	if Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_MZONE,0,1,nil,0xb6) then
		for i=1,30 do
			table.insert(rtab,i3)
		end
	end
	if Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_MZONE,0,1,nil,TYPE_TUNER) then
		for i=1,3 do
			table.insert(rtab,i1)
		end
	end
	local kg=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE,0,nil,TYPE_MONSTER)
	if kg:GetCount()~=kg:GetClassCount(Card.GetRace) then
		for i=1,3 do
			table.insert(rtab,i2)
		end
	end
	if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0 then
		for i=1,5 do
			table.insert(rtab,j1)
		end
		if Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_GRAVE,0,5,nil,TYPE_MONSTER) then
			for i=1,5 do
				table.insert(rtab,j2)
			end
		end
	end
	if Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)==0 then
		table.insert(rtab,b1)
		table.insert(rtab,b2)
		table.insert(rtab,b3)
		table.insert(rtab,b4)
		table.insert(rtab,b5)
		for i=1,2 do
			table.insert(rtab,h1)
			table.insert(rtab,h2)
			table.insert(rtab,h3)
			
		end 
		if Duel.GetTurnCount(tp)==1 then
			for i=1,8 do
				table.insert(rtab,d1)
				table.insert(rtab,d2)
			end
		end
	end
	if Duel.GetLP(1-tp)<=800 then
		for i=1,30 do
			table.insert(rtab,k1)
		end
	end
	if Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_MZONE,0,1,nil,0x112) and Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_DECK,0,1,nil,0x112) then
		for i=1,3 do
			table.insert(rtab,z2)
		end
	end
	if Duel.GetFieldGroupCount(tp,LOCATION_REMOVED,0)*400>=Duel.GetLP(1-tp) then
		for i=1,10 do
			table.insert(rtab,z1)
		end
	end
	if Duel.GetMatchingGroupCount(nil,tp,0,LOCATION_ONFIELD,nil)>=3 then
		fi=1
		if Duel.GetMatchingGroupCount(nil,tp,0,LOCATION_ONFIELD,nil)>=5 then
			fi=3
		elseif Duel.GetMatchingGroupCount(nil,tp,0,LOCATION_ONFIELD,nil)>=8 then
			fi=8
		end
		if Duel.GetMatchingGroupCount(nil,tp,0,LOCATION_MZONE,nil)>=Duel.GetMatchingGroupCount(nil,tp,0,LOCATION_SZONE,nil) then
			for i=1,fi do
				table.insert(rtab,f1)
				table.insert(rtab,f2)
				table.insert(rtab,f3)
				table.insert(rtab,f4)
				table.insert(rtab,f5)
			end
		else
			for i=1,fi do
				table.insert(rtab,f4)
				table.insert(rtab,f4)
				table.insert(rtab,f6)
				table.insert(rtab,f6)
				table.insert(rtab,f6)
				table.insert(rtab,f6)
			end
		end
	else
		table.insert(rtab,a1)
		table.insert(rtab,a2)
		table.insert(rtab,a3)
		table.insert(rtab,a4)
		table.insert(rtab,a5)
		table.insert(rtab,a6)
		table.insert(rtab,a7)
	end
	
	
end