--热炎环带 恩戈罗恩戈罗
function c33332261.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c33332261.target)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33332261,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,33332261)
	e3:SetCondition(c33332261.thcon)
	e3:SetTarget(c33332261.thtg)
	e3:SetOperation(c33332261.thop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
end
function c33332261.target(e,c)
	return c:IsRace(RACE_FISH) and c:IsAttribute(ATTRIBUTE_FIRE)
end
function c33332261.tfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xa552)
end
function c33332261.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c33332261.tfilter,1,nil,tp)
end
function c33332261.thfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa552) and c:IsAbleToHand() and Duel.GetMZoneCount(tp,c)>0
end
function c33332261.filter(c,e,tp)
	return c:IsRace(RACE_FISH) and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetMZoneCount(tp,c)>0
end
function c33332261.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=eg:Filter(c33332261.thfilter,nil)
	if chk==0 then return Duel.IsExistingMatchingCard(c33332261.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c33332261.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c33332261.thfilter,nil,tp)
	local tg
	if g:GetCount()==1 then
		tg=g:Clone()
		Duel.SetTargetCard(tg)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		tg=Duel.SelectTarget(tp,aux.IsInGroup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,g)
	end
	local tc=tg:GetFirst()
	if tc and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c33332261.filter,tp,LOCATION_DECK,0,1,nil,e,tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c33332261.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		local stc=sg:GetFirst()
		if stc then
			Duel.SpecialSummon(stc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end