--画中的女儿
local s,id,o=GetID()
function s.initial_effect(c)
	c:SetSPSummonOnce(98346630)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c98346630.matfilter,1,1)
	--summon limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c98346630.regcon)
	e1:SetOperation(c98346630.regop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCondition(c98346630.spcon)
	e2:SetTarget(c98346630.sptg)
	e2:SetOperation(c98346630.spop)
	c:RegisterEffect(e2)
	--tograve and set
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetTarget(c98346630.tgtg)
	e3:SetOperation(c98346630.tgop)
	c:RegisterEffect(e3)
end
function c98346630.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c98346630.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c98346630.sumlimit)
	Duel.RegisterEffect(e1,tp)
end
function c98346630.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0xaf7)
end
function c98346630.matfilter(c)
	return c:IsLinkSetCard(0xaf7) and c:IsType(TYPE_TUNER) and c:IsSummonType(SUMMON_TYPE_NORMAL)
end
function c98346630.cfilter(c)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsReason(REASON_EFFECT)
end
function c98346630.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return eg:IsExists(c98346630.cfilter,1,nil) and (c:IsLocation(LOCATION_HAND) or not eg:IsContains(c))
end
function c98346630.thfilter(c)
	return c:IsSetCard(0xaf7) and c:IsFaceup() and c:IsAbleToHand() and not c:IsCode(98346630)
end
function c98346630.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,true) and Duel.IsExistingMatchingCard(c98346630.thfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c98346630.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c98346630.thfilter,tp,LOCATION_ONFIELD,0,1,nil)
	if c:IsRelateToEffect(e) and #g>0 and Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		c:CompleteProcedure()
	end
end
function c98346630.tgfilter(c,e,tp)
	return c:IsAbleToGrave() and Duel.IsExistingTarget(c98346630.setfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,c,e,tp)
end
function c98346630.setfilter(c,cc,e,tp)
	local b1=Duel.GetMZoneCount(1-tp,cc,tp)>0
	local st=Duel.GetLocationCount(1-tp,LOCATION_SZONE,tp)
	local b2=st>0 or cc:IsLocation(LOCATION_SZONE) and cc:GetSequence()<5 and st>-1
	return b1 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE,1-tp)
		or (b2 or c:IsType(TYPE_FIELD)) and c:IsSSetable(true)
end
function c98346630.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c98346630.tgfilter,tp,0,LOCATION_ONFIELD,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectTarget(tp,c98346630.tgfilter,tp,0,LOCATION_ONFIELD,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g2=Duel.SelectTarget(tp,c98346630.setfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,g1:GetFirst(),e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g1,1,0,0)
	if g2:GetFirst():IsType(TYPE_MONSTER) then
		e:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g2,1,0,0)
	else
		e:SetCategory(CATEGORY_TOGRAVE)
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g2,1,0,0)
	end
end
function c98346630.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetTargetsRelateToChain()
	local tc1=tg:Filter(Card.IsLocation,nil,LOCATION_ONFIELD):GetFirst()
	local tc2=tg:Filter(Card.IsLocation,nil,LOCATION_GRAVE):GetFirst()
	if tc1 and Duel.SendtoGrave(tc1,REASON_EFFECT)~=0 and tc1:IsLocation(LOCATION_GRAVE) and tc2 then
		if tc2:IsType(TYPE_MONSTER) then
			Duel.SpecialSummon(tc2,0,tp,1-tp,false,false,POS_FACEDOWN_DEFENSE)
		else
			Duel.SSet(tp,tc2,1-tp)
		end
	end
end