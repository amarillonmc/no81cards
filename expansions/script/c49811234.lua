--漆黑之魔王 LV2
function c49811234.initial_effect(c)
	--sset
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,49811234)
	e1:SetTarget(c49811234.sttg)
	e1:SetOperation(c49811234.stop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_HANDES+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_REMOVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,49811334)
	e3:SetCondition(c49811234.drcon)
	e3:SetTarget(c49811234.drtg)
	e3:SetOperation(c49811234.drop)
	c:RegisterEffect(e3)
end
c49811234.lvup={85313220}
function c49811234.stfilter(c,tp)
	return c:IsCode(49811237) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c49811234.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c49811234.stfilter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function c49811234.stop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,c49811234.stfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)~=0
		and Duel.IsPlayerCanDiscardDeck(tp,2) and Duel.SelectYesNo(tp,aux.Stringid(49811234,0)) then
		Duel.BreakEffect()
		local g=Duel.GetDecktopGroup(tp,2)
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c49811234.drfilter(c)
	return c:IsRace(RACE_FIEND) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsFaceup()
end
function c49811234.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c49811234.drfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c49811234.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c49811234.drop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,1,REASON_EFFECT)>0 then
		Duel.BreakEffect()
		Duel.ShuffleHand(tp)
		Duel.DiscardHand(tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD)
	end
end