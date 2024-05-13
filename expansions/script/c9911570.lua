--紫炎蔷薇一决胜负
function c9911570.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_TOHAND+CATEGORY_TOEXTRA+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,9911570)
	e1:SetCondition(c9911570.condition)
	e1:SetTarget(c9911570.target)
	e1:SetOperation(c9911570.operation)
	c:RegisterEffect(e1)
	--salvage
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,9911571)
	e2:SetTarget(c9911570.thtg)
	e2:SetOperation(c9911570.thop)
	c:RegisterEffect(e2)
end
function c9911570.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and Duel.IsChainNegatable(ev)
end
function c9911570.unlockedzone(tp,mg)
	local zone=0
	for i=0,4 do
		if Duel.GetMZoneCount(1-tp,mg,tp,LOCATION_REASON_TOFIELD,1<<(4-i))>0 then
			zone=zone|(1<<i)
		end
	end
	return zone
end
function c9911570.thfilter(c,e,tp,zone)
	return c:IsAbleToHand() and Duel.GetMZoneCount(tp,c,tp,LOCATION_REASON_TOFIELD,zone)>0
		and Duel.IsExistingMatchingCard(c9911570.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
end
function c9911570.spfilter(c,e,tp)
	return c:IsSetCard(0x6952) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9911570.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local mg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	local zone=c9911570.unlockedzone(tp,mg)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and c9911570.thfilter(chkc,e,tp,zone) and chkc~=e:GetHandler() end
	if chk==0 then return zone>0 and Duel.IsExistingTarget(c9911570.thfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler(),e,tp,zone)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,9911570,0x6952,TYPES_NORMAL_TRAP_MONSTER,1500,1500,5,RACE_FIEND,ATTRIBUTE_DARK,POS_FACEUP,1-tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c9911570.thfilter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler(),e,tp,zone)
	local tc=g:GetFirst()
	if tc:IsAbleToExtra() then
		Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,g,1,0,0)
	else
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9911570.operation(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.NegateActivation(ev) then return end
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or Duel.SendtoHand(tc,nil,REASON_EFFECT)==0
		or not tc:IsLocation(LOCATION_HAND+LOCATION_EXTRA) then return end
	local mg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	local zone=c9911570.unlockedzone(tp,mg)
	if zone==0 or Duel.GetMZoneCount(tp,nil,tp,LOCATION_REASON_TOFIELD,zone)==0
		or Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9911570.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if #g==0 then return end
	Duel.BreakEffect()
	Duel.SpecialSummonStep(g:GetFirst(),0,tp,tp,false,false,POS_FACEUP,zone)
	local seq=g:GetFirst():GetSequence()
	local dc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,4-seq)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,9911570,0x6952,TYPES_NORMAL_TRAP_MONSTER,1500,1500,5,RACE_FIEND,ATTRIBUTE_DARK,POS_FACEUP,1-tp) then
		if dc then Duel.Destroy(dc,REASON_RULE) end
		c:AddMonsterAttribute(TYPE_NORMAL)
		Duel.SpecialSummonStep(c,0,tp,1-tp,true,false,POS_FACEUP,1<<(4-seq))
	end
	Duel.SpecialSummonComplete()
end
function c9911570.thcfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x6952)
end
function c9911570.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand()
		and Duel.IsExistingMatchingCard(c9911570.thcfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c9911570.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
