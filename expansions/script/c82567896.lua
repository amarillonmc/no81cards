--怒号光明
function c82567896.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c82567896.cost)
	e1:SetCondition(c82567896.con)
	e1:SetOperation(c82567896.activate)
	c:RegisterEffect(e1)
end
function c82567896.akfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x825) 
end
function c82567896.desfilter(c,lp)
	return c:IsFaceup()  and c:IsAttackBelow(lp) and c:IsAbleToGrave()
end
function c82567896.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLP(tp)>100 and Duel.GetLP(tp)<=3000 end
	local lp=Duel.GetLP(tp)
	e:SetLabel(lp-100)
	Duel.PayLPCost(tp,lp-100)
end
function c82567896.con(e,tp,eg,ep,ev,re,r,rp)
	 local lp0=Duel.GetLP(tp)
	local lp=lp0-100
	return Duel.IsExistingMatchingCard(c82567896.akfilter,tp,LOCATION_MZONE,0,1,nil) and  Duel.IsExistingMatchingCard(c82567896.desfilter,tp,0,LOCATION_MZONE,1,nil,lp)
end
function c82567896.activate(e,tp,eg,ep,ev,re,r,rp)
	local lp=e:GetLabel()
   if not Duel.IsExistingMatchingCard(c82567896.akfilter,tp,LOCATION_MZONE,0,1,nil) or not  Duel.IsExistingMatchingCard(c82567896.desfilter,tp,0,LOCATION_MZONE,1,nil,lp)
	  then return end
	local g=Duel.GetMatchingGroup(c82567896.desfilter,tp,0,LOCATION_MZONE,nil,lp)
	if g:GetCount()>0 then
	Duel.SendtoGrave(g,REASON_EFFECT)
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	 local tcg=Duel.SelectMatchingCard(tp,c82567896.akfilter,tp,LOCATION_MZONE,0,1,1,nil)
	 local tc=tcg:GetFirst()
	  local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD)
	e3:SetValue(lp)
	tc:RegisterEffect(e3)
end
end