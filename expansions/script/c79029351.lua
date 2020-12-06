--维多利亚·先锋干员-苇草·生灵火花
function c79029351.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	c:EnableReviveLimit()
	--code
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_CHANGE_CODE)
	e2:SetRange(LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND)
	e2:SetValue(79029014)
	c:RegisterEffect(e2) 
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79029351,1))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,79029351)   
	e1:SetCost(c79029351.thcost)
	e1:SetTarget(c79029351.thtg)
	e1:SetOperation(c79029351.thop)
	c:RegisterEffect(e1)
	--sp suc
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(79029351,2))
	e3:SetCategory(CATEGORY_RECOVER+CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,09029014)
	e3:SetCost(c79029351.spcost)
	e3:SetTarget(c79029351.sptg)
	e3:SetOperation(c79029351.spop)
	c:RegisterEffect(e3)
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_EXTRA)
	e4:SetCountLimit(1,19029351)
	e4:SetCost(c79029351.thcost1)
	e4:SetOperation(c79029351.thop1)
	c:RegisterEffect(e4)
	--Disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,29029351)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCost(c79029351.poscost)
	e2:SetTarget(c79029351.postg)
	e2:SetOperation(c79029351.posop)
	c:RegisterEffect(e2)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetTarget(c79029351.distg)
	c:RegisterEffect(e2)
end
function c79029351.atkfil(c)
	return c:IsType(TYPE_RITUAL)
end
function c79029351.distg(e,c)
	local tp=e:GetHandler():GetControler()
	local atk=Duel.GetMatchingGroup(c79029351.atkfil,tp,LOCATION_MZONE,0,nil):GetSum(Card.GetAttack)
	return c:IsAttackBelow(atk)
end
function c79029351.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
	Duel.ConfirmCards(1-tp,e:GetHandler())
end
function c79029351.thfil(c)
	return c:IsAbleToHand() and c:IsSetCard(0xb90d) and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_SPELL)
end
function c79029351.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029351.thfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c79029351.thfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,0)
end
function c79029351.thop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("不会有其他人看到我在这吧......？")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029351,4))
	local tc=Duel.GetFirstTarget()
	if Duel.SendtoHand(tc,tp,REASON_EFFECT)~=0 and Duel.ConfirmCards(tp,tc)~=0 then
	Duel.BreakEffect()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,79029352,0,0x4011,0,0,10,RACE_CYBERSE,ATTRIBUTE_FIRE) and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,2,nil) and Duel.SelectYesNo(tp,aux.Stringid(79029351,0)) then
	Duel.DiscardHand(tp,Card.IsDiscardable,2,2,REASON_EFFECT,nil)
	local token=Duel.CreateToken(tp,79029352)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	Debug.Message("姐姐......")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029351,5))
	end
	end
end
function c79029351.desfilter(c)
	return not c:IsLocation(LOCATION_SZONE) or c:GetSequence()<5
end
function c79029351.seqfilter(c,seq)
	local loc=LOCATION_MZONE
	if seq>8 then
		loc=LOCATION_SZONE
		seq=seq-8
	end
	if seq>=5 and seq<=7 then return false end
	local cseq=c:GetSequence()
	local cloc=c:GetLocation()
	if cloc==LOCATION_SZONE and cseq>=5 then return false end
	if cloc==LOCATION_MZONE and cseq>=5 and loc==LOCATION_MZONE
		and (seq==1 and cseq==5 or seq==3 and cseq==6) then return true end
	return cseq==seq or cloc==loc and math.abs(cseq-seq)==1
end
function c79029351.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
	Duel.PayLPCost(tp,Duel.GetLP(tp)/2)
end
function c79029351.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029351.desfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	local filter=0
	for i=0,16 do
		if not Duel.IsExistingMatchingCard(c79029351.seqfilter,tp,0,LOCATION_ONFIELD,1,nil,i) then
			filter=filter|1<<(i+16)
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local flag=Duel.SelectField(tp,1,0,LOCATION_ONFIELD,filter)
	local seq=math.log(flag>>16,2)
	e:SetLabel(seq)
	local g=Duel.GetMatchingGroup(c79029351.seqfilter,tp,0,LOCATION_ONFIELD,nil,seq)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,nil)
end
function c79029351.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local seq=e:GetLabel()
	local ct=Duel.GetMatchingGroupCount(c79029351.seqfilter,tp,0,LOCATION_ONFIELD,nil,seq)
	local lg=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_ONFIELD,0,nil,0xa900)
	local xct=lg:GetClassCount(Card.GetCode)
	if ct<=0 or xct<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c79029351.seqfilter,tp,0,LOCATION_ONFIELD,1,xct,nil,seq)
	Debug.Message("只会剩下灰烬......")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029351,3))
	Duel.HintSelection(g)
	if Duel.SendtoGrave(g,REASON_EFFECT) then
	Duel.Recover(tp,g:GetCount()*1000,REASON_EFFECT)
	end
end
function c79029351.xccfil(c)
	return c:IsAbleToHandAsCost() and c:IsSetCard(0xa900)
end
function c79029351.thcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029351.xccfil,tp,LOCATION_PZONE,0,1,nil) and e:GetHandler():IsAbleToHand() end
	local g=Duel.SelectMatchingCard(tp,c79029351.xccfil,tp,LOCATION_PZONE,0,1,1,nil)
	Duel.SendtoHand(g,nil,REASON_COST)
end
function c79029351.thop1(e,tp,eg,ep,ev,re,r,rp) 
	Debug.Message("就这样，我们去收割......")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029351,6))   
	Duel.SendtoHand(e:GetHandler(),tp,REASON_EFFECT)
end
function c79029351.sefil(c)
	return c:IsSetCard(0xa900) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_RITUAL) and not c:IsPublic()
end
function c79029351.poscost(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029351.sefil,tp,LOCATION_HAND,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c79029351.sefil,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
end
function c79029351.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,g,g:GetCount(),0,0)
end
function c79029351.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	tc:RegisterEffect(e2)
	Debug.Message("我......就是深池！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029351,5))   
	end
end







