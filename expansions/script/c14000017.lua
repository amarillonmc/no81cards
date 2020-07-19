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
	local ef_1=Effect.CreateEffect(c)
	ef_1:SetType(EFFECT_TYPE_SINGLE)
	ef_1:SetCode(m)
	ef_1:SetRange(LOCATION_MZONE)
	ef_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SINGLE_RANGE)
	c:RegisterEffect(ef_1)
	local ef_2=Effect.CreateEffect(c)
	ef_2:SetType(EFFECT_TYPE_SINGLE)
	ef_2:SetCode(m+1000)
	ef_2:SetRange(LOCATION_MZONE)
	ef_2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	c:RegisterEffect(ef_2)
	local ef_3=Effect.CreateEffect(c)
	ef_3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ef_3:SetCode(EVENT_ADJUST)
	ef_3:SetRange(LOCATION_MZONE)
	ef_3:SetOperation(cm.op)
	c:RegisterEffect(ef_3)
	cm[ef_3]={}
end
function cm.mfilter(c)
	return chrb.CHRB(c)
end
function cm.xyzcheck(g)
	return g:GetClassCount(Card.GetCode)==#g
end
function cm.copyfilter(c,ec)
	return c:IsType(TYPE_MONSTER) and chrb.CHRB(c) and c:IsType(TYPE_EFFECT) and not c:IsType(TYPE_TRAPMONSTER) and not c:IsHasEffect(m) and ec:GetOverlayCount()>0
end
function cm.gfilter(c,g)
	if not g then return true end
	return not g:IsContains(c)
end
function cm.gfilter1(c,g)
	if not g then return true end
	return not g:IsExists(cm.gfilter2,1,nil,c:GetOriginalCode())
end
function cm.gfilter2(c,code)
	return c:GetOriginalCode()==code
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local copyt=cm[e]
	local exg=Group.CreateGroup()
	for tc,cid in pairs(copyt) do
		if tc and cid then exg:AddCard(tc) end
	end
	local g=c:GetOverlayGroup():Filter(cm.copyfilter,nil,c)
	local dg=exg:Filter(cm.gfilter,nil,g)
	for tc in aux.Next(dg) do
		c:ResetEffect(copyt[tc],RESET_COPY)
		exg:RemoveCard(tc)
		copyt[tc]=nil
	end
	local cg=g:Filter(cm.gfilter1,nil,exg)
	local f=Card.RegisterEffect
	Card.RegisterEffect=function(tc,e,forced)
		e:SetCondition(cm.rcon(e:GetCondition(),tc,copyt))
		f(tc,e,forced)
	end
	for tc in aux.Next(cg) do
		copyt[tc]=c:CopyEffect(tc:GetOriginalCode(),RESET_EVENT+0x1fe0000,1)
	end
	Card.RegisterEffect=f
end
function cm.rcon(con,tc,copyt)
	return function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		if not c:IsHasEffect(m+1000) then
			c:ResetEffect(c,copyt[tc],RESET_COPY)
			copyt[tc]=nil
			return false
		end
		if not con or con(e,tp,eg,ep,ev,re,r,rp) then return true end
		return e:IsHasType(0x7e0) and c:GetFlagEffect(m)>0
	end
end