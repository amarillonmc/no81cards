local m=31417007
local cm=_G["c"..m]
cm.name="圣域歌者-阿刀"
if not pcall(function() require("expansions/script/c31417000") end) then require("expansions/script/c31417000") end
function cm.initial_effect(c)
	Seine_Vocaloid.enable(c,7)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_EXTRA)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function cm.filter(c,tp)
	return c:IsSummonPlayer(tp)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(cm.filter,1,nil,tp) and Duel.IsPlayerCanDraw(1-tp,1) and Duel.SelectYesNo(1-tp,aux.Stringid(m,1)) then
		Duel.Draw(1-tp,1,REASON_EFFECT)
	end
	if eg:IsExists(cm.filter,1,nil,1-tp) and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end