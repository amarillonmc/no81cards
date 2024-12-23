--调皮宝贝 影子娃
function c98920630.initial_effect(c)
	 --hand link
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e0:SetRange(LOCATION_HAND)
	e0:SetCountLimit(1,98920630)
	e0:SetValue(c98920630.matval)
	c:RegisterEffect(e0)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BE_MATERIAL)
	e1:SetCategory(CATEGORY_RECOVER+CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,98930630)
	e1:SetCondition(c98920630.reccon)
	e1:SetTarget(c98920630.rectg)
	e1:SetOperation(c98920630.recop)
	c:RegisterEffect(e1)
end
function c98920630.mfilter(c)
	return c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0x120)
end
function c98920630.exmfilter(c)
	return c:IsLocation(LOCATION_HAND) and c:IsCode(98920630)
end
function c98920630.matval(e,lc,mg,c,tp)
	if not lc:IsSetCard(0x120) then return false,nil end
	return true,not mg or mg:IsExists(c98920630.mfilter,1,nil) and not mg:IsExists(c98920630.exmfilter,1,nil)
end
function c98920630.reccon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	return c:IsLocation(LOCATION_GRAVE) and rc:IsSetCard(0x120) and r&REASON_FUSION+REASON_LINK~=0
end
function c98920630.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c98920630.spfilter(c,e,tp)
	return c:IsSetCard(0x120) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) and not c:IsCode(98920630)
end
function c98920630.recop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c98920630.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,nil,e,tp)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(0,1)
	e1:SetTarget(c98920630.splimit)
	Duel.RegisterEffect(e1,tp)
	if #g>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(98920630,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
function c98920630.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_EXTRA)
end