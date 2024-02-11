--桃绯咒壁
function c9910525.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c9910525.spcon)
	e2:SetCost(c9910525.spcost)
	e2:SetTarget(c9910525.sptg)
	e2:SetOperation(c9910525.spop)
	c:RegisterEffect(e2)
	--copy tsukisome release effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_SZONE)
	e3:SetOperation(c9910525.copyop)
	c:RegisterEffect(e3)
end
function c9910525.cfilter(c)
	return c:IsFaceupEx() and c:IsSetCard(0xa950)
end
function c9910525.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9910525.cfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,e:GetHandler())
end
function c9910525.costfilter(c)
	return c:IsFaceup() and c:IsReleasable()
end
function c9910525.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c9910525.costfilter,tp,LOCATION_ONFIELD,0,nil)
	if chk==0 then return #g>0 and Duel.GetMZoneCount(tp,g)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local rg=g:SelectSubGroup(tp,aux.mzctcheck,false,1,#g,tp)
	Duel.Release(rg,REASON_COST)
	e:SetLabel(#rg)
end
function c9910525.spfilter(c,e,tp)
	return c:IsSetCard(0xa950) and c:IsLevel(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9910525.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910525.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c9910525.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or e:GetLabel()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9910525.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if not tc then return end
	if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK)
		e1:SetValue(e:GetLabel()*1200)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
	Duel.SpecialSummonComplete()
end
function c9910525.rlfilter(c)
	return c:IsFaceupEx() and c:IsSetCard(0xa950) and c:IsReleasableByEffect()
end
function c9910525.efffilter(c,e,tp,eg,ep,ev,re,r,rp)
	if not (c:IsSetCard(0xa950) and c:IsType(TYPE_MONSTER)) then return false end
	local te=c.tsukisome_release_effect
	if not te or te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=te:GetTarget()
	return not tg or tg(e,tp,eg,ep,ev,re,r,rp,0)
end
function c9910525.copyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if rp==1-tp and c:GetFlagEffect(9910525)==0 and Duel.CheckReleaseGroupEx(tp,c9910525.rlfilter,1,REASON_EFFECT,true,nil)
		and Duel.SelectEffectYesNo(tp,c,aux.Stringid(9910525,0)) then
		Duel.Hint(HINT_CARD,0,9910525)
		local g=Duel.SelectReleaseGroupEx(tp,c9910525.rlfilter,1,1,REASON_EFFECT,true,nil)
		if #g>0 and Duel.Release(g,REASON_EFFECT)~=0
			and Duel.IsExistingMatchingCard(c9910525.efffilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,eg,ep,ev,re,r,rp)
			and Duel.SelectYesNo(tp,aux.Stringid(9910525,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9910525,2))
			local sg=Duel.SelectMatchingCard(tp,c9910525.efffilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp)
			if #sg>0 then
				local tc=sg:GetFirst()
				local te=tc.tsukisome_release_effect
				local op=te:GetOperation()
				if op then
					Duel.BreakEffect()
					Duel.HintSelection(sg)
					local lab=op(e,tp,eg,ep,ev,re,r,rp)
					if lab and lab>0 and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsOriginalCodeRule(lab) then
						Duel.NegateEffect(ev)
					end
				end
			end
		end
		local reset=0
		if Duel.GetTurnPlayer()==tp then
			reset=RESET_CHAIN
		else
			reset=RESET_PHASE+PHASE_END
		end
		c:RegisterFlagEffect(9910525,RESET_EVENT+RESETS_STANDARD+reset,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(9910525,3))
	end
end
