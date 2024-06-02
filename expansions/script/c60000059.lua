local cm,m,o=GetID()
function cm.initial_effect(c)
	--Effect 1
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_QUICK_O)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e0:SetRange(LOCATION_HAND)
	e0:SetCondition(cm.spcon)
	e0:SetTarget(cm.sptg)
	e0:SetOperation(cm.spop)
	c:RegisterEffect(e0)
	local e1=e0:Clone()
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.spcon1)
	c:RegisterEffect(e1) 
	--Effect 2  
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(cm.con)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
	--Effect 3 
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(cm.con1)
	e5:SetTarget(cm.tg1)
	e5:SetOperation(cm.op1)
	c:RegisterEffect(e5) 
end
--Effect 1
function cm.cfilter(c)
	return c:IsSetCard(0x626) or c:IsFacedown()
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE) then return false end
	return Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)>=15 
end
function cm.spcon1(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE) then return false end
	local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,0)
	return Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)>=15 and (#g==0 or (#g>0 and g:FilterCount(cm.cfilter,nil)==#g)) 
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and e:GetHandler():GetFlagEffect(m)==0  end
	e:GetHandler():RegisterFlagEffect(m,RESET_CHAIN,0,1) 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
--Effect 2
function cm.downfilter(c)
	return c:IsFacedown() and c:IsCanChangePosition()
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return  Duel.IsExistingMatchingCard(cm.downfilter,tp,0,LOCATION_MZONE,2,nil)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsExistingMatchingCard(cm.downfilter,tp,0,LOCATION_MZONE,2,nil) 
		and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		if Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler())  then
			Duel.Hint(HINT_CARD,0,m)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DEFENSE)
			local g=Duel.SelectMatchingCard(tp,cm.downfilter,tp,0,LOCATION_MZONE,2,2,nil)
			if #g>0  then
				Duel.ChangePosition(g,POS_FACEUP_ATTACK)
			end
			if Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
				local tc=g:GetFirst()
				while tc do
					if not tc:IsAttack(0) then
						local e4=Effect.CreateEffect(e:GetHandler())
						e4:SetType(EFFECT_TYPE_SINGLE)
						e4:SetCode(EFFECT_SET_ATTACK_FINAL)
						e4:SetReset(RESET_EVENT+RESETS_STANDARD)
						e4:SetValue(0)
						tc:RegisterEffect(e4)
					end
					tc=g:GetNext()
				end
			end
		else
			Duel.Hint(HINT_CARD,0,m)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DEFENSE)
			local g=Duel.SelectMatchingCard(tp,cm.downfilter,tp,0,LOCATION_MZONE,2,2,nil)
			if #g>0  then
				Duel.ChangePosition(g,POS_FACEUP_ATTACK)
			end
		end
	end
end
--Effect 3 
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE)
end
function cm.desfilter(c,g)
	return g:IsContains(c) and c:IsFacedown()
end
function cm.fselect(g)
	return g:IsExists(Card.IsFacedown,1,nil,nil)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local cg=e:GetHandler():GetColumnGroup()
	if chk==0 then return cg:CheckSubGroup(cm.fselect,1,1) 
	and e:GetHandler():IsAbleToHand()
	and e:GetHandler():GetFlagEffect(60000060)==0 end
	local g=Duel.GetMatchingGroup(cm.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,cg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	e:GetHandler():RegisterFlagEffect(60000060,RESET_CHAIN,0,1) 
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cg=c:GetColumnGroup()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		if c:IsLocation(LOCATION_HAND) then
			local g=Duel.GetMatchingGroup(cm.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,cg)
			if g:GetCount()>0 then
				Duel.Destroy(g,REASON_EFFECT)
			end
		end
	end
end
