--黑兽之牙 「御驾亲征」
local m=43990122
local cm=_G["c"..m]
function cm.initial_effect(c)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e0:SetCondition(c43990122.handcon)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,43990122+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c43990122.thtg)
	e1:SetOperation(c43990122.thop)
	c:RegisterEffect(e1)
	--back to mzone
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_MOVE)
	e2:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e2:SetCondition(c43990122.bmcon)
	e2:SetTarget(c43990122.bmtg)
	e2:SetOperation(c43990122.bmop)
	c:RegisterEffect(e2)
	if not c43990122.global_check then
		c43990122.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c43990122.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c43990122.checkfliter(c)
	return c:IsCode(43990116) and c:IsFaceup() and c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c43990122.checkop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c43990122.checkfliter,1,nil) then
		Duel.RegisterFlagEffect(0,43990122,RESET_PHASE+PHASE_END,0,1)
		Duel.RegisterFlagEffect(1,43990122,RESET_PHASE+PHASE_END,0,1)
	end
end
function c43990122.handcon(e)
	return Duel.GetFlagEffect(tp,43990122)>0
end
function c43990122.checkfilter(c)
	return c:IsCode(43990120) and c:IsFaceup()
end
function c43990122.spfilter(c,e,tp)
	return c:IsSetCard(0x6510) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c43990122.thfilter(c,g)
	return c:IsSetCard(0x6510) and g:IsExists(Card.IsCode,1,c,43990120)
end
function c43990122.gcheck(g)
	return g:IsExists(c43990122.thfilter,1,nil,g)
end
function c43990122.thdfilter(c)
	return (c:IsSetCard(0x6510) or c:IsCode(43990120)) and c:IsAbleToHand()
end
function c43990122.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c43990122.thdfilter,tp,LOCATION_DECK,0,nil)
	local e1= #g>1 and g:CheckSubGroup(c43990122.gcheck,2,2)
	local e2= Duel.IsExistingMatchingCard(c43990122.checkfilter,tp,LOCATION_ONFIELD,0,1,nil) and Duel.IsExistingMatchingCard(c43990122.spfilter,tp,LOCATION_DECK,0,2,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
	if chk==0 then return e1 or e2 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c43990122.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c43990122.thdfilter,tp,LOCATION_DECK,0,nil)
	local e1= #g>1 and g:CheckSubGroup(c43990122.gcheck,2,2)
	local e2= Duel.IsExistingMatchingCard(c43990122.checkfilter,tp,LOCATION_ONFIELD,0,1,nil) and Duel.IsExistingMatchingCard(c43990122.spfilter,tp,LOCATION_DECK,0,2,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
	if e1 and (not e2 or not Duel.SelectYesNo(tp,aux.Stringid(43990122,1))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:SelectSubGroup(tp,c43990122.gcheck,false,2,2)
		if #sg>0 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	elseif e2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local spg=Duel.SelectMatchingCard(tp,c43990122.spfilter,tp,LOCATION_DECK,0,2,2,nil,e,tp)
		if spg:GetCount()>0 then
			Duel.SpecialSummon(spg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c43990122.cfilter(c)
	return c:IsLocation(LOCATION_MZONE) and c:IsPreviousLocation(LOCATION_REMOVED) and not c:IsReason(REASON_SPSUMMON) and c:IsFaceup() and c:IsSetCard(0x6510)
end
function c43990122.bmcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return eg:IsExists(c43990122.cfilter,1,nil)
end
function c43990122.bmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeck() and c:IsFaceup() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,tp,LOCATION_DECK+LOCATION_REMOVED)
end
function c43990122.bmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 then
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_DISEFFECT)
	e3:SetValue(c43990122.efilter)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_DISABLE)
	e4:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e4:SetTarget(c43990122.indtg)
	e4:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e4,tp)
	end
end
function c43990122.efilter(e,ct)
	local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
	local tc=te:GetHandler()
	return tc:GetOriginalType()&TYPE_MONSTER~=0 and (tc:IsSetCard(0x6510) or tc:IsCode(43990120))
end
function c43990122.indtg(e,c)
	return c:GetOriginalType()&TYPE_MONSTER~=0 and (c:IsSetCard(0x6510) or c:IsCode(43990120))
end

