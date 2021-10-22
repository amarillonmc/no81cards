--No.114514 野兽先辈
function c114514.initial_effect(c)
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
	e2:SetCondition(c114514.spcon)
	e2:SetOperation(c114514.spop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e3)
end
function c114514.rfilter(c,tp)
	return c:IsControler(tp) and c:IsFaceup() and not c:IsCode(114514)
end
function c114514.sumfilter(c)
	return c:GetAttack()
end
function c114514.fselect(g,tp)
	Duel.SetSelectedCard(g)
	return g:CheckWithSumGreater(c114514.sumfilter,114514) and aux.mzctcheckrel(g,tp)
end
function c114514.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetMatchingGroup(Card.IsAbleToDeckAsCost,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,0,nil):Filter(c114514.rfilter,nil,tp)
	return rg:CheckSubGroup(c114514.fselect,1,rg:GetCount(),tp)
end
function c114514.spop(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local rg=Duel.GetMatchingGroup(Card.IsAbleToDeckAsCost,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,0,nil):Filter(c114514.rfilter,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=rg:SelectSubGroup(tp,c114514.fselect,true,1,rg:GetCount(),tp)
	if sg then
		Duel.SendtoDeck(sg,nil,2,REASON_COST)
		return true
	else return false end
end