--临界龙
function c87494700.initial_effect(c)
	c:SetSPSummonOnce(87494700) 
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,c87494700.mfilter,nil,99,99,c87494700.ovfilter,aux.Stringid(87494700,1)) 
	--ov and remove 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCountLimit(1,87494700) 
	e1:SetTarget(c87494700.ortg) 
	e1:SetOperation(c87494700.orop) 
	c:RegisterEffect(e1) 
	--zone 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_FREE_CHAIN) 
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1,17494700)  
	e2:SetTarget(c87494700.zntg)
	e2:SetOperation(c87494700.znop)
	c:RegisterEffect(e2)
end
function c87494700.mfilter(c,xyzc)
	return false 
end 
function c87494700.ovfilter(c)
	return c:IsFaceup() and c:IsRankAbove(5) and c:GetOverlayCount()>=3 
end 
function c87494700.ovfil(c,e,tp) 
	return (c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and c:IsCanOverlay() and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c)  
end 
function c87494700.ortg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c87494700.ovfil,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler(),e,tp) end 
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_ONFIELD)
end 
function c87494700.orop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c87494700.ovfil,tp,LOCATION_HAND+LOCATION_ONFIELD,0,e:GetHandler(),e,tp) 
	if c:IsRelateToEffect(e) and g:GetCount()>0 then 
		local oc=g:Select(tp,1,1,nil):GetFirst() 
		Duel.Overlay(c,oc) 
		if Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,oc) then 
		Duel.BreakEffect() 
		local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,oc) 
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
		end   
	end 
end  
function c87494700.zntg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetLabelObject()==nil and Duel.GetLocationCount(1-tp,LOCATION_MZONE,PLAYER_NONE,0)>0 and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end	
	local flag=Duel.SelectDisableField(tp,1,0,LOCATION_MZONE,0)
	e:SetLabel(flag)
	Duel.Hint(HINT_ZONE,tp,flag)
end
function c87494700.znop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) then 
	local x=c:RemoveOverlayCard(tp,1,4,REASON_EFFECT) 
	local flag=e:GetLabel()
	local seq=math.log(bit.rshift(flag,16),2)
	if not Duel.CheckLocation(1-tp,LOCATION_MZONE,seq) then return end 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_MUST_USE_MZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_NO_TURN_RESET)
	e1:SetTargetRange(0,1)
	e1:SetValue(flag | 0x600060)
	e1:SetCountLimit(x) 
	Duel.RegisterEffect(e1,tp)   
	e:SetLabelObject(e1) 
	local e2=Effect.CreateEffect(c) 
	e2:SetDescription(aux.Stringid(87494700,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e2:SetCode(EVENT_MOVE)   
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT) 
	e2:SetLabel(seq,x,0) 
	e2:SetLabelObject(e1)
	e2:SetCondition(c87494700.rstcon)  
	e2:SetOperation(c87494700.rstop) 
	Duel.RegisterEffect(e2,tp) 
	end 
end
function c87494700.rstckfil(c,seq,tp)  
	return aux.GetColumn(c) and seq==4-aux.GetColumn(c) and c:IsControler(1-tp)
end
function c87494700.rstcon(e,tp,eg,ep,ev,re,r,rp)   
	local seq,x=e:GetLabel()
	return eg:IsExists(c87494700.rstckfil,1,e:GetHandler(),seq,tp) 
end 
function c87494700.rstop(e,tp,eg,ep,ev,re,r,rp) 
	local seq,x,a=e:GetLabel() 
	local te=e:GetLabelObject() 
	local a=a+1
	e:GetHandler():SetTurnCounter(a) 
	if a==x and te then 
	e:Reset()
	te:Reset() 
	else  
	e:SetLabel(seq,x,a) 
	end 
end 







