--时穿剑魄·圣
local m=14000017
local cm=_G["c"..m]
cm.named_with_Chronoblade=1
xpcall(function() require("expansions/script/c14000001") end,function() require("script/c14000001") end)
function cm.initial_effect(c)
	c:SetSPSummonOnce(m)
	--xyz summon
	aux.AddXyzProcedureLevelFree(c,cm.mfilter,cm.xyzcheck,2,99)
	c:EnableReviveLimit()
	--effect gian
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(cm.efop)
	c:RegisterEffect(e1)
end
function cm.mfilter(c)
	return chrb.CHRB(c)
end
function cm.xyzcheck(g)
	return g:GetClassCount(Card.GetCode)==#g
end
function cm.effilter(c)
	return c:IsType(TYPE_MONSTER) and chrb.CHRB(c)
end
function cm.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	local ct=c:GetOverlayGroup(tp,1,0)
	local wg=ct:Filter(cm.effilter,nil,tp)
	local wbc=wg:GetFirst()
	while wbc do
		local code=wbc:GetOriginalCode()
		if c:IsFaceup() and c:GetFlagEffect(code)==0 then
		c:CopyEffect(code, RESET_EVENT+0x1fe0000+EVENT_CHAINING, 1)
		c:RegisterFlagEffect(code,RESET_EVENT+0x1fe0000+EVENT_CHAINING,0,1)  
		end 
		wbc=wg:GetNext()
	end  
end