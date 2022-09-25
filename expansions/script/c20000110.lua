--坚珠的裁决 z
local cm,m,o=GetID()
if not pcall(function() require("expansions/script/c20000101") end) then require("script/c20000101") end
function cm.initial_effect(c)
	local e1={fu_judg.E(c)}
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.con2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return tp~=ep and eg:Filter(Card.IsSummonPlayer,nil,1-tp):IsExists(Card.IsPreviousLocation,1,nil,LOCATION_EXTRA) 
		and Duel.GetCurrentChain()==0 and fu_judg.E_con(e,tp,eg,ep,ev,re,r,rp)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local g=eg:Filter(Card.IsSummonPlayer,nil,1-tp):Filter(Card.IsPreviousLocation,nil,LOCATION_EXTRA)
	Duel.NegateSummon(g)
	Duel.Destroy(g,REASON_EFFECT)
end