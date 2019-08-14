--最终的幻想
function c60150511.initial_effect(c)
	c:SetUniqueOnField(1,1,60150511)
	--xyz summon
	aux.AddXyzProcedure(c,c60150511.mfilter,11,3)
	c:EnableReviveLimit()
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetCountLimit(1,60150511)
	e1:SetCondition(c60150511.sumcon)
	e1:SetTarget(c60150511.sumtg)
	e1:SetOperation(c60150511.sumop)
	c:RegisterEffect(e1)
	--actlimit
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetCode(EFFECT_CANNOT_ACTIVATE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTargetRange(0,1)
    e2:SetValue(c60150511.aclimit)
    e2:SetCondition(c60150511.actcon)
    c:RegisterEffect(e2)
	--
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_BATTLED)
	e3:SetCondition(c60150511.actcon2)
    e3:SetOperation(c60150511.disop)
    c:RegisterEffect(e3)
end
function c60150511.mfilter(c)
	return c:IsRace(RACE_FIEND) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c60150511.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c60150511.actcon(e)
    return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end
function c60150511.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c60150511.filter(c,e,tp)
	return c:GetRank()>=10 and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_FIEND) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c60150511.sumtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c60150511.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c60150511.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c60150511.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c60150511.sumop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c60150511.actcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and c:IsStatus(STATUS_OPPO_BATTLE) and bc and bc:IsStatus(STATUS_BATTLE_DESTROYED)
		and e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,60150510)
end
function c60150511.disop(e,tp,eg,ep,ev,re,r,rp)
    local a=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
    if a==0 then return end
    local c=e:GetHandler()
    local bc=c:GetBattleTarget()
	local seq=bc:GetSequence()
	if bc:IsControler(1-tp) then seq=seq+16 end
    Duel.Hint(HINT_CARD,0,60150511)
    Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(60150511,0))
	local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_DISABLE_FIELD)
    e1:SetLabel(seq)
    e1:SetOperation(c60150511.disop2)
    Duel.RegisterEffect(e1,tp)
end
function c60150511.disop2(e,tp)
    return bit.lshift(0x1,e:GetLabel())
end