--皇庭学院的教官
local m=21196020
local cm=_G["c"..m]
function cm.initial_effect(c)
	if not imperial_court then
		imperial_court=true
		Duel.LoadScript("c21196001.lua")
		in_count.card = c
		local ce1=Effect.CreateEffect(c)
		ce1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ce1:SetCode(EVENT_PHASE+PHASE_END)
		ce1:SetCountLimit(1)
		ce1:SetOperation(function(e)
			for tp = 0,1 do
				if not Duel.IsPlayerAffectedByEffect(tp,21196000) then
					in_count.reset(tp)
				end
			end
		end)
		Duel.RegisterEffect(ce1,0)
	end
	c:EnableReviveLimit()
	aux.AddSynchroMixProcedure(c,cm.mat1,nil,nil,cm.mat2,1,99)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.con)
	e1:SetOperation(cm.op)
	e1:SetValue(SUMMON_VALUE_SELF)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_HAND,0)
	e2:SetTarget(cm.tg2)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
end
function cm.mat1(c,syncard)
	return c:IsTuner(syncard) and c:IsRace(RACE_SPELLCASTER)
end
function cm.mat2(c)
	return c:IsSetCard(0x5919)
end
function cm.con(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return in_count[tp] >= 1 and Duel.GetLocationCount(tp,4)>0
end
function cm.op(e,tp,eg,ep,ev,re,r,rp,c)
	in_count.add(tp,-1)
end
function cm.tg2(e,c)
	return c:IsSetCard(0x5919) and c:IsType(1)
end