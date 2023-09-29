local m=53715012
local cm=_G["c"..m]
cm.name="欢乐树友 父子"
if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.descon)
	e1:SetTarget(cm.destg)
	e1:SetOperation(cm.desop)
	c:RegisterEffect(e1)
end
function cm.cfilter(c)
	return bit.band(c:GetOriginalType(),TYPE_EFFECT)==0 and c:IsType(TYPE_PENDULUM)
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_PZONE,0,1,e:GetHandler())
end
function cm.filter(c)
	return c:IsType(TYPE_NORMAL) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function cm.filter3(c,g)
	return g:IsExists(Card.IsCode,1,c,c:GetCode())
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
	if chk==0 then return #g>1 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dg=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
	local code1,code2=dg:GetFirst():GetCode(),dg:GetNext():GetCode()
	if c:IsRelateToEffect(e) and dg:GetCount()>=2 and Duel.Destroy(dg,REASON_EFFECT)==2 then
		local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_DECK,0,nil)
		local sg=g:Filter(cm.filter3,nil,g)
		if sg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
			local pg1=sg:Select(tp,1,1,nil)
			local pg2=sg:Filter(Card.IsCode,pg1:GetFirst(),pg1:GetFirst():GetCode())
			pg1:AddCard(pg2:GetFirst())
			Duel.SendtoExtraP(pg1,tp,REASON_EFFECT)
		end
	end
	SNNM.HTFPlacePZone(c,2,LOCATION_GRAVE,0,EVENT_FREE_CHAIN,m,tp)
end
