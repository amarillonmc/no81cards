--绝音魔女的终合奏列 
function c71200891.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetCountLimit(1,71200891)
	e1:SetTarget(c71200891.target)
	e1:SetOperation(c71200891.activate)
	c:RegisterEffect(e1) 
	--to deck 
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetRange(LOCATION_GRAVE) 
	e2:SetCountLimit(1,71200892)
	e2:SetCondition(c71200891.rtdcon) 
	e2:SetTarget(c71200891.rtdtg)
	e2:SetOperation(c71200891.rtdop)
	c:RegisterEffect(e2)
end 
function c71200891.ctfil(c,e,tp) 
	local g=Group.FromCards(c,e:GetHandler())
	return c:IsSetCard(0x895) and c:IsAbleToGraveAsCost() and Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,g)
end
function c71200891.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71200891.ctfil,tp,LOCATION_MZONE,0,1,nil,e,tp) end 
	local tc=Duel.SelectMatchingCard(tp,c71200891.ctfil,tp,LOCATION_MZONE,0,1,1,nil,e,tp):GetFirst() 
	Duel.SendtoGrave(tc,REASON_COST) 
	local dg=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,dg:GetCount(),0,0)
end
function c71200891.activate(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then 
		Duel.Destroy(tc,REASON_EFFECT) 
	end
end
function c71200891.rckfil(c) 
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0x895)   
end 
function c71200891.rtdcon(e,tp,eg,ep,ev,re,r,rp) 
	return Duel.IsExistingMatchingCard(c71200891.rckfil,tp,LOCATION_MZONE,0,1,nil)  
end 
function c71200891.rtdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() and Duel.IsPlayerCanDraw(tp,1) end  
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0) 
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c71200891.rtdop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if Duel.Draw(tp,1,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) then 
		Duel.BreakEffect() 
		Duel.SendtoDeck(c,nil,2,REASON_EFFECT) 
	end 
end


