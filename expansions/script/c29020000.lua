--镜子魔术少女
function c29020000.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c29020000.sprcon)
	e2:SetOperation(c29020000.sprop)
	c:RegisterEffect(e2)
end
function c29020000.sprfilter(c)
	return c:IsFaceup() and c:IsLevelAbove(5) and c:IsAbleToRemoveAsCost()
end
function c29020000.sprfilter1(c,tp,g,sc)
	local lv=c:GetLevel()
	return c:IsCodeListed(TYPE_TUNER) and g:IsExists(c29020000.sprfilter2,1,c,tp,c,sc,lv)
end
function c29020000.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c29020000.sprfilter,tp,LOCATION_MZONE,0,nil)
	return g:IsExists(c29020000.sprfilter1,1,nil,tp,g,c)
end
function c29020000.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c29020000.sprfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=g:FilterSelect(tp,c29020000.sprfilter1,1,1,nil,tp,g,c)
	local mc=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	Duel.Remove(g1,REASON_COST)
end