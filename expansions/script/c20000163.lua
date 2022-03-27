--虚构素体 B001
local m=20000163
local cm=_G["c"..m]
if not pcall(function() require("expansions/script/c20000150") end) then require("script/c20000150") end
function cm.initial_effect(c)
	local e1,e2=fu_cim.Hint(c,m,cm.con1,1)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_QUICK_O)
	e3:SetCountLimit(1)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCondition(fu_cim.Remove_Material_condition)
	e3:SetCost(fu_cim.Remove_Material_cost)
	e3:SetTarget(cm.tg2)
	e3:SetOperation(cm.op2)
	c:RegisterEffect(e3)
end
--e1
function cm.conf1(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.conf1,1,nil)
end
--e2
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(m,0))
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)>0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_DRAW)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end