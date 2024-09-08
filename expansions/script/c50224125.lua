--呆之数码兽 矿石兽
function c50224125.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,50224125)
	e1:SetTarget(c50224125.sptg)
	e1:SetOperation(c50224125.spop)
	c:RegisterEffect(e1)
	aux.EnableUnionAttribute(c,c50224125.filter)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c50224125.thcon)
	e3:SetTarget(c50224125.thtg)
	e3:SetOperation(c50224125.thop)
	c:RegisterEffect(e3)
end
function c50224125.spfilter(c,e,tp)
	return c:IsCode(50224120) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c50224125.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c50224125.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c50224125.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c50224125.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c50224125.filter(c)
	return c:IsCode(50224120)
end
function c50224125.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	local tc=ec:GetBattleTarget()
	if not ec:IsRelateToBattle() then return false end
	e:SetLabelObject(tc)
	return ec and eg:IsContains(ec)
		and tc and tc:IsType(TYPE_MONSTER) and tc:IsReason(REASON_BATTLE) and tc:IsAbleToHand(tp)
		and (tc:IsLocation(LOCATION_GRAVE) or tc:IsFaceup() and tc:IsLocation(LOCATION_EXTRA+LOCATION_REMOVED))
end
function c50224125.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local tc=e:GetLabelObject()
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tc,1,0,0)
end
function c50224125.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsAbleToHand(tp) then
		Duel.SendtoHand(tc,tp,REASON_EFFECT)
	end
end