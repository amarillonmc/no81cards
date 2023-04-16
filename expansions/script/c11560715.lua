--星海航线 逐界苍星
function c11560715.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,c11560715.mfilter,c11560715.xyzcheck,2,2)
	--ov
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING) 
	e1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,11560715)
	e1:SetCondition(c11560715.ovcon) 
	e1:SetTarget(c11560715.ovtg)
	e1:SetOperation(c11560715.ovop)
	c:RegisterEffect(e1) 
	--xx
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)  
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,21560715) 
	e2:SetTarget(c11560715.xxtg)
	e2:SetOperation(c11560715.xxop)
	c:RegisterEffect(e2) 
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(1) 
	e3:SetCondition(function(e) 
	return e:GetHandler():GetOverlayCount()>0 end)
	c:RegisterEffect(e3)
end
c11560715.SetCard_SR_Saier=true  
function c11560715.mfilter(c,xyzc)
	return c:IsXyzType(TYPE_XYZ) 
end
function c11560715.xyzcheck(g)
	return g:GetClassCount(Card.GetRank)==1
end
function c11560715.ovcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end 
function c11560715.ovtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re:GetHandler():IsCanOverlay() end
end
function c11560715.ovop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local rc=re:GetHandler() 
	if c:IsRelateToEffect(e) and rc:IsRelateToEffect(re) then 
		rc:CancelToGrave()  
		Duel.Overlay(c,rc) 
		c:SetHint(CHINT_CARD,rc:GetOriginalCodeRule()) 
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_ACTIVATE)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetRange(LOCATION_MZONE) 
		e2:SetTargetRange(0,1) 
		e2:SetLabelObject(rc)
		e2:SetValue(function(e,re,tp) 
		local rc=e:GetLabelObject()
		return rc and re:GetHandler():IsOriginalCodeRule(rc:GetCode()) end)
		c:RegisterEffect(e2)
	end 
end
function c11560715.xxtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
end
function c11560715.xxop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) then 
		local og=c:GetOverlayGroup() 
		local tc=og:Select(tp,1,1,nil):GetFirst() 
		Duel.SendtoGrave(tc,REASON_EFFECT) 
		if tc:IsType(TYPE_MONSTER) then 
		local code=tc:GetOriginalCodeRule()
		local cid=0
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(code)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		if not tc:IsType(TYPE_TRAPMONSTER) then
			cid=c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,1)
		end 
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(tc:GetBaseAttack()/2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		elseif tc:IsType(TYPE_SPELL+TYPE_TRAP) then 
			local te,ceg,cep,cev,cre,cr,crp=tc:CheckActivateEffect(false,true,true) 
			if te then 
				local tg=te:GetTarget()
				if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end 
				local op=te:GetOperation()
				if op then op(e,tp,eg,ep,ev,re,r,rp) end 
				if Duel.IsExistingMatchingCard(Card.IsCanOverlay,tp,LOCATION_MZONE,LOCATION_MZONE,1,c) and c:IsRelateToEffect(e) and Duel.SelectYesNo(tp,aux.Stringid(11560715,0)) then 
					local oc=Duel.SelectMatchingCard(tp,Card.IsCanOverlay,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,c):GetFirst()  
					Duel.Overlay(c,oc)   
				end 
			end  
		end  
	end 
end 





