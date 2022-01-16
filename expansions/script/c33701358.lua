--兽质的重生
function c33701358.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--deck check 2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33701358,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c33701358.spcost)
	e2:SetTarget(c33701358.sptg)
	e2:SetOperation(c33701358.spop)
	c:RegisterEffect(e2)
	--self destroy
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EFFECT_SELF_DESTROY)
	e3:SetCondition(c33701358.sdcon)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(33701358,ACTIVITY_SPSUMMON,c33701358.counterfilter)
end
function c33701358.sdcon(e)
	local g=Duel.GetFieldGroup(tp,LOCATION_GRAVE,0)
	if g:GetCount()==0 then return false end
	return not g:GetClassCount(Card.GetCode,nil)==g:GetCount()
end
function c33701358.counterfilter(c)
	return c:IsSetCard(0x442)
end
function c33701358.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(33701358,tp,ACTIVITY_SPSUMMON)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c33701358.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c33701358.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x442)
end
function c33701358.spfilter(c,e,tp)
	return c:IsSetCard(0x442) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33701358.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>2 and Duel.GetMatchingGroupCount(c33701358.spfilter,tp,LOCATION_DECK,0,nil,e,tp)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c33701358.spop(e,tp,eg,ep,ev,re,r,rp)
	if not (e:GetHandler():IsRelateToEffect(e) and Duel.GetFieldGroup(tp,LOCATION_DECK,0)>2) then return end
	local sg=Duel.GetDecktopGroup(tp,3)
	Duel.ConfirmDecktop(tp,3)
	if sg:GetClassCount(Card.GetCode,nil)==3 and sg:IsExists(c33701358.spfilter,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=sg:FilterSelect(tp,c33701358.spfilter,1,1,nil,e,tp):GetFirst()
		Duel.DisableShuffleCheck()
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		sg:RemoveCard(tc)
		sg=sg:Filter(Card.IsLocation,nil,LOCATION_DECK)
		Duel.SortDecktop(tp,tp,sg:GetCount())
		if Duel.SelectYesNo(tp,aux.Stringid(33701358,1)) then
			for i=1,sg:GetCount() do
				local mg=Duel.GetDecktopGroup(tp,1)
				Duel.MoveSequence(mg:GetFirst(),1)
			end
		end
	end
end