--大日超构成
function c5060646.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c5060646.target)
	e1:SetOperation(c5060646.activate)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c5060646.sptg)
	e2:SetOperation(c5060646.spop)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_SZONE,0)
	e3:SetTarget(c5060646.eftg)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
end
function c5060646.eftg(e,c)
	return c:GetOriginalType()==(TYPE_SPELL+TYPE_EQUIP) and c:IsSetCard(0x30) and c:IsFaceup()
end
function c5060646.filter(c)
	return c:IsSetCard(0x30) and c:IsAbleToHand() and not c:IsCode(5060646)
end
function c5060646.tefilter(c)
	return c:IsSetCard(0x30) and c:IsAbleToDeck()
end
function c5060646.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c5060646.filter,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(c5060646.tefilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
end
function c5060646.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c5060646.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,g)
		Duel.BreakEffect()
		local g=Duel.GetMatchingGroup(c5060646.tefilter,tp,LOCATION_GRAVE,0,nil)
		if g:GetCount()>0 then
			Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		end
	end
end
function c5060646.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetOriginalCode(),0x30,0x1011,500,500,3,RACE_MACHINE,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c5060646.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetOriginalCode(),0x30,0x1011,500,500,3,RACE_MACHINE,ATTRIBUTE_LIGHT) then
		if c:GetOriginalType()
		c:AddMonsterAttribute(TYPE_NORMAL+TYPE_TUNER,ATTRIBUTE_LIGHT,RACE_MACHINE,3,500,500)
		Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP_ATTACK)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE_FIELD)
		e1:SetLabel(c:GetSequence())
		e1:SetCondition(c5060646.discon)
		e1:SetOperation(c5060646.disop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c5060646.discon(e,tp)
	local fc=Duel.GetFieldCard(e:GetOwnerPlayer(),LOCATION_MZONE,e:GetLabel())
	return not fc
end
function c5060646.disop(e,tp)
	return bit.lshift(0x1,e:GetLabel())
end
