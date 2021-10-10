--肃清守护天灵 雷米耶尔逆
local m=40009859
local cm=_G["c"..m]
cm.named_with_ProtectorSpirit=1
cm.named_with_Reverse=1
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,m)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_FAIRY),2)
	--add type
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.tncon)
	e1:SetOperation(cm.tnop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(cm.valcheck)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--disable
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMING_DRAW_PHASE)
	e3:SetCountLimit(1,m)
	e3:SetCondition(cm.discon)
	e3:SetCost(cm.cost)
	e3:SetOperation(cm.disop)
	c:RegisterEffect(e3)
end
function cm.ProtectorSpirit(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_ProtectorSpirit
end
function cm.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsCode,1,nil,m-2) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function cm.tncon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and e:GetLabel()==1
end
function cm.tnop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(600)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	c:RegisterEffect(e3)
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetLP(e:GetHandlerPlayer())>=12000 or Duel.GetLP(1-tp)>=12000)
end
function cm.cfilter(c,tp)
	return c:IsFaceup() and c:IsCanTurnSet() and cm.ProtectorSpirit(c)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_MZONE,0,2,2,nil)
	Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local e5=Effect.CreateEffect(e:GetHandler())
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCode(EFFECT_CANNOT_SUMMON)
	e5:SetTargetRange(1,1)
	e5:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e5,tp)
	--act limit
	local e6=Effect.CreateEffect(e:GetHandler())
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_CANNOT_RELEASE)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetTargetRange(1,1)
	e6:SetTarget(cm.rellimit)
	e6:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e6,tp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetTargetRange(0xff,0xff)
	e1:SetTarget(aux.NOT(aux.TargetBoolFunction(Card.IsSummonableCard,nil)))
	e1:SetValue(cm.fuslimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e2:SetValue(cm.sumlimit)
	Duel.RegisterEffect(e2,tp)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	Duel.RegisterEffect(e3,tp)
	local e4=e2:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	Duel.RegisterEffect(e4,tp)
end
function cm.refilter(c)
	return c:IsSummonableCard()
end
function cm.rellimit(e,c,tp,sumtp)
	return c:IsSummonableCard()
end
function cm.fuslimit(e,c,sumtype)
	if not c then return true end
	return c:IsControler(e:GetHandlerPlayer()) and sumtype==SUMMON_TYPE_FUSION 
end
function cm.sumlimit(e,c)
	if not c then return true end
	return c:IsControler(e:GetHandlerPlayer())
end

