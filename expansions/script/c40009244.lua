--超宇宙勇机 雄伟疾驰EX
function c40009244.initial_effect(c)
	c:EnableCounterPermit(0x1f1b)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),8,2)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40009244,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c40009244.spcost)
	e1:SetTarget(c40009244.cttg)
	e1:SetOperation(c40009244.ctop)
	c:RegisterEffect(e1)	
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCondition(c40009244.atkcon)
	e2:SetValue(c40009244.efilter)
	c:RegisterEffect(e2)
end
function c40009244.efilter(e,te)
	return not te:GetOwner():IsSetCard(0x1f1b)
end
function c40009244.filter(c)
	return c:IsSetCard(0x1f1b) and c:IsType(TYPE_XYZ)
end
function c40009244.atkcon(e)
	return e:GetHandler():GetOverlayGroup():IsExists(c40009244.filter,1,nil)
end
function c40009244.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	local ct=Duel.GetOperatedGroup():GetFirst()
	e:SetLabelObject(ct)
end
function c40009244.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanAddCounter(0x1f1b,1) end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x1f1b)
end
function c40009244.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
	   if c:AddCounter(0x1f1b,1) and (e:GetLabelObject():IsType(TYPE_MONSTER) and e:GetLabelObject():IsSetCard(0x1f1b)) then 
		local atk=e:GetLabelObject():GetAttack()
		local def=e:GetLabelObject():GetDefense()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(e:GetLabelObject():GetAttack())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		e2:SetValue(e:GetLabelObject():GetDefense())
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e2)
	   end
	local g=Duel.GetMatchingGroup(c40009244.ctfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(40009244,1))
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_BATTLE_DAMAGE)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetCondition(c40009244.damcon)
		e1:SetOperation(c40009244.damop)
		tc:RegisterEffect(e1)
	end
	end
end
function c40009244.damcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and e:GetHandler():GetCounter(0x1f1b)>0
end
function c40009244.damop(e,tp)
	Duel.Hint(HINT_CARD,0,40009244)
	local c=e:GetHandler()
	local ct=c:GetCounter(0x1f1b)
	local atk=c:GetAttack() 
	if atk<=0 then return end
	for i=1,ct do 
		Duel.Damage(1-tp,atk,REASON_EFFECT)
		if Duel.GetLP(1-tp)<=0 then return end
	end
end