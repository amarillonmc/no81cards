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
	local cm_send_to_hand=Duel.SendtoHand
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
			if tc:IsType(TYPE_FIELD) then
				Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
				Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
			else
				Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			end 
			te:UseCountLimit(tp,1,true)
			cm.ActivateCard(tc,tp)
			if not (tc:IsType(TYPE_CONTINUOUS) or tc:IsType(TYPE_FIELD) or tc:IsType(TYPE_EQUIP)) then
				Duel.SendtoGrave(tc,REASON_RULE)
			end
		else
			cm_send_to_hand(c,tp,a,...)
			if aux.GetValueType(c)=="Card" then
				sol=1
			elseif aux.GetValueType(c)=="Group" then
				sol=c:GetCount()
			end
		end
		return sol
	end
	local cm_send_to_grave=Duel.SendtoGrave
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
		if tc:IsCode(m) and single==1 and tc:CheckActivateEffect(false,false,false)~=nil and a~=REASON_RULE and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.Hint(HINT_CARD,0,m)
			local te=tc:GetActivateEffect()
			if tc:IsType(TYPE_FIELD) then
				Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
				Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
			else
				Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			end 
			te:UseCountLimit(tp,1,true)
			cm.ActivateCard(tc,tp)
			if not (tc:IsType(TYPE_CONTINUOUS) or tc:IsType(TYPE_FIELD) or tc:IsType(TYPE_EQUIP)) then
				Duel.SendtoGrave(tc,REASON_RULE)
			end
		else
			cm_send_to_grave(c,a,...)
			if aux.GetValueType(c)=="Card" then
				sol=1
			elseif aux.GetValueType(c)=="Group" then
				sol=c:GetCount()
			end
		end
		return sol
	end
end

function cm.ActivateCard(c,tp)
	--local oe=oe
	
	local e=c:GetActivateEffect()
	local tp=e:GetHandlerPlayer()
	local cos,tg,op=e:GetCost(),e:GetTarget(),e:GetOperation()
	if e and (not cos or cos(e,tp,eg,ep,ev,re,r,rp,0)) and (not tg or tg(e,tp,eg,ep,ev,re,r,rp,0)) then
		--oe:SetProperty(e:GetProperty())
		local code=c:GetOriginalCode()
		Duel.Hint(HINT_CARD,tp,code)
		Duel.Hint(HINT_CARD,1-tp,code)
		e:UseCountLimit(tp,1,true)
		c:CreateEffectRelation(e)
		if cos then cos(e,p,eg,ep,ev,re,r,rp,1) end
		if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		if g and #g~=0 then
			local tg=g:GetFirst()
			while tg do
				tg:CreateEffectRelation(e)
				tg=g:GetNext()
			end
		end
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
		c:ReleaseEffectRelation(e)
		if g then
			tg=g:GetFirst()
			while tg do
				tg:ReleaseEffectRelation(e)
				tg=g:GetNext()
			end
		end
	end
end