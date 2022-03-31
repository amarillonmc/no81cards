--苍岚水师的深海修行
function c33200724.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,33200724+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c33200724.sptg)
	e1:SetOperation(c33200724.spop)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33200724,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,33200725)
	e2:SetOperation(c33200724.rmop)
	c:RegisterEffect(e2)
end
function c33200724.filter(c,e,tp)
	return c:IsSetCard(0xc32a) and not c:IsType(TYPE_LINK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c33200724.filter2(c)
	return c:IsFaceup() and c:IsCanAddCounter(0x32a,2)
end
function c33200724.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c33200724.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c33200724.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c33200724.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) and Duel.IsExistingMatchingCard(c33200724.filter2,tp,LOCATION_ONFIELD,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(33200724,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
			local sg=Duel.SelectMatchingCard(tp,c33200724.filter2,tp,LOCATION_ONFIELD,0,1,1,nil)
			if sg:GetCount()>0 then 
				local tc=sg:GetFirst()
				tc:AddCounter(0x32a,2)
			end
		end
	end
end

--e2
function c33200724.indesfilter(e,c)
	return c:IsFaceup() and c:IsSetCard(0xc32a) and c:IsLinkState()
end
function c33200724.rmop(e,tp,eg,ep,ev,re,r,rp)
	--indes
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c33200724.indesfilter)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end