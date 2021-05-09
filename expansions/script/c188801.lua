--毅飞冲天-泽塔·阿尔法装甲
local m=188801
local cm=_G["c"..m]
function cm.initial_effect(c)
 --synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	 --spsummon
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(m,1))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetOperation(cm.hspop)
	c:RegisterEffect(e0)
--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetCondition(cm.atkcon)
	e2:SetValue(500)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
 --indes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetCondition(cm.atkcon)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e5)
--attack twice
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
	e6:SetValue(1)
	c:RegisterEffect(e6)
end
function cm.hspfilter(c,tp,sc)
	return  c:IsControler(tp) and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0 and c:IsCanBeFusionMaterial(sc,SUMMON_TYPE_SPECIAL)
end
function cm.ckfilter(c,mg,tc)
	return  c:IsType(TYPE_TUNER) or (c:IsSetCard(0x7e) and mg:IsContains(c))  and c:IsCanBeFusionMaterial(tc,SUMMON_TYPE_SPECIAL)
end
function cm.ckfilter2(c,tc)
	return  not c:IsType(TYPE_TUNER)  and c:IsCanBeFusionMaterial(tc,SUMMON_TYPE_SPECIAL)
end
function cm.check(g,mg1,mg2,tc)
	local res=0x0
	if g:IsExists(cm.ckfilter,1,nil,mg1,tc) then res=res+0x1 end
	if g:IsExists(cm.ckfilter2,1,nil,tc) then res=res+0x2 end
	return res==0x3 and Duel.GetLocationCountFromEx(tp,tp,g,tc)>0
end
function cm.ckfilter3(c)
	return  c:IsLevelAbove(1) and c:IsType(TYPE_MONSTER)
end
function cm.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg1=Duel.GetOverlayGroup(tp,LOCATION_MZONE,0):Filter(cm.ckfilter3,nil)
	local mg2=Duel.GetMatchingGroup(cm.ckfilter3,tp,LOCATION_MZONE,0,nil)
	local mg3=mg1
	mg3:Merge(mg2)
	local g=mg3:SelectSubGroup(tp,cm.check,false,2,2,mg1,mg2,c)
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_COST)
end

function cm.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x107f) and c:GetOverlayCount()>0
end
function cm.atkcon(e)
	return  Duel.IsExistingMatchingCard(cm.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end





