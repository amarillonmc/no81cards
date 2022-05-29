local m=53707015
local cm=_G["c"..m]
cm.name="清响 怅眠心"
cm.main_peacecho=true
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	SNNM.Peacecho(c,TYPE_MONSTER)
	SNNM.AllGlobalCheck(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_DECK)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.dspcon)
	e1:SetOperation(cm.dspop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(3)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
end
function cm.cfilter(c,e)
	if (e:GetHandler():IsFaceup() and c:IsFaceup()) or (e:GetHandler():IsFacedown() and c:IsFacedown()) then return false end
	return c:IsRace(RACE_PLANT) and c:IsAbleToRemoveAsCost(POS_FACEDOWN)
end
function cm.dspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetFlagEffect(tp,m)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_DECK,0,3,c,e)
end
function cm.dspop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_DECK,0,3,3,c,e)
	Duel.ConfirmCards(1-tp,g)
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END+RESET_SELF_TURN,0,2)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>1 end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>1 then Duel.ShuffleDeck(tp) end
end
