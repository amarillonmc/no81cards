--陆伴樱
local m=33703046
local cm=_G["c"..m]
function cm.initial_effect(c)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CUSTOM+m)
	e1:SetRange(LOCATION_HAND)
	--e1:SetHintTiming(TIMINGS_CHECK_MONSTER+TIMING_MAIN_END,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCondition(cm.eqcon)
	e1:SetTarget(cm.eqtg)
	e1:SetOperation(cm.eqop)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCondition(cm.eqc)
	
	--remove and eq ag
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(cm.rmtg)
	e2:SetOperation(cm.rmop)
	c:RegisterEffect(e2)
	--
		if not cm.global_check then
		cm.global_check=true
 	   local e0=Effect.CreateEffect(c)
  	 	 e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  	 	 e0:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e0:SetCode(EVENT_ADJUST)
		e0:SetRange(LOCATION_HAND)
 	  	 e0:SetOperation(cm.adjustop)
		c:RegisterEffect(e0)
	end
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end 
end

function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc= e:GetHandler():GetEquipTarget()
	local temp =tc
	if tc:IsAbleToRemove() then
		if Duel.Remove(tc,POS_FACEUP,REASON_TEMPORARY)~=0 then
				--Duel.ReturnToField(tc)
		   --return onfield
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetLabelObject(temp)
			e1:SetCountLimit(1)
			e1:SetOperation(cm.retop)
			Duel.RegisterEffect(e1,tp)

			--st eq
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
			e2:SetCountLimit(1)
			e2:SetLabel(Duel.GetTurnCount())
			e2:SetLabelObject(temp)
			e2:SetCondition(cm.eqcon2)
			e2:SetOperation(cm.eqop2)
			if Duel.GetCurrentPhase()<=PHASE_STANDBY then
				e2:SetReset(RESET_PHASE+PHASE_STANDBY,2)
			else
				e2:SetReset(RESET_PHASE+PHASE_STANDBY)
			end
			Duel.RegisterEffect(e2,tp)
		end
	end
	
end
function cm.eqcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) 
end
function cm.eqop2(e,tp,eg,ep,ev,re,r,rp)
	local tc =e:GetLabelObject()
	local c=e:GetHandler()
	if tc:IsLocation(LOCATION_MZONE)  then
		if Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			Duel.Equip(tp,c,tc)  
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(cm.eqlimit)
			c:RegisterEffect(e1)
		end
	end
end
function cm.eqlimit(e,c)
	return e:GetOwner()==c
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
		local tc =e:GetLabelObject()
		local k=tc
		Duel.ReturnToField(tc)
		--Duel.Equip(tp,e:GetHandler(),k) 

end
function cm.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return  Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2 
end
function cm.eqfilter(c)
	return c:IsFaceup() and (not c:IsCode(m))
end
function cm.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	--if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.eqfilter(chkc) end

	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(cm.eqfilter,tp,LOCATION_MZONE,0,1,nil) end

end

function cm.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
		Duel.RaiseEvent(g,EVENT_CUSTOM+m,re,r,rp,ep,ev)
end
function cm.eqop(e,tp,eg,ep,ev,re,r,rp)

	if Duel.SelectYesNo(tp,aux.Stringid(m,0))==true then
	local c=e:GetHandler()
	--if not c:IsRelateToEffect(e) then return end
	--if c:IsLocation(LOCATION_MZONE) and c:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local tg=Duel.SelectMatchingCard(tp,cm.eqfilter,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=tg:GetFirst()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:IsControler(1-tp) or tc:IsFacedown()  then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	 Duel.Equip(tp,c,tc) 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(cm.eqlimit)
	c:RegisterEffect(e1)
	else
	return
	
	end
end
function cm.eqlimit(e,c,tp)
	return 	c:IsControler(tp) and (not c:IsCode(m))
end