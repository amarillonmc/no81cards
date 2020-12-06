--优雅的韶光 卡米娜尔
function c9910465.initial_effect(c)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9910465)
	e1:SetTarget(c9910465.target)
	e1:SetOperation(c9910465.operation)
	c:RegisterEffect(e1)
end
function c9910465.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove()
		and Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_DECK,0,1,nil,0x9950) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
end
function c9910465.locfilter(c,mg)
	local res=true
	local sc=mg:GetFirst()
	while sc do
		if c:GetSequence()<=sc:GetSequence() then res=false end
		sc=mg:GetNext()
	end
	return res
end
function c9910465.rmfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c9910465.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.Remove(c,POS_FACEUP,REASON_EFFECT)==0 then return end
	local g1=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_DECK,0,nil,0x9950)
	if g1:GetCount()==0 then return end
	local g2=Duel.GetMatchingGroup(c9910465.locfilter,tp,LOCATION_DECK,0,nil,g1)
	if g2:GetCount()>0 then g1:Merge(g2) end
	Duel.ConfirmCards(tp,g1)
	Duel.ConfirmCards(1-tp,g1)
	local ct=g1:GetCount()//10
	if g1:GetClassCount(Card.GetCode)~=g1:GetCount() or ct<1 then Duel.ShuffleDeck(tp) return end
	local g3=Duel.GetFieldGroup(tp,0,LOCATION_MZONE+LOCATION_GRAVE)
	if g3:GetCount()>0 then g1:Merge(g3) end
	if g1:IsExists(c9910465.rmfilter,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(9910465,0)) then
		local sg=g1:FilterSelect(tp,c9910465.rmfilter,1,ct,nil)
		Duel.HintSelection(sg)
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
		local og=Duel.GetOperatedGroup()
		og:AddCard(c)
		local fid=c:GetFieldID()
		local oc=og:GetFirst()
		while oc do
			oc:RegisterFlagEffect(9910465,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
			oc=og:GetNext()
		end
		og:KeepAlive()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabel(fid)
		e1:SetLabelObject(og)
		e1:SetCountLimit(1)
		e1:SetCondition(c9910465.retcon)
		e1:SetOperation(c9910465.retop)
		Duel.RegisterEffect(e1,tp)
	end
	Duel.ShuffleDeck(tp)
end
function c9910465.retfilter(c,fid)
	return c:GetFlagEffectLabel(9910465)==fid
end
function c9910465.retcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c9910465.retfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c9910465.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9910465.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local sg=g:Filter(c9910465.retfilter,nil,e:GetLabel())
	g:DeleteGroup()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local sg1=sg:Filter(Card.IsAbleToHand,nil)
	local sg2=sg:Filter(c9910465.spfilter,nil,e,tp)
	local b1=sg1:GetCount()==sg:GetCount()
	local b2=sg2:GetCount()==sg:GetCount() and ft>=sg:GetCount()
	if b2 and (not b1 or Duel.SelectOption(tp,1104,1152)==1) then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	elseif b1 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	end
end
