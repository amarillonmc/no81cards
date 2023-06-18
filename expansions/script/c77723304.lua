--被流放的灵魂 希区柯克(注：狸子DIY)
function c77723304.initial_effect(c)
	c:SetUniqueOnField(1,0,77723304)
	--disable spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCondition(c77723304.pcon)
	e1:SetTargetRange(1,0)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77723304,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,77723304)
	e2:SetCondition(c77723304.condition)
	e2:SetTarget(c77723304.target)
	e2:SetOperation(c77723304.operation)
	c:RegisterEffect(e2)
end
function c77723304.pcon(e)
	return e:GetHandler():GetSummonLocation()==LOCATION_GRAVE
end
function c77723304.cfilter(c,tp)
	return c:GetSummonPlayer()~=tp
end
function c77723304.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c77723304.cfilter,1,nil,tp)
end
function c77723304.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE,1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c77723304.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) then
		if Duel.SpecialSummon(c,0,tp,1-tp,false,false,POS_FACEUP_DEFENSE)~=0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
			e1:SetValue(LOCATION_DECKBOT)
			c:RegisterEffect(e1)
		end
	end
end
