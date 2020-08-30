local m=82224054
local cm=_G["c"..m]
cm.name="极厄龙 涅墨西斯"
function cm.initial_effect(c)
	--synchro summon  
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_DRAGON),aux.NonTuner(nil),1)  
	c:EnableReviveLimit()
	--disable spsummon  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,0))  
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_TOGRAVE)  
	e1:SetType(EFFECT_TYPE_QUICK_O)  
	e1:SetRange(LOCATION_MZONE)  
	e1:SetCode(EVENT_SUMMON)  
	e1:SetCountLimit(1,82214054)
	e1:SetCondition(cm.dscon)  
	e1:SetTarget(cm.dstg)  
	e1:SetOperation(cm.dsop)  
	c:RegisterEffect(e1)  
	local e2=e1:Clone()  
	e2:SetCode(EVENT_FLIP_SUMMON)  
	c:RegisterEffect(e2)  
	local e3=e1:Clone()  
	e3:SetCode(EVENT_SPSUMMON)  
	c:RegisterEffect(e3)  
	--draw  
	local e4=Effect.CreateEffect(c)  
	e4:SetDescription(aux.Stringid(m,1))  
	e4:SetCategory(CATEGORY_DRAW)  
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e4:SetProperty(EFFECT_FLAG_DELAY)  
	e4:SetCode(EVENT_TO_GRAVE)  
	e4:SetCountLimit(1,m)  
	e4:SetCondition(cm.drcon)  
	e4:SetTarget(cm.drtg)  
	e4:SetOperation(cm.drop)  
	c:RegisterEffect(e4)  
end
function cm.dscon(e,tp,eg,ep,ev,re,r,rp)  
	return tp~=ep and Duel.GetCurrentChain()==0  
end  
function cm.dstg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)  
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,eg,eg:GetCount(),0,0)  
end  
function cm.dsop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.NegateSummon(eg)  
	Duel.SendtoGrave(eg,REASON_EFFECT)  
end  
function cm.drcon(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsSummonType(SUMMON_TYPE_SYNCHRO)  
end  
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end  
	Duel.SetTargetPlayer(tp)  
	Duel.SetTargetParam(1)  
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)  
end  
function cm.drop(e,tp,eg,ep,ev,re,r,rp)  
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)  
	Duel.Draw(p,d,REASON_EFFECT)  
end  