--终焉之零点龙 达斯特
local m=40009059
local cm=_G["c"..m]
cm.named_with_ZerothDragon=1
function cm.ZerothDragon(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_ZerothDragon
end
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c)  
	--spsummon condition
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e6:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e6)
	--special summon
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_SPSUMMON_PROC)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e7:SetRange(LOCATION_EXTRA+LOCATION_HAND)
	e7:SetCondition(cm.spcon)
	e7:SetTarget(cm.sptg)
	e7:SetOperation(cm.spop)
	e7:SetValue(SUMMON_VALUE_SELF)
	c:RegisterEffect(e7)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(1,0)
	e1:SetCondition(cm.splimcon)
	e1:SetTarget(cm.splimit)
	c:RegisterEffect(e1)
	--1
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	--e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	--e2:SetCountLimit(1)
	e2:SetCondition(cm.con)
	--e2:SetTarget(cm.tg)
	e2:SetOperation(cm.op)
	e2:SetLabelObject(e7)
	c:RegisterEffect(e2)
	--2
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetCondition(cm.con)
	e4:SetValue(cm.atkval)
	e4:SetLabelObject(e7)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_UPDATE_DEFENSE)
	e5:SetValue(cm.defval)
	c:RegisterEffect(e5)




end
function cm.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function cm.splimit(e,c)
	return not (cm.ZerothDragon(c) or c:IsCode(40009060) or c:IsCode(40009061))
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetReleaseGroup(tp):Filter(Card.IsType,nil,TYPE_MONSTER)
	return rg:CheckSubGroup(aux.mzctcheckrel,5,5,tp)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local rg=Duel.GetReleaseGroup(tp):Filter(Card.IsType,nil,TYPE_MONSTER)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=rg:SelectSubGroup(tp,aux.mzctcheckrel,true,5,5,tp)
	if sg:GetCount()==5 then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	local label=0
	if g:FilterCount(Card.IsType,nil,TYPE_PENDULUM)==#g then
		label=label+1
	end
	e:SetLabel(label)
	Duel.Release(g,REASON_COST) 
	g:DeleteGroup()
end
function cm.con(e,tp,eg,ep,ev,re,r,rp,chk)
	--local label=e:GetLabel()
	local label=e:GetLabelObject():GetLabel()
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+SUMMON_VALUE_SELF  and label==1
end

function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	--e1:SetValue(500)
	e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_ATTACK_FINAL)
	e2:SetValue(1)
	Duel.RegisterEffect(e2,tp)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_SET_DEFENSE_FINAL)
	e3:SetValue(1)
	Duel.RegisterEffect(e3,tp)
	local e4=e1:Clone()
	e4:SetCode(EFFECT_REMOVE_RACE)
	e4:SetValue(RACE_ALL)
	Duel.RegisterEffect(e4,tp)
	local e5=e1:Clone()
	e5:SetCode(EFFECT_REMOVE_ATTRIBUTE)
	e5:SetValue(0xff)
	Duel.RegisterEffect(e5,tp)
	local e6=e1:Clone()
	e6:SetCode(EFFECT_CHANGE_TYPE)
	e6:SetValue(TYPE_MONSTER)
	Duel.RegisterEffect(e6,tp)
	local e7=e1:Clone()
	e7:SetCode(EFFECT_CHANGE_CODE)
	e7:SetValue(40010415)
	Duel.RegisterEffect(e7,tp)
end
function cm.atkval(e,c)
	return c:GetBaseAttack()
end
function cm.defval(e,c)
	return c:GetBaseDefense()
end