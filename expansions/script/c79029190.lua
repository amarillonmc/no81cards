--耀星壳·浮金
function c190.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,99,c190.lcheck)
	c:EnableReviveLimit() 
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetTarget(c190.distg)
	c:RegisterEffect(e1)
	--cannot attack
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	c:RegisterEffect(e2) 
	--CANNOT_CHANGE_POSITION
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	c:RegisterEffect(e3)
	--down lp
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_DAMAGE)
	e4:SetCondition(c190.con)
	e4:SetOperation(c190.op)
	c:RegisterEffect(e4)
end
function c190.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0xfb)
end
function c190.distg(e,c)
	return c:GetDefense()<=e:GetHandler():GetAttack()
end
function c190.con(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp 
end
function c190.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,190)
	local lp=Duel.GetLP(1-tp)
	Duel.SetLP(1-tp,lp-300)
end






