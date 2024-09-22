--百千抉择的匠人 鲁登斯特鲁古
function c67201120.initial_effect(c)
	--revive
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c67201120.spcost2)
	e1:SetTarget(c67201120.sptg2)
	e1:SetOperation(c67201120.spop2)
	c:RegisterEffect(e1)  
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DRAW)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	c:RegisterEffect(e2) 
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c67201120.opcon)
	e3:SetTarget(c67201120.optg)
	e3:SetOperation(c67201120.opop)
	c:RegisterEffect(e3)   
end
function c67201120.tdfilter(c)
	return c:IsSetCard(0x3670) and c:IsDiscardable()
end
function c67201120.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c67201120.tdfilter,tp,LOCATION_HAND,0,2,c) end
	Duel.DiscardHand(tp,c67201120.tdfilter,2,2,REASON_COST+REASON_DISCARD,c)
end
function c67201120.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c67201120.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
--
function c67201120.opcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) 
end
function c67201120.optg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.IsPlayerCanDraw(tp,1)
		and Duel.GetFlagEffect(tp,67201120)==0
	local b2=Duel.GetFlagEffect(tp,67201121)==0
	if chk==0 then return b1 or b2 end
end
function c67201120.opop(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.IsPlayerCanDraw(tp,1)
		and Duel.GetFlagEffect(tp,67201120)==0
	local b2=Duel.GetFlagEffect(tp,67201121)==0
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(67201120,1),aux.Stringid(67201120,2))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(67201120,1))
	elseif b2 then op=Duel.SelectOption(tp,aux.Stringid(67201120,2))+1
	else return end
	if op==0 then
		Duel.Draw(tp,1,REASON_EFFECT)
		local tc=Duel.GetOperatedGroup():GetFirst()
		if tc:IsType(TYPE_MONSTER) and tc:IsSetCard(0x3670) and Duel.SelectYesNo(tp,aux.Stringid(67201120,3)) then
			Duel.BreakEffect()
			if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
				Duel.Destroy(eg,REASON_EFFECT)
			end
		end  
		Duel.RegisterFlagEffect(tp,67201120,RESET_PHASE+PHASE_END,0,1)
	else
		Duel.NegateActivation(ev)
		Duel.RegisterFlagEffect(tp,67201121,RESET_PHASE+PHASE_END,0,1)
	end
end
