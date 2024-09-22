--神官战士 埃尔纳
function c67201118.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67201118,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c67201118.spcon)
	e1:SetTarget(c67201118.sptg)
	e1:SetOperation(c67201118.spop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67201118,1))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetTarget(c67201118.optg)
	e2:SetOperation(c67201118.opop)
	c:RegisterEffect(e2) 
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)   
end
function c67201118.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DRAW)
end
function c67201118.spfilter(c,e,tp)
	return c:IsSetCard(0x3670) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c67201118.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>=2 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
		and Duel.IsExistingMatchingCard(c67201118.spfilter,tp,LOCATION_DECK,0,1,c,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,2,tp,LOCATION_DECK)
end
function c67201118.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:IsCanBeSpecialSummoned(e,0,tp,false,false) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 or Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c67201118.spfilter,tp,LOCATION_DECK,0,1,1,c,e,tp)
	if g:GetCount()>0 then
		g:AddCard(c)
		if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
			g:RemoveCard(c)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e1:SetTargetRange(1,0)
			e1:SetLabel(g:GetFirst():GetOriginalAttribute())
			e1:SetTarget(c67201118.splimit)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function c67201118.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return se and se:GetHandler():IsCode(67201118) and c:GetOriginalAttribute()==e:GetLabel() and not c:IsCode(67201118)
end
--
function c67201118.spfilter(c,e,tp)
	return c:IsSetCard(0x3670) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c67201118.optg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.IsPlayerCanDraw(tp,1)
		and Duel.GetFlagEffect(tp,67201118)==0
	local b2=Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil)
		and Duel.GetFlagEffect(tp,67201119)==0
	if chk==0 then return b1 or b2 end
end
function c67201118.opop(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.IsPlayerCanDraw(tp,1)
		and Duel.GetFlagEffect(tp,67201118)==0
	local b2=Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil)
		and Duel.GetFlagEffect(tp,67201119)==0
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(67201118,1),aux.Stringid(67201118,2))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(67201118,1))
	elseif b2 then op=Duel.SelectOption(tp,aux.Stringid(67201118,2))+1
	else return end
	if op==0 then
		Duel.Draw(tp,1,REASON_EFFECT)
		Duel.RegisterFlagEffect(tp,67201118,RESET_PHASE+PHASE_END,0,1)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local gg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
		if gg:GetCount()>0 then
			Duel.HintSelection(gg)
			Duel.Destroy(gg,REASON_EFFECT)
		end
		Duel.RegisterFlagEffect(tp,67201119,RESET_PHASE+PHASE_END,0,1)
	end
end

