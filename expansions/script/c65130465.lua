--断你电脑网
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local sg=Group.CreateGroup()
	sg:AddCard(Duel.CreateToken(1-tp,id))
	--Duel.ConfirmCards(1-tp,sg)
	local code=sg:Select(1-tp,1,1,nil):GetOriginalCode()
	Duel.Hint(HINT_CARD,0,code)
end