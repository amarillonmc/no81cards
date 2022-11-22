local m=53707004
local cm=_G["c"..m]
cm.name="清响 祈明蝶"
cm.main_peacecho=true
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	SNNM.Peacecho(c,TYPE_MONSTER)
	SNNM.AllGlobalCheck(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.spcon)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e2:SetTarget(cm.tttg)
	e2:SetOperation(cm.ttop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_TO_DECK)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(0xff)
	e3:SetOperation(cm.checkop)
	c:RegisterEffect(e3)
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		e:GetHandler():RegisterFlagEffect(m,RESET_PHASE+PHASE_END,0,1)
	end
end
function cm.spcon(e,c)
	if c==nil then return true end
	local ct=c:GetFlagEffect(m)
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and ct>2 and ct<6
end
function cm.rmfilter(c)
	return c:IsRace(RACE_PLANT) and c:IsAbleToRemoveAsCost(POS_FACEDOWN) and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_DECK,0,1,c)
end
function cm.tttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.rmfilter,tp,LOCATION_DECK,0,1,nil) end
	SNNM.UpConfirm(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=Duel.SelectMatchingCard(tp,cm.rmfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.ConfirmCards(1-tp,rg)
	Duel.Remove(rg,POS_FACEDOWN,REASON_COST)
end
function cm.ttop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,3))
	local tc=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc then
		Duel.MoveSequence(tc,0)
		tc:ReverseInDeck()
	end
end
