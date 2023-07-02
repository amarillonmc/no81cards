--指引前路的苍蓝之星·狩猎笛
function c11561034.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_WARRIOR),aux.NonTuner(nil),1)   
	--xx
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_QUICK_O) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCountLimit(1,11561034)
	e1:SetTarget(c11561034.xxtg)   
	e1:SetOperation(c11561034.xxop) 
	c:RegisterEffect(e1)  
end 
c11561034.SetCard_ZH_Bluestar=true 
function c11561034.xxtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end 
end 
function c11561034.xxop(e,tp,eg,ep,ev,re,r,rp)   
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil) 
	if g:GetCount()>0 then  
		local dtb={aux.Stringid(11561034,1),aux.Stringid(11561034,2),aux.Stringid(11561034,3)} 
		local op=Duel.SelectOption(tp,table.unpack(dtb))+1
		local x=dtb[op]  
		local tc=g:GetFirst() 
		while tc do 
		if x==aux.Stringid(11561034,1) then 
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE) 
			e1:SetCode(EFFECT_UPDATE_ATTACK) 
			e1:SetRange(LOCATION_MZONE)
			e1:SetValue(2000)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)   
		elseif x==aux.Stringid(11561034,2) then 
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE) 
			e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
			e1:SetCountLimit(1)
			e1:SetValue(function(e,re,r,rp)
			return bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 end)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1) 
		elseif x==aux.Stringid(11561034,3) then 
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE) 
			e1:SetCode(EFFECT_EXTRA_ATTACK)
			e1:SetRange(LOCATION_MZONE)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
		end 
		tc=g:GetNext() 
		end  
		table.remove(dtb,op) 
		if Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsRace(RACE_WARRIOR) and c:IsSummonLocation(LOCATION_EXTRA) end,tp,LOCATION_MZONE,0,1,e:GetHandler()) and Duel.SelectYesNo(tp,aux.Stringid(11561034,0)) then 
			local op=Duel.SelectOption(tp,table.unpack(dtb))+1   
			local x=dtb[op]  
			local tc=g:GetFirst() 
			while tc do 
			if x==aux.Stringid(11561034,1) then 
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE) 
				e1:SetCode(EFFECT_UPDATE_ATTACK) 
				e1:SetRange(LOCATION_MZONE)
				e1:SetValue(2000)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e1)   
			elseif x==aux.Stringid(11561034,2) then 
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE) 
				e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
				e1:SetCountLimit(1)
				e1:SetValue(function(e,re,r,rp)
				return bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 end)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e1) 
			elseif x==aux.Stringid(11561034,3) then 
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE) 
				e1:SetCode(EFFECT_EXTRA_ATTACK)
				e1:SetRange(LOCATION_MZONE)
				e1:SetValue(1)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e1)
			end 
			tc=g:GetNext() 
			end   
		end 
	end   
end 











