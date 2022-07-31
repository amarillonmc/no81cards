--轮回世界的力量
function c6162302.initial_effect(c)
   --xyz summon
	aux.AddXyzProcedure(c,nil,8,2,c6162302.ovfilter,aux.Stringid(6162302,0),99,c6162302.xyzop)
	c:EnableReviveLimit()
	--immune  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_SINGLE)  
	e1:SetCode(EFFECT_IMMUNE_EFFECT)  
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)  
	e1:SetRange(LOCATION_ONFIELD)  
	e1:SetCondition(c6162302.imcon)  
	e1:SetValue(c6162302.efilter)  
	c:RegisterEffect(e1) 
	--material  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_IGNITION)  
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetCountLimit(1)  
	e2:SetTarget(c6162302.target)  
	e2:SetOperation(c6162302.operation)  
	c:RegisterEffect(e2)	
	if not c6162302.global_check then
		c6162302.global_check=true
		local ge1=Effect.GlobalEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_BATTLED)
		ge1:SetOperation(c6162302.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c6162302.ovfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsRace(RACE_SPELLCASTER)
end
function c6162302.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,6162302)>0 and Duel.GetFlagEffect(tp,90448280)==0 end
	Duel.RegisterFlagEffect(tp,90448280,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c6162302.check(c)
	return c and c:IsRace(RACE_SPELLCASTER)
end
function c6162302.checkop(e,tp,eg,ep,ev,re,r,rp)
	if c6162302.check(Duel.GetAttacker()) or c6162302.check(Duel.GetAttackTarget()) then
		Duel.RegisterFlagEffect(tp,6162302,RESET_PHASE+PHASE_END,0,1)
		Duel.RegisterFlagEffect(1-tp,6162302,RESET_PHASE+PHASE_END,0,1)
	end
end
function c6162302.filter1(c)  
	return c:IsOriginalSetCard(0x616,0x626) and c:IsFaceup()
end  
function c6162302.imcon(e)  
	return Duel.IsExistingMatchingCard(c6162302.filter1,e:GetHandlerPlayer(),LOCATION_SZONE,0,1,e:GetHandler())  
end  
function c6162302.efilter(e,te)  
	return not te:GetOwner():IsOriginalSetCard(0x616,0x626)  
end 
function c6162302.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c6162302.filter(chkc) and chkc~=e:GetHandler() end  
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ)  
		and Duel.IsExistingTarget(c6162302.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)  
	Duel.SelectTarget(tp,c6162302.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())  
end  
function c6162302.operation(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local tc=Duel.GetFirstTarget()  
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then  
		local og=tc:GetOverlayGroup()  
		if og:GetCount()>0 then  
			Duel.SendtoGrave(og,REASON_RULE)  
		end  
		Duel.Overlay(c,Group.FromCards(tc))  
	end  
end  