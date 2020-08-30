local m=82208125
local cm=_G["c"..m]
cm.name="龙法师 神秘魔术家"
function cm.initial_effect(c)
	--spsummon  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,0))  
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMINGS_CHECK_MONSTER)
	e1:SetRange(LOCATION_HAND)  
	e1:SetCountLimit(1,m)  
	e1:SetCost(cm.spcost)  
	e1:SetTarget(cm.sptg)  
	e1:SetOperation(cm.spop)  
	c:RegisterEffect(e1) 
	--draw
	local e2=Effect.CreateEffect(c)  
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetDescription(aux.Stringid(m,1)) 
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)  
	e2:SetCost(cm.drcost)
	e2:SetTarget(cm.drtg)
	e2:SetOperation(cm.drop)  
	c:RegisterEffect(e2)  
end
function cm.costfilter(c)  
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x6299) and not c:IsCode(m) and c:IsDiscardable()  
end  
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	local c=e:GetHandler()  
	if chk==0 then return c:IsDiscardable() and Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_HAND,0,1,c) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)  
	local g=Duel.SelectMatchingCard(tp,cm.costfilter,tp,LOCATION_HAND,0,1,1,c)  
	g:AddCard(c)  
	Duel.SendtoGrave(g,REASON_DISCARD+REASON_COST)  
end  
function cm.cfilter(c,e,tp)  
	return c:IsSetCard(0x6299) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)  
end  
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  
		and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)  
end  
function cm.spop(e,tp,eg,ep,ev,re,r,rp)  
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)  
	if g:GetCount()>0 then  
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)  
	end  
end  
function cm.atkfilter(c)  
	return c:GetAttribute()~=0  
end  
function cm.drcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end  
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)  
end  
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	local g=Duel.GetMatchingGroup(cm.atkfilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil)  
	local att=0  
	local tc=g:GetFirst()  
	while tc do  
		att=bit.bor(att,tc:GetAttribute())  
		tc=g:GetNext()  
	end  
	local ct=0  
	while att~=0 do  
		if bit.band(att,0x1)~=0 then ct=ct+1 end  
		att=bit.rshift(att,1)  
	end  
	if chk==0 then return ct>0 and Duel.IsPlayerCanDraw(tp,ct) end  
	Duel.SetTargetPlayer(tp)  
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)  
end  
function cm.drop(e,tp,eg,ep,ev,re,r,rp)  
	local g=Duel.GetMatchingGroup(cm.atkfilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil)  
	local att=0  
	local tc=g:GetFirst()  
	while tc do  
		att=bit.bor(att,tc:GetAttribute())  
		tc=g:GetNext()  
	end  
	local ct=0  
	while att~=0 do  
		if bit.band(att,0x1)~=0 then ct=ct+1 end  
		att=bit.rshift(att,1)  
	end  
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER) 
	if ct>0 then
		Duel.Draw(p,ct,REASON_EFFECT)  
	end
end  
