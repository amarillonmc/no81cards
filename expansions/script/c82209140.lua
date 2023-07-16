--黑暗决斗场
local m=82209140
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableCounterPermit(0x290)
	c:SetUniqueOnField(1,1,cm.chkfilter,LOCATION_ONFIELD)  
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetHintTiming(TIMING_DRAW_PHASE+TIMING_END_PHASE)
	c:RegisterEffect(e1)  
	--disable  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD)  
	e2:SetRange(LOCATION_SZONE)  
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)  
	e2:SetCondition(cm.discon)
	e2:SetTarget(cm.disable)  
	e2:SetCode(EFFECT_DISABLE)  
	c:RegisterEffect(e2)   
	--add counter
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetCategory(CATEGORY_COUNTER)
	e4:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(TIMINGS_CHECK_MONSTER)
	e4:SetCost(cm.cost)
	e4:SetTarget(cm.addtg)
	e4:SetOperation(cm.addop)
	c:RegisterEffect(e4)
end
function cm.chkfilter(c)
	return c:IsOriginalCodeRule(m)
end
function cm.discon(e)
	local ct=e:GetHandler():GetCounter(0x290)
	return ct>0
end
function cm.disable(e,c)
	local ct=e:GetHandler():GetCounter(0x290)
	local lv=0
	if c:GetLevel()>0 then
		lv=c:GetLevel()
	elseif c:GetRank()>0 then
		lv=c:GetRank()
	elseif c:GetLink()>0 then
		lv=c:GetLink()
	end
	return (bit.band(c:GetOriginalType(),TYPE_EFFECT)==TYPE_EFFECT or c:IsType(TYPE_EFFECT)) and ct%2~=lv%2
end  
function cm.disoperation(e,tp,eg,ep,ev,re,r,rp)  
	local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)  
	if bit.band(tl,LOCATION_SZONE)~=0 and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and not re:GetHandler():IsOriginalCodeRule(m) then  
		Duel.NegateEffect(ev)  
	end  
end  
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end  
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)  
end  
function cm.addtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():IsCanAddCounter(0x290,1) end  
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x290)  
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(m,0))
end  
function cm.addop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	if c:IsRelateToEffect(e) and c:IsFaceup() then  
		c:AddCounter(0x290,1)  
	end  
end  
function cm.handcon(e)  
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_ONFIELD,LOCATION_ONFIELD)==0  
end  