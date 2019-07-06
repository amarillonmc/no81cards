--动物朋友 野生解放
function c33700061.initial_effect(c)
	c33700061[c]={}
	local effect_list=c33700061[c]
	  --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c33700061.target)
	e1:SetOperation(c33700061.operation)
	c:RegisterEffect(e1)
end
c33700061.card_code_list={33700056}
function c33700061.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  Duel.IsExistingMatchingCard(c33700061.confilter,tp,LOCATION_MZONE,0,1,nil)  end
end
function c33700061.confilter(c)
	return c:IsSetCard(0x442) and c:IsFaceup()
end
function c33700061.operation(e,tp,eg,ep,ev,re,r,rp)
	 local g=Duel.GetMatchingGroup(c33700061.confilter,tp,LOCATION_GRAVE,0,nil)
	local cg=Duel.GetMatchingGroup(c33700061.confilter,tp,LOCATION_MZONE,0,nil)
	local tc=cg:GetFirst()
	if cg:GetCount()<=0 then return end
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
		tc=cg:GetNext()
	end
	Duel.BreakEffect()
   if g:GetClassCount(Card.GetCode)>2  and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) then
   local tg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local tc2=tg:GetFirst()
	while tc2 do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-500)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc2:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc2:RegisterEffect(e2)
		tc2=tg:GetNext()
	end
end
 if g:GetClassCount(Card.GetCode)>6  and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) then
 local tg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local tc2=tg:GetFirst()
	while tc2 do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetValue(tc2:GetBaseAttack()/2)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc2:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_BASE_DEFENSE)
		e2:SetValue(tc2:GetBaseDefense()/2)
		tc2:RegisterEffect(e2)
		tc2=tg:GetNext()
	end
end
 if g:GetClassCount(Card.GetCode)>12  then 
	local tg=Duel.GetMatchingGroup(c33700061.confilter,tp,LOCATION_MZONE,0,nil)
	local tc2=tg:GetFirst()
	while tc2 do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
		e1:SetCondition(c33700061.damcon)
		e1:SetOperation(c33700061.damop)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc2:RegisterEffect(e1)
		tc2=tg:GetNext()
	end
	end
 local hg=Duel.GetMatchingGroup(nil,tp,LOCATION_GRAVE,0,nil)
 if g:GetClassCount(Card.GetCode)>19 and hg:GetClassCount(Card.GetCode)==hg:GetCount() then 
  local dg1=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	local dg2=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
   if  Duel.Destroy(dg1,REASON_EFFECT)>0 and dg2:GetCount()>=0 then
	Duel.BreakEffect()
	Duel.SendtoGrave(dg,REASON_EFFECT)
end
end
end
function c33700061.damcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp 
end
function c33700061.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev*2)
end