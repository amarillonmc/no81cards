--天璀司的星智
local m=82209089
local cm=_G["c"..m]
function cm.initial_effect(c)
	--activate  
	local e0=Effect.CreateEffect(c)  
	e0:SetType(EFFECT_TYPE_ACTIVATE)  
	e0:SetCode(EVENT_FREE_CHAIN)  
	c:RegisterEffect(e0)  
	--atk&def  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetCode(EFFECT_EXTRA_ATTACK)  
	e1:SetRange(LOCATION_SZONE)  
	e1:SetTargetRange(LOCATION_MZONE,0)  
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x9298))  
	e1:SetValue(1)  
	c:RegisterEffect(e1)   
	--spsummon  
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(m,0))  
	e3:SetCategory(CATEGORY_DRAW+CATEGORY_TOGRAVE)  
	e3:SetType(EFFECT_TYPE_IGNITION)  
	e3:SetRange(LOCATION_SZONE)  
	e3:SetCountLimit(1,m)  
	e3:SetCost(cm.drcost)  
	e3:SetTarget(cm.drtg)  
	e3:SetOperation(cm.drop)  
	c:RegisterEffect(e3)  
end
cm.toss_coin=true  

function cm.drfilter(c)
	return c:IsAbleToRemoveAsCost() and (c:IsSetCard(0x9298) or c:GetControler()~=c:GetOwner())
end
function cm.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.drfilter,tp,LOCATION_HAND,0,2,nil) end
	local g=Duel.SelectMatchingCard(tp,cm.drfilter,tp,LOCATION_HAND,0,2,2,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end  
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)  
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2) 
end  
function cm.drop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end  
	local coin=Duel.TossCoin(tp,1)
	if Duel.IsPlayerCanDraw(tp,2) then
		Duel.Draw(tp,2,REASON_EFFECT)
		if coin==1 and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_REMOVED,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_REMOVED,0,1,2,nil)
			if g:GetCount()>0 then
				Duel.SendtoGrave(g,REASON_EFFECT+REASON_RETURN)
			end
		end
	end	 
end  