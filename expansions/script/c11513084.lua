--征服斗魂 爆裂★天使
function c11513084.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_DAMAGE+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,11513084+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(c11513084.cost)
	e1:SetTarget(c11513084.target)
	e1:SetOperation(c11513084.activate)
	c:RegisterEffect(e1)
	--act in set turn
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e2)
end
function c11513084.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x195) and c:IsAbleToHandAsCost() 
end
function c11513084.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if not c:IsStatus(STATUS_SET_TURN) then return true end
	local ct=#{c:IsHasEffect(EFFECT_QP_ACT_IN_SET_TURN,tp)}
	local dis=Duel.IsExistingMatchingCard(c11513084.cfilter,tp,LOCATION_MZONE,0,1,nil)
	if chk==0 then return ct>1 or dis end
	if ct==1 or dis and Duel.SelectYesNo(tp,aux.Stringid(11513084,0)) then
		local sg=Duel.SelectMatchingCard(tp,c11513084.cfilter,tp,LOCATION_MZONE,0,1,1,nil) 
		Duel.SendtoHand(sg,nil,REASON_COST)
	end
end 
function c11513084.pbfil(c) 
	return not c:IsPublic() and c:IsAttribute(ATTRIBUTE_DARK+ATTRIBUTE_EARTH+ATTRIBUTE_FIRE) 
end 
function c11513084.target(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetMatchingGroup(c11513084.pbfil,tp,LOCATION_HAND,0,nil)  
	if chk==0 then return g:CheckSubGroup(aux.dabcheck,1,3) end 
	local sg=g:SelectSubGroup(tp,aux.dabcheck,false,1,3)
	Duel.ConfirmCards(1-tp,sg)
	Duel.RaiseEvent(sg,EVENT_CUSTOM+9091064,e,REASON_COST,tp,tp,0) 
	local x=sg:GetCount() 
	e:SetLabel(x)
	local dam=0  
	if x>=1 then dam=dam+400 end 
	if x>=2 then dam=dam+600 end 
	if x==3 then dam=dam+800 end  
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)  
end
function c11513084.thfil(c) 
	return c:IsAbleToHand() and c:IsSetCard(0x195) 
end 
function c11513084.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	local x=e:GetLabel() 
	if x>=1 and Duel.Damage(1-tp,400,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c11513084.thfil,tp,LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(11513084,1)) then 
		local tc=Duel.SelectMatchingCard(tp,c11513084.thfil,tp,LOCATION_GRAVE,0,1,1,nil):GetFirst() 
		if tc:IsType(TYPE_MONSTER) and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(11513084,2)) then 
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) 
		else 
			Duel.SendtoHand(tc,nil,REASON_EFFECT)  
		end 
	end 
	if x>=2 and Duel.Damage(1-tp,600,REASON_EFFECT)~=0 then 
		--inactivatable
		--local e4=Effect.CreateEffect(c)
		--e4:SetType(EFFECT_TYPE_FIELD)
		--e4:SetCode(EFFECT_CANNOT_INACTIVATE) 
		--e4:SetValue(c11513084.effectfilter)
		--e4:SetReset(RESET_PHASE+PHASE_END)
		--Duel.RegisterEffect(e4,tp)
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_FIELD)
		e5:SetCode(EFFECT_CANNOT_DISEFFECT) 
		e5:SetValue(c11513084.effectfilter) 
		e5:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e5,tp)
	end 
	if x>=3 and Duel.Damage(1-tp,800,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(11513084,3)) then 
		Duel.BreakEffect() 
		local ng=Duel.GetMatchingGroup(aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil) 
		local tc=ng:GetFirst() 
		while tc do 
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=e1:Clone()
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			tc:RegisterEffect(e3)
		end
		tc=ng:GetNext() 
		end 
	end 
end 
function c11513084.effectfilter(e,ct)
	local p=e:GetHandler():GetControler()
	local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
	return p==tp and te:GetHandler():IsSetCard(0x195) and bit.band(loc,LOCATION_ONFIELD)~=0
end


