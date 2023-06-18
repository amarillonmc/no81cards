--量子驱动 渗透者Σ
if not pcall(function() require("expansions/script/c10130001") end) then require("script/c10130001") end
local s,id = GetID()
function s.initial_effect(c)
	Scl.SetSummonCondition(c, false, aux.FALSE)
	local e1 = Scl.CreateSingleBuffEffect(c, "MaterialCheck", s.cpval, "AnyZone", nil, nil, nil, nil, "SetAvailable")
	local e2 = Scl.CreateQuickOptionalEffect(c, "FreeChain", "Return2Hand", nil, "Return2Hand", "SetAvailable", "MonsterZone", nil, s.rtcost, { "~Target", "Return2Hand", Card.IsAbleToHand, 0, "OnField"}, s.rtop)
	Scl_Quantadrive.CreateNerveContact(s, e2)
end
function s.cfilter(c)
	return c:IsSetCard(0xa336) and Scl.IsType(c,0,"Monster,Flip") and c.Scl_Quantadrive_Filp_Effect
end
function s.cpval(e,c)
	local mat = c:GetMaterial():Filter(s.cfilter,nil)
	for tc in aux.Next(mat) do
		local ce = tc.Scl_Quantadrive_Filp_Effect
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP)
		e1:SetDescription(ce:GetDescription())
		e1:SetCategory(ce:GetCategory())
		e1:SetTarget(ce:GetTarget())
		e1:SetOperation(ce:GetOperation())
		c:RegisterEffect(e1,true)
	end
end
function s.rtcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c = e:GetHandler()
	if chk==0 then return c:IsFacedown() end
	local pos = Duel.SelectPosition(tp, c, POS_FACEUP)
	Duel.ChangePosition(c,pos)
end
function s.rtop(e,tp)
	local _, c = Scl.GetActivateCard()
	if c and not c:IsStatus(STATUS_DESTROY_CONFIRMED) and c:IsAbleToHand() and Scl.SelectYesNo(tp, {id, 0}) then
		Scl.Send2Hand(c, nil, REASON_EFFECT, true)
	end
	Scl.SelectAndOperateCards("Return2Hand",tp,Card.IsAbleToHand,tp,0,"OnField",1,1,nil)()
end