--卫星闪灵·圣艾尔摩火
function c11579814.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_DETACH_EVENT)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,function(c,xyzc) return c:IsLink(2) or c:IsRank(2) end,nil,2,99)  
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK) 
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(function(e,c) 
	return c:GetOverlayGroup():Filter(function(c) return c:IsSetCard(0x180) end,nil):GetSum(Card.GetAttack) end)
	c:RegisterEffect(e1) 
	--effect gian
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(c11579814.efop)
	c:RegisterEffect(e2)  
	--ov 
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DETACH_MATERIAL) 
	e2:SetProperty(EFFECT_FLAG_DELAY)  
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,11579814)
	e2:SetCondition(c11579814.ovcon)
	e2:SetTarget(c11579814.ovtg)
	e2:SetOperation(c11579814.ovop)
	c:RegisterEffect(e2) 
	--atkup
	local e3=Effect.CreateEffect(c)  
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP) 
	e3:SetRange(LOCATION_MZONE)  
	e3:SetCountLimit(1) 
	e3:SetCost(c11579814.atkcost)
	e3:SetTarget(c11579814.atktg)
	e3:SetOperation(c11579814.atkop)
	c:RegisterEffect(e3)
end
function c11579814.effilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x180)
end
function c11579814.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	local ct=c:GetOverlayGroup() 
	local wg=ct:Filter(c11579814.effilter,nil,tp)
	local wbc=wg:GetFirst()
	while wbc do
		local code=wbc:GetOriginalCode()
		if c:GetFlagEffect(code)==0 then
			local cid=c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD,1)
			c:RegisterFlagEffect(code,RESET_EVENT+RESETS_STANDARD,0,1,cid)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e3:SetRange(LOCATION_MZONE)
			e3:SetCode(EVENT_ADJUST)
			e3:SetLabel(code,cid)
			e3:SetCondition(c11579814.regcon)
			e3:SetOperation(c11579814.regop)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e3)
		end 
		wbc=wg:GetNext()
	end  
end
function c11579814.regcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetOverlayGroup()
	local code,cid=e:GetLabel()
	return not g or not g:IsExists(aux.FilterEqualFunction(Card.GetOriginalCode,code),1,nil)
end
function c11579814.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetOverlayGroup()
	local code,cid=e:GetLabel()
	--if tc and tc:GetOriginalCode()==c:GetFlagEffectLabel(11579814) then return end
	--local cid=c:GetFlagEffectLabel(code)
	c:ResetEffect(cid,RESET_COPY)
	c:ResetFlagEffect(code)
end
function c11579814.ovcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsControler,1,nil,tp) and eg:IsExists(Card.IsLocation,1,nil,LOCATION_MZONE)
end 
function c11579814.ovfil(c) 
	return c:IsCanOverlay() 
end 
function c11579814.ovgck(g) 
	return g:IsExists(function(c) return c:IsLevel(2) or c:IsRank(2) or c:IsLink(2) end,1,nil) 
end 
function c11579814.ovtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetMatchingGroup(c11579814.ovfil,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,e:GetHandler())
	if chk==0 then return g:CheckSubGroup(c11579814.ovgck,2,2) end  
end 
function c11579814.ovop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	local g=Duel.GetMatchingGroup(c11579814.ovfil,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,e:GetHandler())
	if c:IsRelateToEffect(e) and g:CheckSubGroup(c11579814.ovgck,2,2) then 
		local og=g:SelectSubGroup(tp,c11579814.ovgck,false,2,2)
		local oog=og:GetFirst():GetOverlayGroup()
		if oog:GetCount()>0 then
			Duel.SendtoGrave(oog,REASON_RULE)
		end
		Duel.Overlay(c,og)
	end  
end
function c11579814.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c11579814.atkfilter(c)
	return c:IsFaceup() and (c:IsLevel(2) or c:IsRank(2) or c:IsLink(2))
end
function c11579814.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c11579814.atkfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c11579814.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c11579814.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c11579814.atkop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(c:GetAttack())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end



