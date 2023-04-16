--星际仙踪-对峙
function c19198201.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCountLimit(1,19198201)
	e1:SetCost(c19198201.accost)
	e1:SetTarget(c19198201.actg) 
	e1:SetOperation(c19198201.acop) 
	c:RegisterEffect(e1) 
	--des and set 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION) 
	e2:SetRange(LOCATION_GRAVE) 
	e2:SetCountLimit(1,29198201)
	e2:SetTarget(c19198201.desttg) 
	e2:SetOperation(c19198201.destop) 
	c:RegisterEffect(e2) 
end
function c19198201.accost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.CheckLPCost(tp,500) end 
	Duel.PayLPCost(tp,500) 
end 
function c19198201.thfil(c) 
	return c:IsSetCard(0xd2) and c:IsAbleToHand()
end 
function c19198201.actg(e,tp,eg,ep,ev,re,r,rp,chk)  
	local b1=Duel.IsExistingMatchingCard(c19198201.thfil,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c19198201.thfil,tp,LOCATION_REMOVED,0,2,nil)
	if chk==0 then return b1 or b2 end 
end 
function c19198201.acop(e,tp,eg,ep,ev,re,r,rp)   
	local c=e:GetHandler() 
	local b1=Duel.IsExistingMatchingCard(c19198201.thfil,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c19198201.thfil,tp,LOCATION_REMOVED,0,2,nil) 
	local op=2
	if b1 and b2 then 
		op=Duel.SelectOption(tp,aux.Stringid(19198201,1),aux.Stringid(19198201,2))
	elseif b1 then 
		op=Duel.SelectOption(tp,aux.Stringid(19198201,1))
	elseif b2 then 
		op=Duel.SelectOption(tp,aux.Stringid(19198201,2))
	end 
	if op==0 then 
		local sg=Duel.SelectMatchingCard(tp,c19198201.thfil,tp,LOCATION_DECK,0,1,1,nil) 
		Duel.SendtoHand(sg,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg) 
	elseif op==1 then 
		local sg=Duel.SelectMatchingCard(tp,c19198201.thfil,tp,LOCATION_REMOVED,0,2,2,nil) 
		Duel.SendtoHand(sg,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg) 
		if Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,nil) then 
			Duel.BreakEffect() 
			local dg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil) 
			Duel.SendtoDeck(dg,nil,2,REASON_EFFECT) 
		end 
	end 
end 
function c19198201.desfil(c,e,tp)
	local b1=Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	local b2=c:IsLocation(LOCATION_SZONE) and c:GetSequence()<5  
	return c:IsSetCard(0xd2) and (b1 or b2)   
end 
function c19198201.desttg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c19198201.desfil,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil,e,tp) and e:GetHandler():IsSSetable(true) end 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)
end 
function c19198201.destop(e,tp,eg,ep,ev,re,r,rp)   
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c19198201.desfil,tp,LOCATION_HAND+LOCATION_ONFIELD,nil,e,tp) 
	if g:GetCount()>0 then 
		local dg=g:Select(tp,1,1,nil) 
		if Duel.Destroy(dg,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) and Duel.SSet(tp,c)~=0 then 
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
			e1:SetValue(LOCATION_REMOVED)
			c:RegisterEffect(e1)
		end   
	end  
end 











