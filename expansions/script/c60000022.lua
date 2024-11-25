--静默残垣 卡兹戴尔
local cm,m,o=GetID()
local s,id,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,22702055)
	aux.AddCodeList(c,53582587)
	--untarget
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetRange(LOCATION_FZONE)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetTarget(s.tgotg)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetCountLimit(1,m)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(s.condition)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end
function s.tgotg(e,c)
	return c~=e:GetHandler() and ((c:IsAttribute(ATTRIBUTE_WATER) and c:IsRace(RACE_PSYCHO)) or c:IsCode(m,m+1)) 
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsReason(REASON_DRAW)
end
function cm.filter1(c)
	return c:IsCode(22702055) and c:IsAbleToGrave()
end
function cm.filter2(c)
	return ((c:IsAttribute(ATTRIBUTE_WATER) and c:IsRace(RACE_PSYCHO) and c:IsSummonLocation(LOCATION_EXTRA)) or c:IsCode(m,m+1)) and c:IsFaceup()
end
function cm.filter3(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_WARRIOR) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=true
	local b2=false
	local b3=false
	local b4=false
	local b5=false
	if Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_DECK,0,1,nil) then b2=true end
	if Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_ONFIELD,0,1,nil) then b3=true end
	if Duel.IsExistingMatchingCard(cm.filter3,tp,LOCATION_GRAVE,0,2,nil) then b4=true end
	if Duel.IsExistingMatchingCard(Card.IsFacedown,tp,0,LOCATION_SZONE,1,nil) then b5=true end
	if chk==0 then return true end
	local op=aux.SelectFromOptions(tp,
				{b1,aux.Stringid(m,1)},
				{b2,aux.Stringid(m,2)},
				{b3,aux.Stringid(m,3)},
				{b4,aux.Stringid(m,4)},
				{b5,aux.Stringid(m,5)})
	e:SetLabel(op)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==1 then Duel.Damage(1-tp,360,REASON_EFFECT) 
	elseif op==2 then
		local g=Duel.GetMatchingGroup(cm.filter1,tp,LOCATION_DECK,0,nil):RandomSelect(tp,1)
		if Duel.SendtoGrave(g,REASON_EFFECT)~=0 then Duel.Draw(tp,1,REASON_EFFECT) end
	elseif op==3 then
		for tc in aux.Next(Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_ONFIELD,0,nil)) do
			--immune
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_IMMUNE_EFFECT)
			e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e3:SetRange(LOCATION_MZONE)
			e3:SetReset(RESET_EVENT+RESETS_REDIRECT)
			e3:SetValue(cm.efilter)
			tc:RegisterEffect(e3)
		end
	elseif op==4 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.filter3,tp,LOCATION_GRAVE,0,2,2,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	elseif op==5 then
		local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,0,LOCATION_ONFIELD,nil)
		Duel.ConfirmCards(tp,g)
		local rg=g:Filter(Card.IsCode,nil,53582587)
		if #rg>0 then Duel.Destroy(g,REASON_EFFECT) end
	end
	Duel.SendtoDeck(e:GetHandler(),nil,1,REASON_EFFECT)
end
function cm.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end