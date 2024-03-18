--现世的赤龙唤士 索妮娅
function c60159906.initial_effect(c)
	c:EnableReviveLimit()
	--splimit
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_SPSUMMON_COST)
	e6:SetCost(c60159906.e00cost)
	c:RegisterEffect(e6)
	--special summon rule
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_SPSUMMON_PROC)
	e5:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e5:SetRange(LOCATION_EXTRA)
	e5:SetValue(SUMMON_TYPE_LINK)
	e5:SetCondition(c60159906.sprcon)
	e5:SetOperation(c60159906.sprop)
	c:RegisterEffect(e5)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c60159906.linklimit)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c60159906.con)
	e3:SetTarget(c60159906.tg)
	e3:SetOperation(c60159906.op)
	c:RegisterEffect(e3)
end
function c60159906.e00cost(e,c,tp,st)
	if bit.band(st,SUMMON_TYPE_LINK)~=SUMMON_TYPE_LINK then return true end
	return Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c60159906.cfilter(c,tp,lc)
	return c:IsCanBeLinkMaterial(lc) and c:IsFaceup() and c:GetSummonLocation()&(LOCATION_DECK+LOCATION_EXTRA)~=0
		and not (c:IsAttribute(ATTRIBUTE_LIGHT) or c:IsAttribute(ATTRIBUTE_DARK) or c:IsAttribute(ATTRIBUTE_DEVINE))
end
function c60159906.fselect(c,tp,mg,sg)
	sg:AddCard(c)
	local res=false
	if sg:GetCount()<4 then
		res=mg:IsExists(c60159906.fselect,1,sg,tp,mg,sg)
	elseif Duel.GetLocationCountFromEx(tp,tp,sg)>0 then
		res=sg:GetClassCount(Card.GetLinkAttribute)==4
	end
	sg:RemoveCard(c)
	return res
end
function c60159906.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c60159906.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp,c)
	local sg=Group.CreateGroup()
	return mg:IsExists(c60159906.fselect,1,nil,tp,mg,sg)
end
function c60159906.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c60159906.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
	local sg=Group.CreateGroup()
	while sg:GetCount()<4 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
		local g=mg:FilterSelect(tp,c60159906.fselect,1,1,sg,tp,mg,sg)
		sg:Merge(g)
	end
	c:SetMaterial(sg)
	Duel.SendtoGrave(sg,REASON_COST+REASON_LINK+REASON_MATERIAL)
end
function c60159906.linklimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end
function c60159906.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c60159906.filter(c)
	return c:IsAbleToDeck()
end
function c60159906.filter2(c)
	return not (c:IsAttribute(ATTRIBUTE_EARTH) or c:IsAttribute(ATTRIBUTE_WATER) 
		or c:IsAttribute(ATTRIBUTE_FIRE) or c:IsAttribute(ATTRIBUTE_WIND)) and c:IsType(TYPE_MONSTER) 
		and c:IsAbleToRemove()
end
function c60159906.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c60159906.filter,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_HAND,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_HAND,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,99,tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,99,1-tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_EXTRA)
	Duel.SetChainLimit(aux.FALSE)
end
function c60159906.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c60159906.filter,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_HAND,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_HAND,e:GetHandler())
	if Duel.SendtoDeck(g,nil,2,REASON_EFFECT) then Duel.BreakEffect()
		local g1=Duel.GetFieldGroup(tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_EXTRA,0)
		local g2=Duel.GetFieldGroup(tp,0,LOCATION_GRAVE+LOCATION_DECK+LOCATION_EXTRA)
		Duel.ConfirmCards(1-tp,g1)
		Duel.ConfirmCards(tp,g2)
		local g3=Duel.GetMatchingGroup(c60159906.filter2,tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_EXTRA,LOCATION_GRAVE+LOCATION_DECK+LOCATION_EXTRA,nil)
		Duel.Remove(g3,POS_FACEDOWN,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
		Duel.ShuffleDeck(1-tp)
		Duel.ShuffleHand(tp)
		Duel.ShuffleHand(1-tp)
	end
end