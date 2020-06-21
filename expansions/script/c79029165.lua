--罗德岛·狙击干员-空爆
function c79029165.initial_effect(c)
	 --destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_DECK)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c79029165.descost)
	e1:SetTarget(c79029165.destg)
	e1:SetOperation(c79029165.desop)
	e1:SetCountLimit(1,79029165)
	c:RegisterEffect(e1)	  
end
function c79029165.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c79029165.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x1099,4,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x1099,4,REASON_COST)
end
function c79029165.desfilter2(c,s,tp)
	local seq=c:GetSequence()
	return seq<5 and  math.abs(seq-s)==1 and c:IsControler(tp)
end
function c79029165.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return c:IsDestructable() and g:GetCount()>0 end
	local tc=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
end
function c79029165.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local a=Duel.GetFirstTarget()
	local seq=a:GetSequence()
		 local dg=Group.CreateGroup()
		if seq<5 then dg=Duel.GetMatchingGroup(c79029165.desfilter2,tp,0,LOCATION_MZONE,nil,seq,a:GetControler()) end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(a:GetAttack()/2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		a:RegisterEffect(e1)
		if dg:GetCount()>0 then
		local tc=dg:GetFirst()
		while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(tc:GetAttack()/2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=dg:GetNext() 
end	
	end
end

