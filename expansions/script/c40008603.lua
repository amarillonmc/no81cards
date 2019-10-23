--究极异兽-美丽之费洛美螂
function c40008603.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,6,3,c40008603.ovfilter,aux.Stringid(40008603,0),3,c40008603.xyzop)
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c40008603.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(c40008603.defval)
	c:RegisterEffect(e2) 
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(40008603,1))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,40008603)
	e3:SetCost(c40008603.cost)
	e3:SetTarget(c40008603.dmtg)
	e3:SetOperation(c40008603.dmop)
	c:RegisterEffect(e3)   
end
function c40008603.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c40008603.ovfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsRank(5) and c:GetOverlayCount()>1
end
function c40008603.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,40008603)==0 end
	Duel.RegisterFlagEffect(tp,40008603,RESET_PHASE+PHASE_END,0,1)
end
function c40008603.atkfilter(c)
	return c:GetAttack()>=0
end
function c40008603.atkval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(c40008603.atkfilter,nil)
	return g:GetSum(Card.GetAttack)
end
function c40008603.deffilter(c)
	return c:GetDefense()>=0
end
function c40008603.defval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(c40008603.deffilter,nil)
	return g:GetSum(Card.GetDefense)
end
function c40008603.dmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(c:GetAttack()/2)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,c:GetAttack()/2)
end
function c40008603.dmop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
