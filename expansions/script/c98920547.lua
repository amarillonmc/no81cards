--超越龙 燃烧蛋白石头龙头领
function c98920547.initial_effect(c)
	c:EnableReviveLimit()
	 --battle indestructable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetCondition(c98920547.tgcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c98920547.tgcon)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--indestructable
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	 --remove
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(98920547,0))
	e4:SetCategory(CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,98930547)
	e4:SetCondition(c98920547.tdcon)
	e4:SetTarget(c98920547.tdtg)
	e4:SetOperation(c98920547.tdop)
	c:RegisterEffect(e4) 
	local e5=e4:Clone()
	e5:SetCode(EVENT_TO_DECK)
	e5:SetCondition(c98920547.descon)
	c:RegisterEffect(e5) 
	--special summon or self
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(98920547,0))
	e6:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCode(EVENT_DESTROYED)
	e6:SetCountLimit(1,98940547)
	e6:SetTarget(c98920547.tdtg1)
	e6:SetOperation(c98920547.tdop1)
	c:RegisterEffect(e6)
end
function c98920547.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_DINOSAUR)
end
function c98920547.tgcon(e)
	return Duel.IsExistingMatchingCard(c98920547.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end
function c98920547.tgfilter(c,tp)
	return c:IsControler(tp) and c:IsType(TYPE_NORMAL)
end
function c98920547.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c98920547.tgfilter,1,nil,tp)
end
function c98920547.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_ONFIELD)
end
function c98920547.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=g:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	end
end
function c98920547.ttkfilter(c,tp)
	return c:IsPreviousControler(tp) and c:IsType(TYPE_NORMAL)
end
function c98920547.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c98920547.ttkfilter,1,nil,tp)
end
function c98920547.tdfilter(c)
	return c:IsType(TYPE_NORMAL) and c:IsAbleToDeck()
end
function c98920547.tdtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920547.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
	if e:GetActivateLocation()==LOCATION_GRAVE then
		e:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	else
		e:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	end
end
function c98920547.tdop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c98920547.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		local c=e:GetHandler()
		if Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0
			and g:FilterCount(Card.IsLocation,nil,LOCATION_DECK)>0
			and c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and Duel.SelectYesNo(tp,aux.Stringid(98920547,1)) then
			Duel.BreakEffect()
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end