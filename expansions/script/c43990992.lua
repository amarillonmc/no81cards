--黑白王棋
function c43990992.initial_effect(c)
	--copy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(43990992,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetCountLimit(1,43990992)
	e1:SetCondition(c43990992.cpcon)
	e1:SetTarget(c43990992.cptg)
	e1:SetOperation(c43990992.cpop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(43990992,1))
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c43990992.spcost)
	e2:SetTarget(c43990992.sptg)
	e2:SetOperation(c43990992.spop)
	c:RegisterEffect(e2)
end
function c43990992.cpcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function c43990992.cpfilter(c)
	return c:IsSetCard(0x9510) and c:IsFaceupEx() and c:CheckActivateEffect(false,true,false)~=nil
end
function c43990992.cptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c43990992.cpfilter,tp,LOCATION_HAND+LOCATION_SZONE+LOCATION_GRAVE,0,1,nil) end
end
function c43990992.cpop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local tc=Duel.SelectMatchingCard(tp,c43990992.cpfilter,tp,LOCATION_HAND+LOCATION_SZONE+LOCATION_GRAVE,0,1,1,nil):GetFirst()
	if tc then
		--Duel.HintSelection(Group.FromCards(tc))
		Duel.ConfirmCards(1-tp,tc)
		local te,ceg,cep,cev,cre,cr,crp=tc:CheckActivateEffect(false,true,true)
		local tg=te:GetTarget()
		if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
	end
end
function c43990992.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c43990992.cfilter(c,e,tp,ec)
	return c:IsSetCard(0x9510) and (c:IsAbleToHand() or (Duel.GetMZoneCount(tp,ec)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function c43990992.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c43990992.cfilter,tp,LOCATION_DECK,0,1,nil,e,tp,e:GetHandler()) end
end
function c43990992.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local sc=Duel.SelectMatchingCard(tp,c43990992.cfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,nil):GetFirst()
	local b1=sc:IsAbleToHand()
	local b2=Duel.GetMZoneCount(tp)>0 and sc:IsCanBeSpecialSummoned(e,0,tp,false,false)
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,1190,1152)
	elseif b1 then op=0
	else op=1 end
	if op==0 then
		Duel.SendtoHand(sc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sc)
	else
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
	end
end
