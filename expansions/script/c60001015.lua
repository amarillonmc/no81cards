--终位岚术
local cm,m,o=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1) 
end
if not cm.lsy_change_operation2 then
	cm.lsy_change_operation2=true
	cm._send_to_hand=Duel.SendtoHand
	Duel.SendtoHand=function (c,tp,a,...)
		local sol=0
		local tc=0
		local single=0
		if aux.GetValueType(c)=="Card" then
			tc=c
			single=1
		elseif aux.GetValueType(c)=="Group" then
			tc=c:GetFirst()
			if c:GetCount()==1 then
				single=1
			end
		end
		if tc:IsCode(m) and single==1 and tc:CheckActivateEffect(false,false,false)~=nil and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			Duel.Hint(HINT_CARD,0,m)
			local te=tc:GetActivateEffect()
			if gc:IsType(TYPE_FIELD) then
				Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
				Duel.RaiseEvent(gc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
			else
				Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			end 
			te:UseCountLimit(tp,1,true)
			cm.ActivateCard(tc,tp,e)
			if not (tc:IsType(TYPE_CONTINUOUS) or tc:IsType(TYPE_FIELD) or tc:IsType(TYPE_EQUIP)) then
				Duel.SendtoGrave(tc,REASON_RULE)
			end
		else
			cm._send_to_hand(c,tp,a,...)
			if aux.GetValueType(c)=="Card" then
				sol=1
			elseif aux.GetValueType(c)=="Group" then
				sol=c:GetCount()
			end
		end
		return sol
	end
	cm._send_to_grave=Duel.SendtoGrave
	Duel.SendtoGrave=function (c,a,...)
		local sol=0
		local tc=0
		local single=0
		if aux.GetValueType(c)=="Card" then
			tc=c
			single=1
		elseif aux.GetValueType(c)=="Group" then
			tc=c:GetFirst()
			if c:GetCount()==1 then
				single=1
			end
		end
		if tc:IsCode(m) and single==1 and tc:CheckActivateEffect(false,false,false)~=nil and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.Hint(HINT_CARD,0,m)
			local te=tc:GetActivateEffect()
			if gc:IsType(TYPE_FIELD) then
				Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
				Duel.RaiseEvent(gc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
			else
				Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			end 
			te:UseCountLimit(tp,1,true)
			cm.ActivateCard(tc,tp,e)
			if not (tc:IsType(TYPE_CONTINUOUS) or tc:IsType(TYPE_FIELD) or tc:IsType(TYPE_EQUIP)) then
				Duel.SendtoGrave(tc,REASON_RULE)
			end
		else
			cm._send_to_grave(c,a,...)
			if aux.GetValueType(c)=="Card" then
				sol=1
			elseif aux.GetValueType(c)=="Group" then
				sol=c:GetCount()
			end
		end
		return sol
	end
end