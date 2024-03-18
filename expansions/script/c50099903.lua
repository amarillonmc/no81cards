--无标之艺
function c50099903.initial_effect(c) 
	--neg sp 
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING) 
	e1:SetProperty(EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c50099903.ngspcon)
	e1:SetTarget(c50099903.ngsptg)
	e1:SetOperation(c50099903.ngspop)
	c:RegisterEffect(e1)
	--prevent counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_PLACE_COUNTER)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,1)
	c:RegisterEffect(e2)
end
function c50099903.ngspcon(e,tp,eg,ep,ev,re,r,rp) 
	local rc=re:GetHandler()  
	local x=0 
	for i=1,ev do
		local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		if tgp~=tp and (te:IsActiveType(TYPE_MONSTER) or te:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainDisablable(i) then
			x=1 
		end
	end
	return rc and rc:GetCounter(0)>0 and x~=0 
end 
function c50099903.ngsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local sg=Duel.GetMatchingGroup(function(c) return c:GetCounter(0)~=0 end,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and sg:GetCount()>0 end 
	local ng=Group.CreateGroup()
	for i=1,ev do
		local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		if tgp~=tp and Duel.IsChainDisablable(i) then
			local tc=te:GetHandler()
			ng:AddCard(tc) 
		end
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0) 
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,ng,ng:GetCount(),0,0)
end
function c50099903.ngspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then 
		local sg=Duel.GetMatchingGroup(function(c) return c:GetCounter(0)~=0 end,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil) 
		if sg:GetCount()==0 then return end 
		local tc=sg:GetFirst()
		local count=0
		while tc do
			count=count+tc:GetCounter(0x100e)
			tc:RemoveCounter(tp,0,0,0)
			tc=sg:GetNext()
		end
		if count>0 then
			Duel.RaiseEvent(e:GetHandler(),EVENT_REMOVE_COUNTER+0x100e,e,REASON_EFFECT,tp,tp,count)
		end 
		for i=1,ev do
			local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
			if tgp~=tp then
				Duel.NegateEffect(i) 
			end
		end 
	end 
end 















