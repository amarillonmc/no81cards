--冰汽时代 医生学徒
local m=33502204
local cm=_G["c"..m]
Duel.LoadScript("c33502200.lua")
function cm.initial_effect(c)
	local e1=syu.turnup(c,m,nil,nil,cm.turnupop,CATEGORY_RECOVER)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCondition(cm.damcon)
	e2:SetOperation(cm.disop)
	c:RegisterEffect(e2)
end
function cm.turnupop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,1000,REASON_EFFECT)
end
--e2
function cm.ctfilter(c,tp,tc)
	return c:GetSummonPlayer()==tp and c:IsSetCard(0x1a81) and c~=tc
end
function cm.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return eg:IsExists(cm.ctfilter,1,nil,tp,c)
end
function cm.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_FAIRY) and c:IsType(TYPE_SYNCHRO)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.Recover(tp,1000,REASON_EFFECT)
end