--量子驱动 破坏王Υ
if not pcall(function() require("expansions/script/c10130001") end) then require("script/c10130001") end
local s,id = GetID()
function s.initial_effect(c)
	Scl.SetSummonCondition(c, false, aux.FALSE)
	local e1 = Scl.CreateSingleTriggerContinousEffect(c, "BeNormalSet", nil, nil, "SetAvailable,!NegateEffect,Uncopyable", s.cpcon, s.cpop)
	local e2 = Scl.CreateQuickOptionalEffect(c, "FreeChain", "NegateEffect", nil, "NegateEffect,Return2Hand", "SetAvailable", "MonsterZone", nil, s.negcost, nil, s.negop)
	Scl_Quantadrive.CreateNerveContact(s, e2)
end
function s.cpcon(e,tp)
	local c = e:GetHandler()
	local mat = c:GetMaterial()
	return mat:IsExists(s.cfilter,1,nil)
end
function s.cfilter(c)
	return c:IsSetCard(0xa336) and Scl.IsType(c,0,"Monster,Flip,Effect") and c:IsReason(REASON_RELEASE) and c.Scl_Quantadrive_Filp_Effect
end
function s.cpop(e,tp)
	local c = e:GetHandler()
	local mat = c:GetMaterial():Filter(s.cfilter,nil)
	for tc in aux.Next(mat) do
		local ce = tc.Scl_Quantadrive_Filp_Effect
		Scl.CloneEffect({c,c,true}, ce, "Reset", RESETS_SCL)
	end
end
function s.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c = e:GetHandler()
	if chk==0 then return c:IsFacedown() end
	local pos = Duel.SelectPosition(tp, c, POS_FACEUP)
	Duel.ChangePosition(c,pos)
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	local c0,c = Scl.GetActivateCard()
	if c and not c:IsStatus(STATUS_DESTROY_CONFIRMED) and c:IsAbleToHand() and Scl.SelectYesNo(tp, {id,0}) then
		Scl.Send2Hand(c, nil, REASON_EFFECT, true)
	end
	--negate
	local e1=Effect.CreateEffect(c0)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetCountLimit(1)
	e1:SetCondition(s.negcon2)
	e1:SetOperation(s.negop2)
	Duel.RegisterEffect(e1,tp)
end
function s.negcon2(e,tp,eg,ep,ev,re,r,rp)
	return rp ~= tp
end
function s.negop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	Duel.NegateEffect(ev,true) 
end