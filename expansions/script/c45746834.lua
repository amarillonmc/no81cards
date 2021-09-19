--红皇后的美少年 电子怪胎
function c45746834.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x88e),2)
	c:EnableReviveLimit()

	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,45746834)
	e1:SetCondition(c45746834.descon)
	e1:SetTarget(c45746834.sptg)
	e1:SetOperation(c45746834.spop)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0xfe,0xff)
	e2:SetValue(LOCATION_REMOVED)
	e2:SetTarget(c45746834.rmtg)
	c:RegisterEffect(e2)
end
--e1
function c45746834.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c45746834.filter(c)
	return c:IsSetCard(0x88e) and c:IsType(TYPE_MONSTER) and c:IsLevelAbove(1)
end
function c45746834.fselect(g,e,tp)
	return aux.dlvcheck(g) and g:IsExists(c45746834.fcheck,1,nil,g,e,tp)
end
function c45746834.fcheck(c,g,e,tp)
	return c:IsLocation(LOCATION_HAND+LOCATION_DECK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE,1-tp)
		and g:IsExists(c45746834.fcheck2,1,c)
end
function c45746834.fcheck2(c)
	return c:IsLocation(LOCATION_DECK) and c:IsAbleToHand()
end
function c45746834.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c45746834.filter,tp,LOCATION_HAND+LOCATION_DECK,0,nil)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)>0
		and g:CheckSubGroup(c45746834.fselect,2,2,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c45746834.cfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE,1-tp)
		and (c:IsLocation(LOCATION_HAND) or not c:IsAbleToHand())
end
function c45746834.cfilter2(c,e,tp)
	return not c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE,1-tp)
		and c:IsLocation(LOCATION_DECK) and c:IsAbleToHand()
end
function c45746834.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)>0 then
		local g=Duel.GetMatchingGroup(c45746834.filter,tp,LOCATION_HAND+LOCATION_DECK,0,nil)
		local sc=nil
		local hc=nil
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local sg=g:SelectSubGroup(tp,c45746834.fselect,false,2,2,e,tp)
		if sg and sg:GetCount()==2 then
			if sg:IsExists(c45746834.cfilter,1,nil,e,tp) then
				sc=sg:Filter(c45746834.cfilter,nil,e,tp):GetFirst()
				hc=sg:GetFirst()
				if hc==sc then hc=sg:GetNext() end
			elseif sg:IsExists(c45746834.cfilter2,1,nil,e,tp) then
				hc=sg:Filter(c45746834.cfilter2,nil,e,tp):GetFirst()
				sc=sg:GetFirst()
				if sc==hc then sc=sg:GetNext() end
			else
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				sc=sg:FilterSelect(tp,c45746834.fcheck,1,1,nil,sg,e,tp):GetFirst()
				hc=sg:GetFirst()
				if hc==sc then hc=sg:GetNext() end
			end
			if sc and Duel.SpecialSummon(sc,0,tp,1-tp,false,false,POS_FACEUP_DEFENSE)~=0 and hc then
				Duel.SendtoHand(hc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,hc)
			end
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(c45746834.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c45746834.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsRace(RACE_PSYCHO)
end

--e2
function c45746834.rmtg(e,c)
	return c:GetOwner()~=e:GetHandlerPlayer() and c:IsReason(REASON_DESTROY) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end