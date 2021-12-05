--夜月的魔术师
function c72411470.initial_effect(c)
	aux.AddCodeList(c,72411270)
		--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,72411470)
	e1:SetCondition(c72411470.spcon)
	c:RegisterEffect(e1)
	--level
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(72411470,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,72411471)
	e2:SetTarget(c72411470.lvtg)
	e2:SetOperation(c72411470.lvop)
	c:RegisterEffect(e2)
end
function c72411470.spfilter(c)
	return c:IsFaceup() and c:IsCode(72411270)
end
function c72411470.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c72411470.spfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c72411470.lvfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER) and c:IsLevelAbove(1)
end
function c72411470.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c72411470.lvfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c72411470.spfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_ONFIELD)
end
function c72411470.lvop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c72411330.filter,tp,LOCATION_ONFIELD,0,1,1,nil)
	if Duel.Destroy(g,REASON_EFFECT)~=0 then
		local g=Duel.GetMatchingGroup(c72411470.lvfilter,tp,LOCATION_MZONE,0,nil)
		local tc=g:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_LEVEL)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(2)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			tc=g:GetNext()
		end
	end
end