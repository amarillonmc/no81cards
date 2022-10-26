local m=31409100
local cm=_G["c"..m]
cm.name="赤燧烽圣域 炎狱火海"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(cm.tgdamcon)
	e2:SetOperation(cm.tgdamop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(cm.mondamcon)
	e3:SetOperation(cm.mondamop)
	c:RegisterEffect(e3)
	local e35=Effect.CreateEffect(c)
	e35:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e35:SetCode(EVENT_CHAINING)
	e35:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e35:SetRange(LOCATION_FZONE)
	e35:SetOperation(aux.chainreg)
	c:RegisterEffect(e35)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(cm.drcon)
	e4:SetOperation(cm.drop)
	c:RegisterEffect(e4)
end
function cm.tgdamfilter(c)
	return c:IsSetCard(0x310) and c:IsType(TYPE_MONSTER)
end
function cm.tgdamcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return g and g:FilterCount(cm.tgdamfilter,nil)>0
end
function cm.tgdamop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.Hint(HINT_OPSELECTED,0,aux.Stringid(m,0))
	Duel.Damage(1-tp,300,REASON_EFFECT)
end
function cm.mondamcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0x3310) and e:GetHandler():GetFlagEffect(1)>0
end
function cm.mondamop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.Hint(HINT_OPSELECTED,0,aux.Stringid(m,1))
	Duel.Damage(1-tp,300,REASON_EFFECT)
end
function cm.drfilter(c)
	return c:IsSetCard(0x3310) and c:IsType(TYPE_MONSTER)
end
function cm.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:FilterCount(cm.drfilter,nil,0x3310)>0 and Duel.IsPlayerCanDraw(tp,1)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
end