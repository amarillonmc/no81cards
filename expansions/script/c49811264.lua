--ホロ・タクティクス
function c49811264.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,49811264+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c49811264.target)
	e1:SetOperation(c49811264.activate)
	c:RegisterEffect(e1)
	--Set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(49811264,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetCondition(c49811264.scondition)
	e2:SetTarget(c49811264.starget)
	e2:SetOperation(c49811264.soperation)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(49811264,1))
	e3:SetCondition(c49811264.xcondition)
	e3:SetTarget(c49811264.xtarget)
	e3:SetOperation(c49811264.xoperation)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetDescription(aux.Stringid(49811264,2))
	e4:SetCondition(c49811264.lcondition)
	e4:SetTarget(c49811264.ltarget)
	e4:SetOperation(c49811264.loperation)
	c:RegisterEffect(e4)
end
function c49811264.filter(c)
	return (c:IsSetCard(0x101b) and c:IsType(TYPE_MONSTER) or c:IsCode(83054225,904185,70875955,6260554,49811262,49811264)) and (c:IsAbleToHand() or c:IsAbleToGrave())
end
function c49811264.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c49811264.filter,tp,LOCATION_DECK,0,1,nil) end
end
function c49811264.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c49811264.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()<=0 then return end
	local tc=g:GetFirst()
	if tc:IsAbleToHand() and (not tc:IsAbleToGrave() or Duel.SelectOption(tp,1190,1191)==0) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	else
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end
function c49811264.sfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_EXTRA) and c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_WIND) and c:IsType(TYPE_SYNCHRO)
end
function c49811264.scondition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c49811264.sfilter,1,nil,tp) and #eg==1
end
function c49811264.stfilter(c)
	return c:IsCode(93211810) and c:IsSSetable()
end
function c49811264.starget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c49811264.stfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function c49811264.soperation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c49811264.stfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local sc=g:GetFirst()
	if sc and Duel.SSet(tp,sc)~=0 then
		if sc:IsType(TYPE_TRAP) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e1)
		end
	end
end
function c49811264.xfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_EXTRA) and c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_WIND) and c:IsType(TYPE_XYZ)
end
function c49811264.xcondition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c49811264.xfilter,1,nil,tp) and #eg==1
end
function c49811264.xtfilter(c)
	return c:IsCode(6260554) and c:IsSSetable()
end
function c49811264.xtarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c49811264.xtfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function c49811264.xoperation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c49811264.xtfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local sc=g:GetFirst()
	if sc and Duel.SSet(tp,sc)~=0 then
		if sc:IsType(TYPE_TRAP) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e1)
		end
	end
end
function c49811264.lfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_EXTRA) and c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_WIND) and c:IsType(TYPE_LINK)
end
function c49811264.lcondition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c49811264.lfilter,1,nil,tp) and #eg==1
end
function c49811264.ltfilter(c)
	return c:IsCode(70875955) and c:IsSSetable()
end
function c49811264.ltarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c49811264.ltfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function c49811264.loperation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c49811264.ltfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local sc=g:GetFirst()
	if sc and Duel.SSet(tp,sc)~=0 then
		if sc:IsType(TYPE_TRAP) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e1)
		end
	end
end