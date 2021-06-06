--宇宙吞噬者 鲁格赛特
local m=25000157
local cm=_G["c"..m]
function cm.initial_effect(c)
c:EnableReviveLimit()
 --special summon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	  --special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(cm.spcon)
	e2:SetCost(cm.spcost)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
 --double
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e4:SetValue(aux.ChangeBattleDamage(1,DOUBLE_DAMAGE))
	c:RegisterEffect(e4)
--
 local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetOperation(cm.regop)
	c:RegisterEffect(e6)
	Duel.AddCustomActivityCounter(m,ACTIVITY_CHAIN,cm.chainfilter)
end
function cm.chainfilter(re,tp,cid)
	 return not (re:IsActiveType(TYPE_MONSTER))
end

function cm.spcfilter(c)
	return  not c:IsPublic()
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local hg=Duel.GetMatchingGroup(cm.spcfilter,tp,LOCATION_HAND,0,c)
	local hs=hg:GetCount()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetCustomActivityCount(m,tp,ACTIVITY_CHAIN)==0 and Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)==0
end
function cm.spcost(e,c,tp)
	return Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)==0
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local hg=Duel.GetMatchingGroup(cm.spcfilter,tp,LOCATION_HAND,0,c)
	local hs=hg:GetCount()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local rg=hg:Select(tp,1,hs,nil)
	Duel.ConfirmCards(1-tp,rg)
	Duel.ShuffleHand(tp)
	local ss=rg:GetCount()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(cm.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SET_BASE_ATTACK)
	e2:SetValue(ss*800)
	e2:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetTargetRange(1,0)
	e3:SetTarget(cm.splimit)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function cm.splimit(e,c,tp,sumtp,sumpos)
	return c~=e:GetHandler()
end
function cm.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) 
end

function cm.regop(e,tp,eg,ep,ev,re,r,rp)
   local c=e:GetHandler()
	  --activate limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetCondition(cm.effcon) 
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(cm.limit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetLabelObject(c)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCondition(cm.effcon) 
	e2:SetTarget(cm.disable)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetLabel(c:GetFieldID())
	e2:SetLabelObject(c)
	Duel.RegisterEffect(e2,tp)
end
function cm.effcon(e)
	local tc=e:GetLabelObject()
	return tc:IsOnField() and tc:IsFaceup() 
end
function cm.limit(e,re,tp)
	return  re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsImmuneToEffect(e)
end
function cm.disable(e,c)
	return c:GetFieldID()~=e:GetLabel() and (not c:IsType(TYPE_MONSTER) or (c:IsType(TYPE_EFFECT) or bit.band(c:GetOriginalType(),TYPE_EFFECT)==TYPE_EFFECT))
end