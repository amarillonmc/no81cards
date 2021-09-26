--革命爆发
local m=11451449
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,99518961)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--replace
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_DECK)
	e2:SetCode(EFFECT_SEND_REPLACE)
	e2:SetTarget(cm.reptg)
	e2:SetValue(function(e,c) return c:GetFlagEffect(m)>0 end)
	c:RegisterEffect(e2)
end
function cm.filter1(c,e,tp)
	return (aux.IsCodeListed(c,99518961) or (c:IsLevelBelow(3) and c:IsType(TYPE_NORMAL))) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.filter2(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_DECK) and c:GetDestination()==LOCATION_HAND and c:IsCode(99518961) and c:IsAbleToHand()
end
function cm.filter3(c,e,g)
	return (c:GetOriginalCode()==m or c==e:GetHandler()) and c:IsAbleToHand() and not g:IsContains(c)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(cm.filter1,tp,LOCATION_HAND,0,nil,e,tp)
	local g2=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.filter1),tp,LOCATION_GRAVE,0,nil,e,tp)
	if g1:GetCount()>0 and g2:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>=2 and not Duel.IsPlayerAffectedByEffect(tp,59822133) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg1=g1:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg2=g2:Select(tp,1,1,nil)
		sg1:Merge(sg2)
		Duel.SpecialSummon(sg1,0,tp,tp,false,false,POS_FACEUP)
	end
	--damage up
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(cm.damval)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.damval(e,re,val,r,rp)
	if r&REASON_EFFECT==REASON_EFFECT and re and re:GetHandler():IsCode(99518961) and rp and rp==e:GetHandlerPlayer() then return val*2 end
	return val
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.filter3,tp,LOCATION_DECK,0,nil,e,eg)
	if chk==0 then return bit.band(r,REASON_EFFECT)~=0 and re and eg:IsExists(cm.filter2,1,nil,tp) and c==g:GetFirst() end
	if Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		local g=eg:Filter(cm.filter2,nil,tp)
		g:ForEach(Card.RegisterFlagEffect,m,RESET_CHAIN,0,1)
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
		return true
	else return false end
end