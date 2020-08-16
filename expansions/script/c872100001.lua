function c872100001.initial_effect(c)
	c:SetSPSummonOnce(872100001)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,
	0xba1 and Card.IsFusionType,TYPE_TUNER ),aux.FilterBoolFunction(Card.IsFusionSetCard,0xba1),true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCountLimit(1,872100001)
	e2:SetCondition(c872100001.sprcon)
	e2:SetOperation(c872100001.sprop)
	c:RegisterEffect(e2) 
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(872100001,2))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c872100001.negcon)
	e3:SetTarget(c872100001.negtg)
	e3:SetOperation(c872100001.negop)
	c:RegisterEffect(e3)
end
function c872100001.sprfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsDestructable()
end
function c872100001.sprfilter1(c,tp,g,sc)
	local lv=c:GetLevel()
	return c:IsSetCard(0xba1) and g:IsExists(c872100001.sprfilter2,1,c,tp,c,sc,lv)
end
function c872100001.sprfilter2(c,tp,mc,sc,lv)
	local sg=Group.FromCards(c,mc)
	return c:IsSetCard(0xba1)
		and Duel.GetLocationCountFromEx(tp,tp,sg,sc)>0
end
function c872100001.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c872100001.sprfilter,tp,LOCATION_DECK,0,nil)
	return g:IsExists(c872100001.sprfilter1,1,nil,tp,g,c)
end
function c872100001.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c872100001.sprfilter,tp,LOCATION_DECK,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=g:FilterSelect(tp,c872100001.sprfilter1,1,1,nil,tp,g,c)
	local mc=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=g:FilterSelect(tp,c872100001.sprfilter2,1,1,mc,tp,mc,c,mc:GetLevel())
	g1:Merge(g2)
	Duel.Destroy(g1,REASON_EFFECT)
end
--
function c872100001.negcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and ep~=tp
		and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c872100001.desfilter(c)
	return (c:IsLocation(LOCATION_HAND+LOCATION_DECK) or c:IsFaceup()) and c:IsType(TYPE_MONSTER) and c:IsSetCard(0xba1)
end
function c872100001.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c872100001.desfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c872100001.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectMatchingCard(tp,c872100001.desfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_DECK,0,1,1,nil)
	if g1:GetCount()>0 and Duel.Destroy(g1,REASON_EFFECT)~=0 then
		if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
			Duel.Destroy(eg,REASON_EFFECT)
		end
	end
   Duel.Hint(HINT_MUSIC,0,aux.Stringid(872100001,0))
end
