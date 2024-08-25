--异圣之数码兽 丧尸暴龙兽
function c50223100.initial_effect(c)
	c:EnableReviveLimit()
	c:SetUniqueOnField(1,0,aux.FilterBoolFunction(Card.IsCode,50223100),LOCATION_MZONE)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c50223100.spcon)
	e2:SetOperation(c50223100.spop)
	c:RegisterEffect(e2)
	--loselp
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c50223100.lpcon)
	e3:SetOperation(c50223100.lpop)
	c:RegisterEffect(e3)
	--to deck
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_TODECK)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e7:SetCode(EVENT_PHASE+PHASE_END)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1)
	e7:SetCondition(c50223100.tdcon)
	e7:SetTarget(c50223100.tdtg)
	e7:SetOperation(c50223100.tdop)
	c:RegisterEffect(e7)
end
function c50223100.spcon(e,c)
	if c==nil then return true end
	return Duel.CheckReleaseGroup(REASON_COST,c:GetControler(),Card.IsCode,1,nil,50218102)
end
function c50223100.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(REASON_COST,tp,Card.IsCode,1,1,nil,50218102)
	Duel.Release(g,REASON_COST)
end
function c50223100.lpcon(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler())
end
function c50223100.lpop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc and tc:IsFaceup() and tc:GetBaseAttack()>0 then
			Duel.Hint(HINT_CARD,0,50223100)
			Duel.SetLP(tc:GetOwner(),Duel.GetLP(tc:GetOwner())-tc:GetBaseAttack())
		end
		tc=eg:GetNext()
	end
end
function c50223100.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c50223100.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c50223100.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end