--概念虚械 才华
local m=20000157
local cm=_G["c"..m]
if not pcall(function() require("expansions/script/c20000150") end) then require("script/c20000150") end
function cm.initial_effect(c)
	local e1=fu_cim.XyzUnite(c,m,cm.Give)
end
function cm.Give(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,2))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
end
function cm.tgf1(c,rk)
	return c:IsSetCard(0xcfd1) and c:IsType(TYPE_XYZ) and c:IsCanOverlay() and c:IsRankBelow(rk)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgf1,tp,LOCATION_EXTRA,0,1,nil,e:GetHandler():GetRank()) and c:IsType(TYPE_XYZ) end
	Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(m,2))
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() and c:IsType(TYPE_XYZ) then
		local tc=Duel.SelectMatchingCard(tp,cm.tgf1,tp,LOCATION_EXTRA,0,1,1,nil,e:GetHandler():GetRank())
		if tc then
			Duel.Overlay(c,tc)
		end
	end
end