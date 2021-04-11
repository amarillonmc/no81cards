--帝王的谋略
function c19198102.initial_effect(c)
   local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,19198102+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c19198102.activate)
	c:RegisterEffect(e1) 
 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(19198102,2))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,19198103)
	e2:SetTarget(c19198102.thtg)
	e2:SetOperation(c19198102.thop)
	c:RegisterEffect(e2) 
 --act limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c19198102.limcon)
	e3:SetOperation(c19198102.limop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_CHAIN_END)
	e4:SetOperation(c19198102.limop2)
	c:RegisterEffect(e4)	
end
function c19198102.filter(c)
	return (c:GetAttack()==2400 or c:GetAttack()==2800 or c:GetAttack()==800) and c:GetDefense()==1000 and c:IsAbleToHand()
end
function c19198102.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c19198102.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(19198102,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c19198102.thfilter(c)
	return c:IsSetCard(0xbe) and c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsCode(19198102) and c:IsAbleToHand()
end
function c19198102.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c19198102.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c19198102.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c19198102.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c19198102.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
--act limit
function c19198102.limfilter(c,tp)
	return c:GetSummonPlayer()==tp
end
function c19198102.limcon(e,tp,eg,ep,ev,re,r,rp)
	return  eg:IsExists(c19198102.limfilter,1,nil,tp) and eg:GetFirst():IsSummonType(SUMMON_TYPE_ADVANCE)
end
function c19198102.limop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentChain()==0 then
		Duel.SetChainLimitTillChainEnd(c19198102.chainlm)
	elseif Duel.GetCurrentChain()==1 then
		e:GetHandler():RegisterFlagEffect(19198102,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	end
end
function c19198102.limop2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetOverlayCount()>0 and e:GetHandler():GetFlagEffect(19198102)~=0 then
		Duel.SetChainLimitTillChainEnd(c19198102.chainlm)
	end
	e:GetHandler():ResetFlagEffect(19198102)
end
function c19198102.chainlm(e,rp,tp)
	return tp==rp
end