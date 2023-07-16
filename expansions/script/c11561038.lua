--苍蓝之星补给-鬼人药·G
function c11561038.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetTarget(c11561038.actg) 
	e1:SetOperation(c11561038.acop) 
	c:RegisterEffect(e1) 
	--xx
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_IGNITION) 
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE) 
	e2:SetCountLimit(1,11561038)
	e2:SetCost(aux.bfgcost) 
	e2:SetTarget(c11561038.xxtg) 
	e2:SetOperation(c11561038.xxop) 
	c:RegisterEffect(e2) 
end
c11561038.SetCard_ZH_Bluestar=true 
function c11561038.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsRace(RACE_WARRIOR) end,tp,LOCATION_MZONE,0,1,nil) end  
end 
function c11561038.acop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(function(c) return c:IsFaceup() and c:IsRace(RACE_WARRIOR) end,tp,LOCATION_MZONE,0,nil) 
	if g:GetCount()>0 then 
		local tc=g:Select(tp,1,1,nil):GetFirst() 
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_UPDATE_ATTACK) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetValue(1000) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		tc:RegisterEffect(e1)			
	end 
end 
function c11561038.xxtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(function(c) return c:IsFaceup() and c.SetCard_ZH_Bluestar end,tp,LOCATION_MZONE,0,1,nil) end  
	local g=Duel.SelectTarget(tp,function(c) return c:IsFaceup() and c.SetCard_ZH_Bluestar end,tp,LOCATION_MZONE,0,1,1,nil) 
end 
function c11561038.xxop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) then 
		--attack all
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ATTACK_ALL)
		e1:SetValue(1) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		tc:RegisterEffect(e1)
	end 
end 









