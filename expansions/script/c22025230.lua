--人理之诗 热砂狮身兽
function c22025230.initial_effect(c)
	aux.AddCodeList(c,22025210)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetTarget(c22025230.target)
	e1:SetOperation(c22025230.activate)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c22025230.atkcon)
	e2:SetValue(4000)
	c:RegisterEffect(e2)
	--Activate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22025230,0))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,22025230)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetTarget(c22025230.thtg)
	e3:SetOperation(c22025230.thop)
	c:RegisterEffect(e3)
end
function c22025230.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:IsCostChecked()
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,22025230,0xff1,TYPES_EFFECT_TRAP_MONSTER,0,4000,4,RACE_BEAST,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c22025230.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,22025230,0xff1,TYPES_EFFECT_TRAP_MONSTER,0,4000,4,RACE_BEAST,ATTRIBUTE_EARTH) then return end
	c:AddMonsterAttribute(TYPE_EFFECT+TYPE_TRAP)
	Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
end
function c22025230.atkfilter(c)
	return c:IsFaceup() and c:IsCode(22025210)
end
function c22025230.atkcon(e)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(c22025230.atkfilter,c:GetControler(),LOCATION_ONFIELD,0,1,nil)
end

function c22025230.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsAbleToHand()  and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c22025230.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc1=Duel.GetFirstTarget()
	if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0
		or not tc1:IsRelateToEffect(e) then return end
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0):RandomSelect(1-tp,1)
	local tc=g:GetFirst()
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_CARDTYPE)
	local op=Duel.AnnounceType(1-tp)
	Duel.ConfirmCards(1-tp,tc)
	Duel.ShuffleHand(tp)
	if (op~=0 and tc:IsType(TYPE_MONSTER)) or (op~=1 and tc:IsType(TYPE_SPELL)) or (op~=2 and tc:IsType(TYPE_TRAP)) then
		Duel.SendtoHand(tc1,nil,REASON_EFFECT)
	end
end
