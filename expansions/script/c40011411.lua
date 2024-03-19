--闪击通信员 图尔
function c40011411.initial_effect(c)
	--copy self continuous spell
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_QUICK_O) 
	e1:SetCode(EVENT_FREE_CHAIN)   
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)  
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,40011411) 
	e1:SetCondition(c40011411.cpcon)
	e1:SetCost(c40011411.cpcost) 
	e1:SetTarget(c40011411.cptg)
	e1:SetOperation(c40011411.cpop)
	c:RegisterEffect(e1) 
	--set
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE) 
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetCountLimit(1,10011411) 
	e2:SetCondition(function(e) 
	return not e:GetHandler():IsPreviousLocation(LOCATION_HAND) end) 
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c40011411.settg)
	e2:SetOperation(c40011411.setop)
	c:RegisterEffect(e2)
end
function c40011411.cpcon(e,tp,eg,ep,ev,re,r,rp)   
	return Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsSetCard(0xf11) end,tp,LOCATION_MZONE,0,1,nil)  
end 
function c40011411.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c40011411.filter(c)
	return c:GetType()&(TYPE_CONTINUOUS+TYPE_SPELL)==TYPE_CONTINUOUS+TYPE_SPELL and c:IsSetCard(0xf11) and c:IsFaceup() and c:CheckActivateEffect(true,true,false)~=nil
end
function c40011411.cptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		local te=e:GetLabelObject()
		local tg=te:GetTarget()
		return chkc:IsSetCard(0xf11) and chkc:GetType()&(TYPE_CONTINUOUS+TYPE_SPELL)==TYPE_CONTINUOUS+TYPE_SPELL and tg and tg(e,tp,eg,ep,ev,re,r,rp,0,chkc)
	end
	if chk==0 then return Duel.IsExistingTarget(c40011411.filter,tp,LOCATION_ONFIELD,0,1,nil) end
	e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c40011411.filter,tp,LOCATION_ONFIELD,0,1,1,nil)
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(true,true,true)
	Duel.ClearTargetCard()
	g:GetFirst():CreateEffectRelation(e)
	local tg=te:GetTarget()
	e:SetProperty(te:GetProperty())
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c40011411.cpop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	local tc=te:GetHandler()
	if tc:IsRelateToEffect(e) and tc:GetType()&(TYPE_CONTINUOUS+TYPE_SPELL)==TYPE_CONTINUOUS+TYPE_SPELL and tc:IsSetCard(0xf11) then 
		e:SetLabelObject(te:GetLabelObject())
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
	end
	Duel.BreakEffect()
	Duel.SendtoGrave(tc,REASON_EFFECT)
end
function c40011411.setfilter(c)
	return c:IsCode(40011407) and c:IsSSetable()
end
function c40011411.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40011411.setfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) end
end
function c40011411.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tc=Duel.SelectMatchingCard(tp,c40011411.setfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil):GetFirst() 
	local x=0 
	if tc:IsLocation(LOCATION_HAND) then x=1 end 
	if tc then
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end 
		if Duel.SSet(tp,tc)~=0 and x==1 then
			Duel.Draw(tp,1,REASON_EFFECT) 
		end 
	end
end


