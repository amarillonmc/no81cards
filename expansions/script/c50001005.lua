--星空闪耀 七侠传
function c50001005.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e1:SetCountLimit(1,50001005+EFFECT_COUNT_CODE_OATH)  
	e1:SetCost(c50001005.accost) 
	e1:SetTarget(c50001005.actg) 
	e1:SetOperation(c50001005.acop) 
	c:RegisterEffect(e1)  
end
c50001005.SetCard_WK_StarS=true  
function c50001005.accost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsReleasable,tp,LOCATION_HAND,0,1,nil) end 
	local g=Duel.SelectMatchingCard(tp,Card.IsReleasable,tp,LOCATION_HAND,0,1,1,nil) 
	Duel.Release(g,REASON_COST) 
end 
function c50001005.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(function(c) return c:IsFaceup() and c:IsSetCard(0x99a) end,tp,LOCATION_MZONE,0,1,nil) end 
	local g=Duel.SelectTarget(tp,function(c) return c:IsFaceup() and c.c:IsSetCard(0x99a) end,tp,LOCATION_MZONE,0,1,1,nil)  
end 
function c50001005.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then   
		--pos 
		local e1=Effect.CreateEffect(c) 
		e1:SetDescription(aux.Stringid(50001005,1))
		e1:SetCategory(CATEGORY_TODECK)
		e1:SetType(EFFECT_TYPE_QUICK_O) 
		e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)   
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCountLimit(1) 
		e1:SetCondition(function(e) 
		return e:GetHandler():GetFlagEffect(50001005)==0 end)
		e1:SetTarget(c50001005.tdtg)
		e1:SetOperation(c50001005.tdop)
		tc:RegisterEffect(e1) 
	end 
end 
function c50001005.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,LOCATION_MZONE)
end 
function c50001005.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then 
		local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil) 
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
	end
	if c:IsRelateToEffect(e) then
		c:RegisterFlagEffect(50001005,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
	end
end








