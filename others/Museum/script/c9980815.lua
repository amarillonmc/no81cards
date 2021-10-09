--假面骑士部·Fourze-宇宙状态
function c9980815.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,6,3)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c9980815.imcon)
	e1:SetValue(c9980815.efilter)
	c:RegisterEffect(e1)
	--base atk/def
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c9980815.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	--todeck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9980815,1))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCountLimit(1)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c9980815.cost)
	e1:SetTarget(c9980815.target)
	e1:SetOperation(c9980815.operation)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9980815,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c9980815.spcon)
	e2:SetTarget(c9980815.sptg)
	e2:SetOperation(c9980815.spop)
	c:RegisterEffect(e2)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9980815.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9980815.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980815,3))
end
function c9980815.imfilter(c)
	return c:IsSetCard(0xcbc1) and c:IsType(TYPE_XYZ)
end
function c9980815.imcon(e)
	return e:GetHandler():GetOverlayGroup():IsExists(c9980815.imfilter,1,nil)
end
function c9980815.efilter(e,te)
	return not te:GetOwner():IsSetCard(0xcbc1)
end
function c9980815.atkval(e,c)
	return c:GetOverlayCount()*800
end
function c9980815.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c9980815.filter(c)
	return c:IsSetCard(0xcbc1) and c:IsAbleToDeck()
end
function c9980815.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and c9980815.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9980815.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c9980815.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c9980815.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA)
	local dg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil)
	if ct>0 and dg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local rg=dg:Select(tp,1,ct,nil)
		Duel.HintSelection(rg)
		Duel.SendtoDeck(rg,nil,2,REASON_EFFECT)
		Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980815,4))
	end
end
function c9980815.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetPreviousControler()==tp and rp==1-tp and c:IsReason(REASON_DESTROY)and c:GetOverlayGroup():IsExists(Card.IsType,1,nil,0xcbc1)
end
function c9980815.spfilter(c,e,tp)
	return c:IsCode(9980814) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9980815.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCountFromEx(tp)>0
		and Duel.IsExistingMatchingCard(c9980815.spfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_GRAVE)
end
function c9980815.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCountFromEx(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9980815.spfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 and c:IsRelateToEffect(e) then
		Duel.Overlay(g:GetFirst(),Group.FromCards(c))
	end
end