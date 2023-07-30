--水晶国度时轮
local m=60002218
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableCounterPermit(0x1,LOCATION_SZONE+LOCATION_MZONE)
	--synchro summon
	aux.AddSynchroMixProcedure(c,cm.matfilter1,nil,nil,aux.NonTuner(nil),1,99)
	c:EnableReviveLimit()
	--synchro summon
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1164)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(cm.syncon)
	e0:SetTarget(cm.syntg)
	e0:SetOperation(cm.synop)
	e0:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e0)
	--summon success
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(cm.addct)
	e1:SetOperation(cm.addc)
	c:RegisterEffect(e1)
	--draw
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,2))
	e5:SetCategory(CATEGORY_DRAW)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCountLimit(1)
	e5:SetCost(cm.cost)
	e5:SetOperation(cm.drop)
	c:RegisterEffect(e5)
end
function cm.matfilter1(c)
	return c:IsSynchroType(TYPE_TUNER) or c:IsSetCard(0x6a8)
end
function cm.synfilter(c)
	return (c:GetOriginalType()&TYPE_MONSTER~=0 and c:IsCanBeSynchroMaterial() and c:IsLocation(LOCATION_SZONE)) or (c:IsFaceup() and c:IsLocation(LOCATION_MZONE))
end
function cm.syncon(e,c,smat)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local mg=Duel.GetMatchingGroup(cm.synfilter,c:GetControler(),LOCATION_ONFIELD,0,nil)
	if smat and smat:IsType(TYPE_TUNER) then
		return Duel.CheckTunerMaterial(c,smat,nil,aux.NonTuner(aux.TRUE),1,99,mg) end
	return Duel.CheckSynchroMaterial(c,nil,aux.NonTuner(aux.TRUE),1,99,smat,mg)
end
function cm.syntg(e,tp,eg,ep,ev,re,r,rp,chk,c,smat)
	local g=nil
	local mg=Duel.GetMatchingGroup(cm.synfilter,c:GetControler(),LOCATION_ONFIELD,0,nil)
	if smat and smat:IsType(TYPE_TUNER) then
		g=Duel.SelectTunerMaterial(c:GetControler(),c,smat,nil,aux.NonTuner(aux.TRUE),1,99,mg)
	else
		g=Duel.SelectSynchroMaterial(c:GetControler(),c,nil,aux.NonTuner(aux.TRUE),1,99,smat,mg)
	end
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else return false end
end
function cm.synop(e,tp,eg,ep,ev,re,r,rp,c,smat,mg,min,max)
	local g=e:GetLabelObject()
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
	g:DeleteGroup()
end
function cm.thcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function cm.addct(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,3,0,0x1)
end
function cm.addc(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0x1,3)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetTargetRange(1,0)
		e1:SetTarget(cm.splimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.splimit(e,c)
	return not c:IsRace(RACE_ROCK)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x1,1,REASON_COST) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.RemoveCounter(tp,1,0,0x1,1,REASON_COST)
end
function cm.thfilter(c)
	return c:IsSetCard(0x6a8) and c:IsAbleToHand()
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ResetTimeLimit(tp,300)
end