--莱茵生命·医疗干员-白面鸮·脑肽啡
function c79029224.initial_effect(c)
	aux.EnablePendulumAttribute(c) 
	c:EnableReviveLimit()
	--splimit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0) 
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c79029224.splimit)
	c:RegisterEffect(e2) 
	--copy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,79029224)
	e1:SetCost(c79029224.cost)
	e1:SetTarget(c79029224.cotg)
	e1:SetOperation(c79029224.coop)
	c:RegisterEffect(e1)  
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c79029224.spcon)
	e1:SetTarget(c79029224.sptg)
	e1:SetCountLimit(1,79029224)
	e1:SetOperation(c79029224.spop)
	c:RegisterEffect(e1)
	--Recover
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetOperation(c79029224.reop)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_RECOVER)
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_DAMAGE)
	e4:SetCondition(c79029224.recon)
	e4:SetOperation(c79029224.reop2)
	c:RegisterEffect(e4) 
end
function c79029224.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0xa900) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c79029224.cofil(c)
	return c:IsFaceup() and c:IsAbleToDeckAsCost()
end
function c79029224.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029224.cofil,tp,LOCATION_EXTRA,0,3,nil) end
	local g=Duel.SelectMatchingCard(tp,c79029224.cofil,tp,LOCATION_EXTRA,0,3,3,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c79029224.filter1(c,e,tp)
	return c:IsSetCard(0xa900) and Duel.GetMZoneCount(tp,c)>0
	and Duel.IsExistingMatchingCard(c79029224.filter2,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA,0,1,nil,e,tp,c:GetCode())
end
function c79029224.filter2(c,e,tp,tcode)
	return c:IsSetCard(0xd90c) and c.assault_name==tcode and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c79029224.cotg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		return Duel.CheckReleaseGroup(tp,c79029224.filter1,1,nil,e,tp)
	end
	local rg=Duel.SelectReleaseGroup(tp,c79029224.filter1,1,1,nil,e,tp)
	e:SetLabel(rg:GetFirst():GetCode())
	Duel.Release(rg,REASON_COST)
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA)
end
function c79029224.coop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c79029224.filter2,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA,0,1,1,nil,e,tp,e:GetLabel()):GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)>0 then
		tc:CompleteProcedure()
		local fid=e:GetHandler():GetFieldID()
		tc:RegisterFlagEffect(79029224,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e3:SetCode(EVENT_PHASE+PHASE_END)
		e3:SetCountLimit(1)
		e3:SetLabel(fid)
		e3:SetLabelObject(tc)
		e3:SetCondition(c79029224.thcon1)
		e3:SetOperation(c79029224.thop1)
		Duel.RegisterEffect(e3,tp)
	end
end
function c79029224.thcon1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(79029224)==e:GetLabel() then
		return Duel.GetTurnPlayer()~=tp
	else
		e:Reset()
		return false
	end
end
function c79029224.thop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoDeck(tc,tp,nil,REASON_EFFECT)
end
function c79029224.sprfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsReleasable()
end
function c79029224.fselect(g,tp)
	return Duel.GetMZoneCount(tp,g)>0
end
function c79029224.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c79029224.sprfilter,tp,LOCATION_PZONE,0,nil)
	return g:CheckSubGroup(c79029224.fselect,2,2,tp)
end
function c79029224.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c79029224.sprfilter,tp,LOCATION_PZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=g:SelectSubGroup(tp,c79029224.fselect,true,2,2,tp)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c79029224.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Release(g,REASON_COST)
	Debug.Message("已将新数据汇编入程序组。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029224,0))
	g:DeleteGroup()
end
function c79029224.reop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,0,1,nil)
	local atk=g:GetSum(Card.GetAttack)
	Duel.Recover(tp,atk,REASON_EFFECT)
	Debug.Message("治疗模式。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029224,2))
end
function c79029224.recon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c79029224.reop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,ev*2,REASON_EFFECT)
	Debug.Message("法术单元充能中。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029224,1))
end










