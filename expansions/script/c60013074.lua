-- 事件视界
local cm,m,o=GetID()

local F_CNT=m+10000000	-- ②的发动次数
local F_D12=m+20000000	-- 骰子出现1或2的次数
local F_D34=m+30000000	-- 骰子出现3或4的次数
local F_D56=m+40000000	-- 骰子出现5或6的次数

function cm.initial_effect(c)
	-- 作为场地魔法发动
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(m,0))
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetOperation(cm.actop)
	c:RegisterEffect(e0)

	-- ②：自己把「创造」卡发动的场合
	-- 卡文没有「这个卡名…1回合X次」，只有「发动过3次以上的场合这张卡破坏」→
	-- 次数全靠 F_CNT 这个 flag 累积记，不写 SetCountLimit（也不会和别的「同一连锁1次」抢计数）
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCondition(cm.con2)
	e1:SetTarget(cm.tg2)
	e1:SetOperation(cm.op2)
	c:RegisterEffect(e1)
end

-- 「创造」卡
function cm.souzoufil(c)
	return c.isSouzou and c:IsAbleToHand()
end
-- ①：作为发动时的效果处理，可以从卡组随机把1张「创造」卡加入手卡
function cm.actop(e,tp,eg,ep,ev,re,r,rp)
	-- 这一份刚上场：清掉上一份留下的②发动次数/骰子记录
	if e:GetHandler():IsLocation(LOCATION_FZONE) then
		Duel.ResetFlagEffect(tp,F_CNT)
		Duel.ResetFlagEffect(tp,F_D12)
		Duel.ResetFlagEffect(tp,F_D34)
		Duel.ResetFlagEffect(tp,F_D56)
	end
	local g=Duel.GetMatchingGroup(cm.souzoufil,tp,LOCATION_DECK,0,nil)
	if g:GetCount()==0 then return end
	if not Duel.SelectYesNo(tp,aux.Stringid(m,0)) then return end
	g=g:RandomSelect(tp,1)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleDeck(tp)
end

-- ②
-- 「帝国执行官 蒂菲拉」
function cm.tifil(c)
	return c:IsCode(60013063) and c:IsFaceup()
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	-- 用 ep（发动者）判定，与「灼红之矢」等已验证的写法一致
	if ep~=tp or not re then return false end
	local rc=re:GetHandler()
	if not rc then return false end
	-- 「创造」卡：脚本标签 isSouzou，另按卡号兜底
	return rc.isSouzou==true or rc:IsCode(60013068) or rc:IsCode(60013069) or rc:IsCode(60013070)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dice=Duel.TossDice(tp,1)
	-- 每次投骰子都注册客户端提示（和「持续公开中」一样的注释）
	c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,1+dice))
	-- 记录次数
	Duel.RegisterFlagEffect(tp,F_CNT,0,0,1)
	if dice<=2 then
		Duel.RegisterFlagEffect(tp,F_D12,0,0,1)
	elseif dice<=4 then
		Duel.RegisterFlagEffect(tp,F_D34,0,0,1)
	else
		Duel.RegisterFlagEffect(tp,F_D56,0,0,1)
	end
	-- 自己场上有「帝国执行官 蒂菲拉」存在的场合，自己抽1张
	if Duel.IsExistingMatchingCard(cm.tifil,tp,LOCATION_MZONE,0,1,nil) then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
	-- 第3次以上发动：这张卡破坏，以下适用
	if Duel.GetFlagEffect(tp,F_CNT)<3 then return end
	Duel.Destroy(c,REASON_EFFECT)
	local n12=Duel.GetFlagEffect(tp,F_D12)
	local n34=Duel.GetFlagEffect(tp,F_D34)
	local n56=Duel.GetFlagEffect(tp,F_D56)
	-- ●回复
	Duel.Recover(tp,500+1000*n12,REASON_EFFECT)
	-- ●抽卡
	Duel.Draw(tp,1+n34,REASON_EFFECT)
	-- ●放置 1+n56 只光属性灵光一闪衍生物（白板，不附加效果）
	local ct=1+n56
	for i=1,ct do
		if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then break end
		local token=Duel.CreateToken(tp,60013064)
		Duel.MoveToField(token,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
