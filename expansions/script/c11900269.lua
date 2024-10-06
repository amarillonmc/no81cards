--大地繁盛
local s,id,o=GetID()
function s.initial_effect(c)
	--recover
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCondition(s.rccon)
	e1:SetTarget(s.rctg)
	e1:SetOperation(s.rcop)
	c:RegisterEffect(e1)
end
function s.rccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(e:GetHandler():GetControler())<8000
end
function s.rctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
    local lp=Duel.GetLP(e:GetHandler():GetControler())
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,8000-lp)
end
function s.rcop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
    local lp=Duel.GetLP(p)
    if lp<8000 then
	    Duel.Recover(p,8000-lp,REASON_EFFECT)
    end
end