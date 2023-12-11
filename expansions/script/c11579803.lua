--空泡碧水弹丸龙
function c11579803.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_DRAGON),2,2)   
	--des dr td 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET) 
	e1:SetCountLimit(1,11579803) 
	e1:SetTarget(c11579803.ddttg) 
	e1:SetOperation(c11579803.ddtop) 
	c:RegisterEffect(e1) 
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e2:SetCondition(c11579803.indcon)
	e2:SetOperation(c11579803.indop)
	c:RegisterEffect(e2)
end
function c11579803.ddttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(function(c) return c:IsFaceup() and c:IsRace(RACE_DRAGON) end,tp,LOCATION_MZONE,0,1,nil) and Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_GRAVE,0,1,nil) end 
	local g=Duel.SelectTarget(tp,function(c) return c:IsFaceup() and c:IsRace(RACE_DRAGON) end,tp,LOCATION_MZONE,0,1,1,nil) 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0) 
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1) 
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
end 
function c11579803.ddtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end  
	Duel.Draw(tp,1,REASON_EFFECT)
	if Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_GRAVE,0,1,nil) then  
		local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_GRAVE,0,1,1,nil) 
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT) 
	end 
end 
function c11579803.indcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_LINK
end
function c11579803.indop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11579803,1))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PIERCE)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)  
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1,true)
end 









