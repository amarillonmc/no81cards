--虹彩偶像 樱坂雫
function c9910376.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9910376)
	e1:SetCondition(c9910376.spcon)
	e1:SetTarget(c9910376.sptg)
	e1:SetOperation(c9910376.spop)
	c:RegisterEffect(e1)
	--remove & set
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9910377)
	e2:SetCondition(c9910376.setcon)
	e2:SetTarget(c9910376.settg)
	e2:SetOperation(c9910376.setop)
	c:RegisterEffect(e2)
end
function c9910376.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_FZONE,LOCATION_FZONE,1,nil)
end
function c9910376.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9910376.spfilter(c,e,tp)
	return c:IsSetCard(0x5951) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9910376.fselect(g,tp,c)
	local res=true
	if Duel.GetLocationCount(tp,LOCATION_MZONE)==1 or Duel.IsPlayerAffectedByEffect(tp,59822133) then
		res=g:GetCount()<=1
	end
	return res and g:IsContains(c)
end
function c9910376.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c9910376.spfilter,tp,LOCATION_HAND,0,nil,e,tp)
	if g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,c9910376.fselect,false,1,2,tp,e:GetHandler())
	if sg:GetCount()>0 then Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) end
end
function c9910376.setcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and re:GetHandler():IsRelateToEffect(re) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c9910376.spellfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL) and c:IsAbleToDeck()
end
function c9910376.setfilter(c,e,tp)
	return c:IsSetCard(0x5951) and c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsType(TYPE_FIELD) and c:IsSSetable()
end
function c9910376.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and c9910376.spellfilter(chkc) end
	if chk==0 then return re:GetHandler():IsAbleToRemove()
		and Duel.IsExistingTarget(c9910376.spellfilter,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingMatchingCard(c9910376.setfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9910376,0))
	local g=Duel.SelectTarget(tp,c9910376.spellfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	g:AddCard(e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
end
function c9910376.setop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if not rc:IsRelateToEffect(re) or Duel.Remove(rc,POS_FACEUP,REASON_EFFECT)==0
		or not rc:IsLocation(LOCATION_REMOVED) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g2=Duel.SelectMatchingCard(tp,c9910376.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc2=g2:GetFirst()
	if not tc2 or Duel.SSet(tp,tc2)==0 then return end
	local g=Group.CreateGroup()
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) then g:AddCard(c) end
	if tc:IsRelateToEffect(e) then g:AddCard(tc) end
	if g:GetCount()>0 then
		Duel.BreakEffect()
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
