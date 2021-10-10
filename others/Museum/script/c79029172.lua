--雷神工业·医疗干员-Lancet-2
function c79029172.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--splimit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetRange(LOCATION_PZONE)
	e0:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e0:SetTargetRange(1,0)
	e0:SetTarget(c79029172.splimit)
	c:RegisterEffect(e0)
	--change
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,79029172)
	e1:SetTarget(c79029172.chtg)
	e1:SetOperation(c79029172.chop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCondition(c79029172.spcon)
	e2:SetOperation(c79029172.spop)
	c:RegisterEffect(e2)
	--scale 
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c79029172.sltg)
	e3:SetOperation(c79029172.slop)
	c:RegisterEffect(e3)
end
function c79029172.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0xa900) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c79029172.ckfil(c,e,tp)
	return c:IsSetCard(0xa900) and c:IsType(TYPE_PENDULUM) 
end
function c79029172.chtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(c79029172.ckfil,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	local tc=Duel.SelectTarget(tp,c79029172.ckfil,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c79029172.chop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then  
	Debug.Message("紧急治疗启动！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029172,1))
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function c79029172.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetMatchingGroupCount(nil,tp,LOCATION_PZONE,0,nil)<2 then
	return false end
	local lsc=Duel.GetFieldCard(tp,LOCATION_PZONE,0):GetLeftScale()
	local rsc=Duel.GetFieldCard(tp,LOCATION_PZONE,1):GetRightScale()
	if lsc>rsc then lsc,rsc=rsc,lsc end
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and 1>lsc and 1<rsc 
end
function c79029172.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Debug.Message("请小心应战！紧急治疗的任务请放心交给我。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029172,2))
end
function c79029172.sltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c79029172.pefil,tp,LOCATION_PZONE,0,1,nil) end
	local tc=Duel.SelectTarget(tp,c79029172.pefil,tp,LOCATION_PZONE,0,1,1,nil)
end
function c79029172.slop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then 
	local x=Duel.AnnounceNumber(tp,0,9)
	--scale
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_CHANGE_LSCALE)
	e3:SetRange(LOCATION_PZONE)
	e3:SetValue(x)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CHANGE_RSCALE)
	tc:RegisterEffect(e4)
	Debug.Message("开始治疗。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029172,0))
	end
end






