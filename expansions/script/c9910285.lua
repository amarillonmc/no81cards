--星幽使 三司绫濑
function c9910285.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,9910285)
	e1:SetCost(c9910285.cost)
	e1:SetTarget(c9910285.target)
	e1:SetOperation(c9910285.operation)
	c:RegisterEffect(e1)
	--reload
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,9910286)
	e2:SetCondition(c9910285.drcon)
	e2:SetTarget(c9910285.drtg)
	e2:SetOperation(c9910285.drop)
	c:RegisterEffect(e2)
	--move
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,9910287)
	e3:SetTarget(c9910285.seqtg)
	e3:SetOperation(c9910285.seqop)
	c:RegisterEffect(e3)
end
function c9910285.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsAbleToDeckAsCost()
end
function c9910285.spfilter(c,e,tp)
	return c:IsCode(9910288) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c9910285.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910285.cfilter,tp,LOCATION_EXTRA,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c9910285.cfilter,tp,LOCATION_EXTRA,0,3,3,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c9910285.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910285.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9910285.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9910285.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c9910285.lfilter(c,mc)
	return c:IsSetCard(0x957) and c:IsType(TYPE_LINK) and c:GetLinkedGroup():IsContains(mc)
end
function c9910285.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9910285.lfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e:GetHandler())
end
function c9910285.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local h1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local h2=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	if chk==0 then return (Duel.IsPlayerCanDraw(tp) or h1==0)
		and (Duel.IsPlayerCanDraw(1-tp) or h2==0)
		and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,LOCATION_HAND,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,PLAYER_ALL,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,1)
end
function c9910285.drop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,LOCATION_HAND)
	if Duel.SendtoDeck(g,nil,0,REASON_EFFECT)~=0 then
		local og=g:Filter(Card.IsLocation,nil,LOCATION_DECK)
		if og:IsExists(Card.IsControler,1,nil,tp) then Duel.ShuffleDeck(tp) end
		if og:IsExists(Card.IsControler,1,nil,1-tp) then Duel.ShuffleDeck(1-tp) end
		Duel.BreakEffect()
		local ct1=og:FilterCount(aux.FilterEqualFunction(Card.GetPreviousControler,tp),nil)
		local ct2=og:FilterCount(aux.FilterEqualFunction(Card.GetPreviousControler,1-tp),nil)
		Duel.Draw(tp,ct1,REASON_EFFECT)
		Duel.Draw(1-tp,ct2,REASON_EFFECT)
	end
end
function c9910285.seqfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x957)
end
function c9910285.seqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c9910285.seqfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9910285.seqfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9910285,0))
	Duel.SelectTarget(tp,c9910285.seqfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c9910285.seqop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	local nseq=math.log(s,2)
	Duel.MoveSequence(tc,nseq)
end
