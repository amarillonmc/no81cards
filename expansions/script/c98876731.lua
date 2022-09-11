--寻芳精之休憩
function c98876731.initial_effect(c) 
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING) 
	e2:SetRange(LOCATION_SZONE) 
	e2:SetCondition(c98876731.actcon)
	e2:SetOperation(c98876731.actop) 
	c:RegisterEffect(e2) 
	--copy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98876731,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)   
	e3:SetCode(EVENT_FREE_CHAIN) 
	e3:SetHintTiming(TIMINGS_CHECK_MONSTER)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,98876731)
	e3:SetCost(c98876731.cpcost)
	e3:SetTarget(c98876731.cptg)
	e3:SetOperation(c98876731.cpop)
	c:RegisterEffect(e3) 
	--negate attack
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(98876731,1))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE) 
	e4:SetCountLimit(1,18876731)
	e4:SetCondition(c98876731.nacon) 
	e4:SetOperation(c98876731.naop)
	c:RegisterEffect(e4)
end 
function c98876731.actcon(e,tp,eg,ep,ev,re,r,rp) 
	return ep==tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsCode(95286165,32441317) 
end 
function c98876731.actop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	Duel.Hint(HINT_CARD,0,98876731) 
	Duel.SetChainLimit(c98876731.chainlm)  
end
function c98876731.chainlm(e,rp,tp)
	return tp==rp
end 
function c98876731.cpfilter(c)
	return c:IsCode(32441317) and c:IsAbleToGraveAsCost()
		and c:CheckActivateEffect(true,true,false)~=nil
end
function c98876731.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return true end
end
function c98876731.cptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c98876731.cpfilter,tp,LOCATION_HAND,0,1,nil)
	end
	e:SetLabel(0) 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c98876731.cpfilter,tp,LOCATION_HAND,0,1,1,nil)
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(false,true,true)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
	Duel.SetChainLimit(c98876731.chlimit)
end
function c98876731.chlimit(e,ep,tp)
	return tp==ep
end
function c98876731.cpop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if te then
		e:SetLabelObject(te:GetLabelObject())
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
	end 
end
function c98876731.nacon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():GetControler()~=tp 
end 
function c98876731.nthfil(c) 
	return c:IsSetCard(0x988) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()  
end 
function c98876731.naop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c98876731.nthfil,tp,LOCATION_DECK,0,nil) 
	Duel.NegateAttack() 
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(98876731,2)) then 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND) 
	local sg=g:Select(tp,1,1,nil) 
	Duel.SendtoHand(sg,tp,REASON_EFFECT) 
	Duel.ConfirmCards(1-tp,sg) 
	end 
end








