--double blade
function c82567897.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c82567897.cost)
	e1:SetTarget(c82567897.target)
	e1:SetOperation(c82567897.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c82567897.handcon)
	c:RegisterEffect(e2)
end
function c82567897.handcon(e)
	return Duel.GetLP(e:GetHandlerPlayer())<=4000
end
function c82567897.spfilter(c,e)
	return c:IsSetCard(0x825) 
	  and c:IsCanBeEffectTarget(e) and c:GetAttack()>=0 and c:IsFaceup()
end
function c82567897.indfilter(c,mat2)
	return c:GetAttack()>=mat2 and c:IsFaceup()
end
function c82567897.filter1(c)
	return c:IsSetCard(0x825) 
	   and c:GetAttack()>0 and c:IsFaceup()
end
function c82567897.filter2(g)
	return g:GetClassCount(Card.GetAttack)==#g
end
function c82567897.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_MUST_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetReset(RESET_PHASE+PHASE_BATTLE)
	Duel.RegisterEffect(e1,tp)
end
function c82567897.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=Duel.GetMatchingGroup(c82567897.spfilter,tp,LOCATION_MZONE,0,nil,e)
	if chk==0 then return g:GetCount()>=2 and g:GetClassCount(Card.GetAttack)>=2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g1=g:SelectSubGroup(tp,c82567897.filter2,false,2,2) 
	Duel.SetTargetCard(g1)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,g1,2,0,0)
end
function c82567897.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local ma=g:GetMaxGroup(Card.GetAttack)
	if ma:GetCount()==1 then
	local mat=ma:GetFirst():GetAttack()
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()==2 then
	local tcg=sg:Filter(Card.IsRelateToEffect,ma:GetFirst(),e)
	local tc=tcg:GetFirst()
	 local e9=Effect.CreateEffect(e:GetHandler())
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_SET_BASE_ATTACK)
	e9:SetValue(mat)
	e9:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e9)
	 end
	 end
	 Duel.BreakEffect()
	 local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	 local ma2=g:GetMaxGroup(Card.GetAttack)
	if ma2:GetCount()>0 then
	local mat2=ma:GetFirst():GetAttack()
	if Duel.IsExistingMatchingCard(c82567897.indfilter,tp,0,LOCATION_MZONE,1,nil,mat2) and  Duel.SelectYesNo(tp,aux.Stringid(82567897,0)) then 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	local oc=Duel.SelectMatchingCard(tp,c82567897.indfilter,tp,0,LOCATION_MZONE,1,1,nil,mat2)
	if oc:GetCount()>0 then
	local toc=oc:GetFirst()
	local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		toc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetValue(RESET_TURN_SET)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		toc:RegisterEffect(e3)

   end
   end
end
end
