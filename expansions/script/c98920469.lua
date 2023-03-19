--电气兽
function c98920469.initial_effect(c)
	c:SetUniqueOnField(1,0,98920469)
	--link summon
	aux.AddLinkProcedure(c,c98920469.matfilter,2,2)
	c:EnableReviveLimit()
--direct attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xe))
	c:RegisterEffect(e2)
--attack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920469,0))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c98920469.atkcon)
	e2:SetTarget(c98920469.atktg)
	e2:SetOperation(c98920469.atkop)
	c:RegisterEffect(e2)
end
function c98920469.matfilter(c)
	return c:IsLinkRace(RACE_THUNDER) and not c:IsLinkCode(98920469)
end
function c98920469.cfilter(c)
	local bc=c:GetBattleTarget()
	return c:IsRace(RACE_THUNDER) or (bc and bc:IsRace(RACE_THUNDER))
end
function c98920469.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c98920469.cfilter,1,nil)
end
function c98920469.filter(c,e,tp)
	return c:IsSetCard(0xe) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98920469.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c98920469.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c98920469.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c98920469.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c98920469.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end