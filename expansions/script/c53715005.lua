local m=53715005
local cm=_G["c"..m]
cm.name="欢乐树友 洁癖"
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
	return c:IsFaceup() and not c:IsType(TYPE_EFFECT)
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return c:IsDestructable() end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,c,1,0,0)
end
function cm.filter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsType(TYPE_NORMAL) and not c:IsCode(m)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.Destroy(c,REASON_EFFECT)~=0 then
		local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_DECK,0,nil)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
			local sg=g:Select(tp,1,1,nil)
			Duel.SendtoExtraP(sg,tp,REASON_EFFECT)
		end
	end
	SNNM.HTFPlacePZone(c,2,LOCATION_GRAVE,0,EVENT_FREE_CHAIN,m,tp)
end
