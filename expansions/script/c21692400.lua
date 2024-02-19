--灵光星极审判
function c21692400.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCountLimit(1,21692400)
	e1:SetCost(c21692400.accost)
	e1:SetTarget(c21692400.actg) 
	e1:SetOperation(c21692400.acop)
	c:RegisterEffect(e1)  
	--set
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,21692400)
	e2:SetCost(c21692400.setcost)
	e2:SetTarget(c21692400.settg)
	e2:SetOperation(c21692400.setop)
	c:RegisterEffect(e2)
end
c21692400.SetCard_ZW_ShLight=true 
function c21692400.ctfil(c)
	return c:IsAbleToHandAsCost() and c:IsFaceup() and c:IsSetCard(0x555) 
end 
function c21692400.accost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21692400.ctfil,tp,LOCATION_MZONE,0,3,nil) end 
	local g=Duel.SelectMatchingCard(tp,c21692400.ctfil,tp,LOCATION_MZONE,0,3,3,nil)
	Duel.SendtoHand(g,nil,REASON_COST) 
end 
function c21692400.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,nil)
	if chk==0 then return g:GetCount()>0 end 
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0) 
end 
function c21692400.acop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,nil)
	if Duel.SendtoGrave(g,REASON_EFFECT)~=0 then 
		local sg=Duel.GetOperatedGroup() 
		local tc=sg:GetFirst() 
		while tc do 
		--forbidden
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EFFECT_FORBIDDEN) 
		e1:SetTargetRange(0xff,0xff)
		e1:SetLabelObject(tc)
		e1:SetTarget(c21692400.bantg) 
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		tc=sg:GetNext() 
		end 
	end  
end 
function c21692400.bantg(e,c) 
	local tc=e:GetLabelObject()
	if not tc then return false end 
	local fcode=tc:GetOriginalCodeRule()
	return c:IsOriginalCodeRule(fcode) and (not c:IsOnField() or c:GetRealFieldID()>e:GetFieldID())
end
function c21692400.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(function(c) return c:IsSetCard(0x555) and c:IsDiscardable() end,tp,LOCATION_HAND,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,function(c) return c:IsSetCard(0x555) and c:IsDiscardable() end,tp,LOCATION_HAND,0,1,1,nil) 
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end 
function c21692400.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,c,1,0,0)
end
function c21692400.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then 
		Duel.SSet(tp,c)  
	end
end





