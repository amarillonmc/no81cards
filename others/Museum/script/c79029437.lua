--黑钢国际·近卫干员-芙兰卡·铝热剑
function c79029437.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x1904),aux.NonTuner(Card.IsSynchroType,TYPE_SYNCHRO),1)
	c:EnableReviveLimit()
	--to hand or grave
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,79029437)
	e1:SetCondition(c79029437.thgcon)
	e1:SetTarget(c79029437.thgtg)
	e1:SetOperation(c79029437.thgop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c79029437.actcon)
	e2:SetOperation(c79029437.actop)
	c:RegisterEffect(e2)
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c79029437.atkval)
	c:RegisterEffect(e3)
	--SpecialSummon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCondition(c79029437.spcon1)
	e4:SetTarget(c79029437.sptg)
	e4:SetCost(c79029437.spcost)
	e4:SetCountLimit(1,19029437)
	e4:SetOperation(c79029437.spop)
	c:RegisterEffect(e4)  
	local e5=e4:Clone()
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetHintTiming(0,TIMING_END_PHASE)
	e5:SetCondition(c79029437.spcon2)
	c:RegisterEffect(e5)
end
function c79029437.thgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c79029437.tgfil(c)
	return c:IsAbleToGrave() and c:IsType(TYPE_TRAP) and c:IsSetCard(0x1904) and Duel.IsExistingMatchingCard(c79029437.tgfil2,tp,LOCATION_DECK,0,1,nil,c:GetCode()) 
end
function c79029437.tgfil2(c,code)
	return (c:IsAbleToGrave() or c:IsAbleToHand()) and c:IsCode(code) 
end
function c79029437.thgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029437.tgfil,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_REMOVED,0,1,nil) end
end
function c79029437.thgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c79029437.tgfil,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_REMOVED,0,nil)
	if g:GetCount()<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	Duel.SendtoGrave(tc,REASON_EFFECT)
	local g1=Duel.GetMatchingGroup(c79029437.tgfil2,tp,LOCATION_DECK,0,nil,tc:GetCode())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local tc1=g1:Select(tp,1,1,nil):GetFirst()
	local op=0 
	if tc1:IsAbleToHand() and tc1:IsAbleToGrave() then
	op=Duel.SelectOption(tp,aux.Stringid(79029437,0),aux.Stringid(79029437,1))
	elseif tc:IsAbleToHand() then
	op=Duel.SelectOption(tp,aux.Stringid(79029437,0))
	else
	op=Duel.SelectOption(tp,aux.Stringid(79029437,1))+1
	end
	if op==0 then 
	Debug.Message("好，准备完毕。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029437,2))
	Duel.SendtoHand(tc1,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tc1)
	else 
	Debug.Message("那么，我们出发。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029437,3))
	Duel.SendtoGrave(tc1,REASON_EFFECT)
	end
end
function c79029437.actcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and re:GetOwner():IsSetCard(0x1904)
end
function c79029437.actop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,79029437)
	Duel.SetChainLimit(c79029437.chainlm)
end
function c79029437.chainlm(e,rp,tp)
	return tp==rp
end
function c79029437.ctfil(c)
	return c:IsType(TYPE_TRAP) and c:IsSetCard(0x1904)
end
function c79029437.atkval(e,c)
	local tp=e:GetHandler():GetControler()
	return Duel.GetMatchingGroupCount(c79029437.ctfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)*1000
end
function c79029437.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,79029436)
end
function c79029437.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,79029436)
end
function c79029437.rfilter(c,tp)
	return c:IsType(TYPE_TRAP) and c:IsSetCard(0x1904) and c:IsAbleToGraveAsCost()
end
function c79029437.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c79029437.rfilter,c:GetControler(),LOCATION_ONFIELD+LOCATION_REMOVED+LOCATION_HAND,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c79029437.rfilter,tp,LOCATION_ONFIELD+LOCATION_REMOVED+LOCATION_HAND,0,3,3,nil)
	Duel.SendtoGrave(g,REASON_COST)
	Debug.Message("没时间犹豫了。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029437,4))
end
function c79029437.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c79029437.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end









