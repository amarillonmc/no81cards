--偽十二獣ネコマネス
function c88990218.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,3,c88990218.ovfilter,aux.Stringid(88990218,0),3,c88990218.xyzop)
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c88990218.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(c88990218.defval)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(88990218,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c88990218.cost)
	e3:SetTarget(c88990218.target)
	e3:SetOperation(c88990218.operation)
	c:RegisterEffect(e3)
end
function c88990218.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xf1) and not c:IsCode(88990218)
end
function c88990218.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,88990218)==0 end
	Duel.RegisterFlagEffect(tp,88990218,RESET_PHASE+PHASE_END,0,1)
end
function c88990218.atkfilter(c)
	return c:IsSetCard(0xf1) and c:GetAttack()>=0
end
function c88990218.atkval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(c88990218.atkfilter,nil)
	return g:GetSum(Card.GetAttack)
end
function c88990218.deffilter(c)
	return c:IsSetCard(0xf1) and c:GetDefense()>=0
end
function c88990218.defval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(c88990218.deffilter,nil)
	return g:GetSum(Card.GetDefense)
end
function c88990218.filter(c,e,tp)
	return c:IsAttackPos() and c:GetSummonPlayer()==1-tp and (not e or c:IsRelateToEffect(e))
end
function c88990218.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c88990218.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c88990218.filter,1,nil,nil,tp) end
	local g=eg:Filter(c88990218.filter,nil,nil,tp)
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c88990218.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c88990218.filter,nil,e,tp)
	Duel.Destroy(g,REASON_EFFECT)
end

