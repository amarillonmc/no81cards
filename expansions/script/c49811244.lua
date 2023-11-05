--龙星的珠联
function c49811244.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,49811244+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c49811244.cost)
	e1:SetTarget(c49811244.target)
	e1:SetOperation(c49811244.activate)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c49811244.stcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c49811244.sttg)
	e2:SetOperation(c49811244.stop)
	c:RegisterEffect(e2)
end
function c49811244.filter(c,tp)
	return not c:IsPublic() and c:IsRace(RACE_WYRM) and c:IsType(TYPE_MONSTER) and c:GetLevel()>1
		and Duel.IsExistingMatchingCard(c49811244.thfilter,tp,LOCATION_DECK,0,1,nil,c)
end
function c49811244.thfilter(c,pc)
	return c:IsSetCard(0x9e) and c:IsLevelBelow(pc:GetLevel()-1) and c:IsAbleToHand()
end
function c49811244.spfilter(c,e,tp,tc)
	return c:IsSetCard(0x9e) and c:IsLevelBelow(tc:GetLevel()-1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c49811244.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c49811244.filter,tp,LOCATION_HAND,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c49811244.filter,tp,LOCATION_HAND,0,1,1,nil,tp)
	e:SetLabelObject(g:GetFirst())
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c49811244.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:IsCostChecked() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c49811244.activate(e,tp,eg,ep,ev,re,r,rp)
	local pc=e:GetLabelObject()
	if pc==nil then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c49811244.thfilter,tp,LOCATION_DECK,0,1,1,nil,pc):GetFirst()
	if tc and Duel.SendtoHand(tc,nil,REASON_EFFECT) then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		local g=Duel.GetMatchingGroup(c49811244.spfilter,tp,LOCATION_DECK,0,nil,e,tp,tc)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(49811244,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g1=g:Select(tp,1,1,nil)
			Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
		end
	end	
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(c49811244.actlimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c49811244.actlimit(e,re,rp)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and rc:IsOnField() and not rc:IsRace(RACE_WYRM)
end
function c49811244.rfilter(c,tp,rp)
	return c:IsPreviousControler(tp) and bit.band(c:GetPreviousRaceOnField(),RACE_WYRM)~=0 and rp==1-tp
end
function c49811244.stcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c49811244.rfilter,1,nil,tp,rp) and not eg:IsContains(e:GetHandler())
end
function c49811244.stfilter(c)
	return c:IsSetCard(0x9e) and not c:IsCode(49811244) and c:IsSSetable()
end
function c49811244.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c49811244.stfilter,tp,LOCATION_GRAVE,0,1,nil) end
end
function c49811244.stop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c49811244.stfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.SSet(tp,tc)
	end
end