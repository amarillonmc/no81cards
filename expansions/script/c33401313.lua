--五河士道 刻刻帝
function c33401313.initial_effect(c)
	 c:EnableReviveLimit()
	 c:EnableCounterPermit(0x34f)
--fusion material
	 aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xc342),c33401313.fa,true)
--set counter
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33401313,0))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetTarget(c33401313.addct)
	e2:SetOperation(c33401313.addc)
	c:RegisterEffect(e2)
 --copy
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetDescription(aux.Stringid(33401313,1))
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1,33401313)
	e6:SetTarget(c33401313.cptg)
	e6:SetOperation(c33401313.cpop)
	c:RegisterEffect(e6)
 --to hand from grave
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(33401313,2))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCountLimit(1,33401313+10000)
	e4:SetTarget(c33401313.adtg)
	e4:SetOperation(c33401313.adop)
	c:RegisterEffect(e4)
end
function c33401313.fa(c)
	return c:IsFusionAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_FAIRY)
end
function c33401313.filter(c)
	return c:IsFaceup() and c:IsCanAddCounter(0x34f,6)
end
function c33401313.addct(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c33401313.filter(chkc) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c33401313.filter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,6,0,0x34f)
end
function c33401313.addc(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		tc:AddCounter(0x34f,6)
	end
end

function c33401313.cpfilter(c)
	return c:IsType(TYPE_EFFECT) and c:IsSetCard(0x341) and c:IsRace(RACE_FAIRY)
end
function c33401313.cptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c33401313.cpfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c33401313.cpfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g1=Duel.SelectTarget(tp,c33401313.cpfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,e:GetHandler())
end
function c33401313.cpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsOnField() or c:IsFacedown() then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local code=tc:GetOriginalCode()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetCode(EFFECT_ADD_CODE)
		e1:SetValue(code)
		c:RegisterEffect(e1)
		c:CopyEffect(code,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,1)
		c:RegisterFlagEffect(33401301,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	end
end

function c33401313.thfilter3(c)
	return c:IsSetCard(0x3340) or c:IsSetCard(0x3341) and c:IsAbleToHand()  
end
function c33401313.adtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33401313.thfilter3,tp,LOCATION_GRAVE,0,1,nil)	
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c33401313.adop(e,tp,eg,ep,ev,re,r,rp)   
	local g1=Duel.GetMatchingGroup(c33401313.thfilter3,tp,LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c33401313.thfilter3,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end   
end