local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e2:SetTarget(s.cttg)
	e2:SetOperation(s.ctop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e3:SetTarget(s.sptg2)
	e3:SetOperation(s.spop2)
	c:RegisterEffect(e3)
end
s.counter_add_list={0x100e}
function s.cfilter(c)
	return c:IsFaceup() and aux.IsCounterAdded(c,0x100e)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsCanAddCounter(0x100e,2) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsCanAddCounter,tp,0,LOCATION_MZONE,1,nil,0x100e,2) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsCanAddCounter,tp,0,LOCATION_MZONE,1,1,nil,0x100e,2)
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then tc:AddCounter(0x100e,2) end
end
function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_EXTRA)>2 and Duel.IsPlayerCanSpecialSummon(1-tp) and Duel.GetLocationCountFromEx(1-tp)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,1-tp,LOCATION_EXTRA)
end
function s.spfilter(c,e,tp)
	return Duel.GetLocationCountFromEx(1-tp,1-tp,nil,c)>0 and c:IsCanBeSpecialSummoned(e,0,1-tp,false,false,POS_FACEUP)
end
function s.spop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	if g:GetCount()<3 then return end
	Duel.ShuffleExtra(1-tp)
	local sg=g:RandomSelect(tp,3)
	Duel.ConfirmCards(tp,sg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=sg:FilterSelect(tp,s.spfilter,1,1,nil,e,tp):GetFirst()
	if not tc then return end
	if Duel.SpecialSummonStep(tc,0,1-tp,1-tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetCondition(s.con)
		e1:SetOwnerPlayer(tp)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2,true)
	end
	Duel.SpecialSummonComplete()
end
function s.con(e)
	return e:GetHandler():IsControler(1-e:GetOwnerPlayer())
end
