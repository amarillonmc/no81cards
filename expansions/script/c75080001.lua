--传说的召唤师 艾克拉
function c75080001.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75080001,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCost(c75080001.thcost)
	e1:SetTarget(c75080001.thtg)
	e1:SetOperation(c75080001.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
end
function c75080001.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function c75080001.thfilter(c,rc)
	return c:IsType(TYPE_MONSTER) and c:IsLevel(4) and c:IsAbleToHand() and c:IsAttribute(rc)
end
function c75080001.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c75080001.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c75080001.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local sx=Duel.GetFieldGroup(tp,LOCATION_GRAVE+LOCATION_EXTRA,LOCATION_DECK+LOCATION_HAND):RandomSelect(tp,1):GetFirst():GetCode()
	local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	local attr=0
	local tc=g:GetFirst()
	while tc do
		if sx>=21 then
			sx=sx-21
		else
			if sx==0 then
				attr=ATTRIBUTE_DARK+ATTRIBUTE_DIVINE 
			elseif sx==1 then
				attr=ATTRIBUTE_DARK+ATTRIBUTE_EARTH 
			elseif sx==2 then
				attr=ATTRIBUTE_DARK+ATTRIBUTE_FIRE 
			elseif sx==3 then
				attr=ATTRIBUTE_DARK+ATTRIBUTE_LIGHT 
			elseif sx==4 then
				attr=ATTRIBUTE_DARK+ATTRIBUTE_WATER 
			elseif sx==5 then
				attr=ATTRIBUTE_DARK+ATTRIBUTE_WIND 
			elseif sx==6 then
				attr=ATTRIBUTE_DIVINE+ATTRIBUTE_EARTH 
			elseif sx==7 then
				attr=ATTRIBUTE_DIVINE+ATTRIBUTE_FIRE 
			elseif sx==8 then
				attr=ATTRIBUTE_DIVINE+ATTRIBUTE_LIGHT 
			elseif sx==9 then
				attr=ATTRIBUTE_DIVINE+ATTRIBUTE_WATER 
			elseif sx==10 then
				attr=ATTRIBUTE_DIVINE+ATTRIBUTE_WIND 
			elseif sx==11 then
				attr=ATTRIBUTE_EARTH+ATTRIBUTE_FIRE 
			elseif sx==12 then
				attr=ATTRIBUTE_EARTH+ATTRIBUTE_LIGHT 
			elseif sx==13 then
				attr=ATTRIBUTE_EARTH+ATTRIBUTE_WATER 
			elseif sx==14 then
				attr=ATTRIBUTE_EARTH+ATTRIBUTE_WIND 
			elseif sx==15 then
				attr=ATTRIBUTE_FIRE+ATTRIBUTE_LIGHT 
			elseif sx==16 then
				attr=ATTRIBUTE_FIRE+ATTRIBUTE_WATER 
			elseif sx==17 then
				attr=ATTRIBUTE_FIRE+ATTRIBUTE_WIND 
			elseif sx==18 then
				attr=ATTRIBUTE_LIGHT+ATTRIBUTE_WATER 
			elseif sx==19 then
				attr=ATTRIBUTE_LIGHT+ATTRIBUTE_WIND 
			elseif sx==20 then
				attr=ATTRIBUTE_WATER+ATTRIBUTE_WIND 
			end
			tc=g:GetNext()
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
	local rc=Duel.AnnounceAttribute(tp,1,ATTRIBUTE_ALL-attr)
	local ac=Duel.GetMatchingGroup(c75080001.thfilter,tp,LOCATION_DECK,0,nil,rc):RandomSelect(tp,1):GetFirst()
	if ac and Duel.SendtoHand(ac,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,ac)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_ADD_SETCODE)
		e3:SetValue(0x3754)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		ac:RegisterEffect(e3)
		ac:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,2,0,aux.Stringid(75080001,1))
	end
end
function c75080001.splimit(e,c)
	return not c:IsSetCard(0x3754) and c:IsLocation(LOCATION_HAND)
end