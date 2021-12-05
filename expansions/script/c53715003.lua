local m=53715003
local cm=_G["c"..m]
cm.name="欢乐树友 板牙"
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
function cm.filter(c,code1,code2)
	return c:IsType(TYPE_NORMAL) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden() and not c:IsCode(code1,code2)
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
		local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_DECK,0,nil,code1,code2)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
			local sg=g:Select(tp,1,1,nil,code1,code2)
			Duel.MoveToField(sg:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
	end
	SNNM.HTFPlacePZone(c,2,LOCATION_GRAVE,0,EVENT_FREE_CHAIN,m)
end
