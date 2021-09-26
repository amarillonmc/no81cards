--龙宫城·璃彩回廊
local m=11451425
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--act in player turn
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(m)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(1,0)
	e2:SetCondition(cm.condition)
	c:RegisterEffect(e2)
	--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(cm.con)
	e3:SetOperation(cm.op)
	c:RegisterEffect(e3)
end
function cm.filter(c,e,tp)
	return c:IsSetCard(0x6978) and c:IsAbleToGrave()
end
function cm.filter3(c)
	return c:IsFaceup() and bit.band(c:GetType(),0x81)==0x81 and c:IsSetCard(0x6978) and c:IsSummonType(SUMMON_TYPE_RITUAL)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(m)==0
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.filter3,tp,LOCATION_MZONE,0,1,nil)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	--effect phase end
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCountLimit(1)
	e3:SetCondition(cm.condition3)
	e3:SetOperation(cm.operation3)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function cm.condition3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil)
end
function cm.operation3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_DECK,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local hg=g:SelectSubGroup(tp,aux.dncheck,false,1,2)
	Duel.SendtoGrave(hg,REASON_EFFECT)
end