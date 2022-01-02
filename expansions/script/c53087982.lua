--北极天熊-七元解厄
function c53087982.initial_effect(c)
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
	e2:SetCondition(c53087982.sprcon)
	e2:SetOperation(c53087982.sprop)
	c:RegisterEffect(e2)
	--SpecialSummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(53087982,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c53087982.target)
	e3:SetOperation(c53087982.activate)
	c:RegisterEffect(e3)
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(53087982,0))
	e4:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetTarget(c53087982.thtg)
	e4:SetOperation(c53087982.thop)
	c:RegisterEffect(e4)
end
function c53087982.tgrfilter(c)
	return c:IsFaceup() and c:IsLevelAbove(1) and c:IsAbleToGraveAsCost()
end
function c53087982.tgrfilter1(c)
	return c:IsType(TYPE_TUNER) and c:IsLevelAbove(8)
end
function c53087982.tgrfilter2(c)
	return not c:IsType(TYPE_TUNER) and c:IsType(TYPE_SYNCHRO)
end
function c53087982.mnfilter(c,g)
	return g:IsExists(c53087982.mnfilter2,1,c,c)
end
function c53087982.mnfilter2(c,mc)
	return c:GetLevel()-mc:GetLevel()==7
end
function c53087982.fselect(g,tp,sc)
	return g:GetCount()==2
		and g:IsExists(c53087982.tgrfilter1,1,nil) and g:IsExists(c53087982.tgrfilter2,1,nil)
		and g:IsExists(c53087982.mnfilter,1,nil,g)
		and Duel.GetLocationCountFromEx(tp,tp,g,sc)>0
end
function c53087982.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c53087982.tgrfilter,tp,LOCATION_MZONE,0,nil)
	return g:CheckSubGroup(c53087982.fselect,2,2,tp,c)
end
function c53087982.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c53087982.tgrfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg=g:SelectSubGroup(tp,c53087982.fselect,false,2,2,tp,c)
	Duel.SendtoGrave(tg,REASON_COST)
end
function c53087982.filter1(c,e,tp)
	return c:IsLevel(8) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_TUNER) and c:IsAbleToDeck()
		and Duel.IsExistingTarget(c53087982.filter2,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,c,e,tp,c:GetLevel(),c)
end
function c53087982.filter2(c,e,tp,lv,ec)
	local lvc=c:GetLevel()
	if lvc>lv then lvc,lv=lv,lvc end
	local g=Group.__add(c,ec)
	return c:IsType(TYPE_MONSTER) and c:IsLevelAbove(0) and c:IsAbleToDeck()
		and Duel.IsExistingMatchingCard(c53087982.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,lv-lvc,g)
end
function c53087982.spfilter(c,e,tp,lv,g)
	return c:IsType(TYPE_SYNCHRO) and c:IsLevel(lv)
		and Duel.GetLocationCountFromEx(tp,tp,g,c)>0 and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c53087982.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c53087982.filter1,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectTarget(tp,c53087982.filter1,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g2=Duel.SelectTarget(tp,c53087982.filter2,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,1,g1:GetFirst(),e,tp,g1:GetFirst():GetLevel(),g1:GetFirst())
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g1,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c53087982.activate(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=2 then return end
	if Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)==2 then
		local og=Duel.GetOperatedGroup()
		local lv=og:GetFirst():GetLevel()
		local lv2=og:GetNext():GetLevel()
		if lv2>lv then lv2,lv=lv,lv2 end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c53087982.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lv-lv2,og)
		if #sg>0 then
			Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP)
		end
	end
end
function c53087982.thfilter(c)
	return c:IsSetCard(0x163) and c:IsAbleToHand()
end
function c53087982.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c53087982.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c53087982.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c53087982.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
