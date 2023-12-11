if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
local s,id,o=GetID()
function s.initial_effect(c)
	SNNM.ATTSeries(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	if ex and (tg~=nil or tc>0) and Duel.IsExistingMatchingCard(function(c)return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_FIRE)end,rp,LOCATION_MZONE,0,1,nil) and Duel.IsChainDisablable(ev) then
		Duel.Hint(HINT_CARD,0,id)
		local rc=re:GetHandler()
		if Duel.NegateEffect(ev) and rc:IsRelateToEffect(re) then
			Duel.SendtoGrave(rc,REASON_EFFECT)
		end
	end
end
