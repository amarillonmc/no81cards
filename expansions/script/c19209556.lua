--心象风景 倒转
function c19209556.initial_effect(c)
	aux.AddCodeList(c,19209522)
	--act in set turn
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
	e0:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,19209556)
	e1:SetTarget(c19209556.target)
	e1:SetOperation(c19209556.activate)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(19209556,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c19209556.spcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c19209556.sptg)
	e2:SetOperation(c19209556.spop)
	c:RegisterEffect(e2)
end
function c19209556.rmfilter(c)
	return c:IsCode(19209522) and c:IsAbleToRemove() and c:IsFaceupEx()
end
function c19209556.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c19209556.rmfilter,tp,LOCATION_ONFIELD+LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_ONFIELD+LOCATION_DECK)
end
function c19209556.rfilter(c)
	return not c:IsCode(19209522) and c:IsSetCard(0xb50) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c19209556.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=Duel.SelectMatchingCard(tp,c19209556.rmfilter,tp,LOCATION_ONFIELD+LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc==nil or Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)==0 or not tc:IsLocation(0x20) then return end
	if Duel.IsExistingMatchingCard(c19209556.rfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(19209556,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c19209556.rfilter,tp,LOCATION_DECK,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function c19209556.chkfilter(c,tp)
	return c:GetPreviousCodeOnField()==19209522 and c:IsPreviousControler(tp)
		and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP)
		and c:GetReasonPlayer()==1-tp and not c:IsReason(REASON_RULE)
end
function c19209556.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c19209556.chkfilter,1,nil,tp)
end
function c19209556.spfilter(c,e,tp)
	return c:IsCode(19209522) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsFaceupEx()
end
function c19209556.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and Duel.IsExistingMatchingCard(c19209556.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA+LOCATION_REMOVED,0,1,nil,e,tp) and g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA+LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c19209556.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,c19209556.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA+LOCATION_REMOVED,0,1,1,nil,e,tp):GetFirst()
	if sc and Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tc=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil):GetFirst()
		if tc then
			Duel.BreakEffect()
			Duel.HintSelection(Group.FromCards(tc))
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		end
	end
end
