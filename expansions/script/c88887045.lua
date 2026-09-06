--龟影迷踪 追迹
function c88887045.initial_effect(c)
	--to grave
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EVENT_TO_GRAVE)
	e0:SetOperation(c88887045.regop)
	c:RegisterEffect(e0)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetCountLimit(1,88887045)
	e1:SetCondition(c88887045.spcon)
	e1:SetCost(c88887045.spcost)
	e1:SetTarget(c88887045.sptg)
	e1:SetOperation(c88887045.spop)
	c:RegisterEffect(e1)
	--xyz effect
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,18887045)
	e2:SetCondition(c88887045.xyzcon)
	e2:SetTarget(c88887045.xyztg)
	e2:SetOperation(c88887045.xyzop)
	c:RegisterEffect(e2)
	--to deck
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,28887045)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END+TIMING_END_PHASE)
	e3:SetCondition(c88887045.thcon1)
	e3:SetCost(c88887045.thcost)
	e3:SetTarget(c88887045.thtg)
	e3:SetOperation(c88887045.thop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCondition(c88887045.thcon2)
	c:RegisterEffect(e4)
end
function c88887045.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(88887045,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function c88887045.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not (r==REASON_RULE)
end
function c88887045.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c88887045.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c88887045.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c88887045.xyzcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()~=tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
		and e:GetHandler():IsStatus(STATUS_SPSUMMON_TURN)
end
function c88887045.exgfilter(c,mg,mc)
	return mg:CheckSubGroup(c88887045.exgselect,1,#mg,c,mc)
end
function c88887045.exgselect(g,exc,mc)
	return g:IsContains(mc) and exc:IsXyzSummonable(g,#g,#g)
end
function c88887045.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return Duel.GetMatchingGroupCount(c88887045.exgfilter,tp,LOCATION_EXTRA,0,nil,mg,c)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c88887045.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsControler(1-tp) or not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local mg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	local exg=Duel.GetMatchingGroup(c88887045.exgfilter,tp,LOCATION_EXTRA,0,nil,mg,c)
	if #exg==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=exg:Select(tp,1,1,nil):GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local msg=mg:SelectSubGroup(tp,c88887045.exgselect,false,1,#mg,sc,c)
	Duel.XyzSummon(tp,sc,msg,#msg,#msg)
end
function c88887045.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeckAsCost() end
	Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function c88887045.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c88887045.thcon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(88887045)~=0 and not Duel.IsExistingMatchingCard(c88887045.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c88887045.thcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(88887045)~=0 and Duel.IsExistingMatchingCard(c88887045.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c88887045.thfilter(c)
	return c:IsSetCard(0x885) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c88887045.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c88887045.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c88887045.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c88887045.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end