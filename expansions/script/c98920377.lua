--自奏圣乐·皮格马利翁
function c98920377.initial_effect(c)
	 --link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,2,c98920377.lcheck)
	c:EnableReviveLimit()
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetCondition(c98920377.indcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--todeck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920377,0))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,98920377)
	e2:SetCondition(c98920377.tdcon1)
	e2:SetTarget(c98920377.tdtg)
	e2:SetOperation(c98920377.tdop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCondition(c98920377.tdcon2)
	c:RegisterEffect(e3)
end
function c98920377.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x11b)
end
function c98920377.indcon(e)
	return e:GetHandler():IsLinkState()
end
function c98920377.tdcon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,90351981)
end
function c98920377.tdcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,90351981)
end
function c98920377.tdfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:IsAbleToDeck()
end
function c98920377.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c98920377.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c98920377.tdfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c98920377.tdfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c98920377.filter(c,e,tp)
	return c:IsSetCard(0x11b) and not c:IsType(TYPE_LINK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98920377.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_DECK+LOCATION_EXTRA) then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		if Duel.SelectYesNo(tp,aux.Stringid(98920377,1)) then
		   local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c98920377.filter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
		   if g:GetCount()>0 then		
			  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			  Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		   end
		end
	end
end
