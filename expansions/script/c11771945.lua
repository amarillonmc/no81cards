--天晶深渊
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,11771900,11771925)
	--发动    
    local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--改变卡名
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetRange(LOCATION_SZONE)
	e1:SetOperation(s.adjustop)
	c:RegisterEffect(e1)
	--加入手卡    
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)    
end
function s.confilter(c)
	return c:IsCode(11771925) and c:IsFaceup()
end
function s.chfilter(c)
	return not c:IsCode(11771925) and c:IsType(TYPE_MONSTER)
end
function s.adjustop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(s.confilter,tp,LOCATION_ONFIELD,0,1,nil) then return end 
	local loc=LOCATION_MZONE+LOCATION_REMOVED
    if not Duel.IsPlayerAffectedByEffect(tp,EFFECT_NECRO_VALLEY) and not Duel.IsPlayerAffectedByEffect(1-tp,EFFECT_NECRO_VALLEY) then
    	loc=LOCATION_MZONE+LOCATION_REMOVED+LOCATION_GRAVE
    end
	local g=Duel.GetMatchingGroup(s.chfilter,tp,loc,loc,nil)
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(11771900)
		tc:RegisterEffect(e1)
	end
end
function s.thfilter(c)
	return aux.IsCodeOrListed(c,11771900) and c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsCode(id) and c:IsAbleToHand()
    	and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end    
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
    	Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end        
end