--亚里沙的小本本
local m=60001211
local cm=_G["c"..m]
function cm.initial_effect(c)
	--查询玩家任务进度
	local e4=Effect.CreateEffect(c)--融合或使用财宝卡的次数
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_EXTRA) 
	e4:SetOperation(cm.op1)
	c:RegisterEffect(e4)
	local e4=Effect.CreateEffect(c)--进化次数
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_EXTRA) 
	e4:SetOperation(cm.op2)
	c:RegisterEffect(e4)
	local e4=Effect.CreateEffect(c)--结晶次数
	e4:SetDescription(aux.Stringid(m,2))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_EXTRA) 
	e4:SetOperation(cm.op3)
	c:RegisterEffect(e4)
	--
--融合或使用财宝卡的次数:60001211
--进化次数:60002148
--结晶次数:60002177

--查询玩家任务进度
function cm.op1(e,tp,eg,ep,ev,re,r,rp,nm)  --融合或使用财宝卡的次数
	Debug.Message(Duel.GetFlagEffect(tp,60001211))
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp,nm)  --进化次数
	Debug.Message(Duel.GetFlagEffect(tp,60002148))
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp,nm)  --结晶次数
	Debug.Message(Duel.GetFlagEffect(tp,60002177))
end