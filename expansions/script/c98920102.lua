--云魔物-烟尘
function c98920102.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c98920102.matfilter,1,1)
	c:EnableReviveLimit()
--reflect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
	e2:SetTarget(c98920102.reftg)
	e2:SetValue(1)
	c:RegisterEffect(e2)
--atk target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(c98920102.effcon)
	e2:SetTarget(c98920102.efftg)
	c:RegisterEffect(e2)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetCondition(c98920102.effcon)
	e2:SetValue(c98920102.atlimit)
	c:RegisterEffect(e2)
--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(98920102,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c98920102.spcon)
	e4:SetTarget(c98920102.sptg)
	e4:SetOperation(c98920102.spop)
	c:RegisterEffect(e4)
end
function c98920102.reftg(e,c)
	return c:IsSetCard(0x18)
end
function c98920102.matfilter(c)
	return c:IsLinkSetCard(0x18) and not c:IsLinkType(TYPE_LINK)
end
function c98920102.tgfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x18)
end
function c98920102.effcon(e)
	return e:GetHandler():GetLinkedGroup():IsExists(c98920102.tgfilter,1,nil)
end
function c98920102.efftg(e,c)
	return c~=e:GetHandler():GetLinkedGroup():IsContains(c)
end
function c98920102.atlimit(e,c)
	return not e:GetHandler():GetLinkedGroup():IsContains(c)
end
function c98920102.filter(c,e,tp,zonr)
	return c:IsSetCard(0x18) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,zone)
end
function c98920102.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsType(TYPE_LINK) and c:GetLinkedGroupCount()==0 and Duel.GetTurnPlayer()==tp
end
function c98920102.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		local zone=e:GetHandler():GetLinkedZone(tp)
		return zone~=0 and Duel.IsExistingMatchingCard(c98920102.filter,tp,LOCATION_DECK,0,1,nil,e,tp,zone) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c98920102.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local zone=e:GetHandler():GetLinkedZone(tp)
	local g = Duel.SelectMatchingCard(tp,c98920102.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp,zone)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,zone)
	end
end