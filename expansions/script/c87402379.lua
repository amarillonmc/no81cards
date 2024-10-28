--地底王灵 塔尔塔萝斯
function c87402379.initial_effect(c)
	c:EnableReviveLimit()
	--copy
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_QUICK_O) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetRange(LOCATION_HAND+LOCATION_DECK)
	e1:SetCountLimit(1,87402379)
	e1:SetCost(c87402379.cpcost)
	e1:SetTarget(c87402379.cptg)
	e1:SetOperation(c87402379.cpop)
	c:RegisterEffect(e1)
	--remove  
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c87402379.rmcon)
	e2:SetTarget(c87402379.rmtg)
	e2:SetOperation(c87402379.rmop)
	c:RegisterEffect(e2) 
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1) 
	e2:SetTarget(c87402379.rmtg)
	e2:SetOperation(c87402379.rmop)
	c:RegisterEffect(e2) 
	--to deck 
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCondition(c87402379.tdcon)
	e2:SetOperation(c87402379.tdop)
	c:RegisterEffect(e2)
end
function c87402379.cpfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_RITUAL) and c:IsAbleToRemoveAsCost()
		and c:CheckActivateEffect(true,true,false)~=nil
end
function c87402379.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return true end
end
function c87402379.cptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c87402379.cpfilter,tp,LOCATION_DECK,0,1,nil)
	end
	e:SetLabel(0) 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c87402379.cpfilter,tp,LOCATION_DECK,0,1,1,nil)
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(true,true,true)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
end
function c87402379.cpop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if te then
		e:SetLabelObject(te:GetLabelObject())
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
	end 
end
function c87402379.rmcon(e,tp,eg,ep,ev,re,r,rp) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL) 
end   
function c87402379.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_DECK,0,1,nil,POS_FACEDOWN) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c87402379.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rc=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_DECK,0,1,1,nil,POS_FACEDOWN):GetFirst() 
	if rc and Duel.Remove(rc,POS_FACEDOWN,REASON_EFFECT)~=0 then 
		rc:RegisterFlagEffect(87402379,RESET_EVENT+RESETS_STANDARD,0,1) 
	end 
end   
function c87402379.tdfil(c) 
	return c:IsAbleToDeck() and c:GetFlagEffect(87402379)~=0  
end 
function c87402379.tdcon(e,tp,eg,ep,ev,re,r,rp) 
	return rp==1-tp and Duel.IsExistingMatchingCard(c87402379.tdfil,tp,LOCATION_REMOVED,0,1,nil)
end 
function c87402379.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsExistingMatchingCard(c87402379.tdfil,tp,LOCATION_REMOVED,0,1,nil) and Duel.SelectEffectYesNo(tp,c,aux.Stringid(87402379,0)) then 
		local tc=Duel.SelectMatchingCard(tp,c87402379.tdfil,tp,LOCATION_REMOVED,0,1,1,nil):GetFirst()
		Duel.ConfirmCards(1-tp,tc) 
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT) 
		local ctype=0 
		if tc:IsType(TYPE_MONSTER) then ctype=bit.bor(ctype,TYPE_MONSTER) end 
		if tc:IsType(TYPE_SPELL) then ctype=bit.bor(ctype,TYPE_SPELL) end 
		if tc:IsType(TYPE_TRAP) then ctype=bit.bor(ctype,TYPE_TRAP) end 
		if re:IsActiveType(ctype) and Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
			Duel.Remove(re:GetHandler(),POS_FACEUP,REASON_EFFECT) 
		end 
	end 
end 




