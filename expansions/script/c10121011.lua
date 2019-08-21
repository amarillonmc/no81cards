--天使长 英勇之英普瑞斯
if not pcall(function() require("expansions/script/c10121001") end) then require("script/c10121001") end
local m=10121011
local cm=_G["c"..m]
function cm.initial_effect(c)
	rsdio.AngelHandXyzEffect(c,true)
	--get effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetCost(rscost.rmxyz(1))
	e2:SetTarget(cm.matg)
	e2:SetOperation(cm.maop)
	c:RegisterEffect(e2)
end
function cm.matg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ)
		and Duel.IsExistingMatchingCard(cm.mafilter,tp,LOCATION_DECK,0,1,nil) end
end
function cm.mafilter(nb)
	return nb:IsType(TYPE_MONSTER) and not nb:IsCode(m)
end
function cm.maop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:IsType(TYPE_XYZ) then return end
	Duel.Hint(HINT_SELECTMSG,tp,rshint.xyz)
	local g=Duel.SelectMatchingCard(tp,cm.mafilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Overlay(c,g)
	end
end