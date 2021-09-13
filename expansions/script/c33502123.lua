--自然色彩 双生黄薇玫
Duel.LoadScript("c33502100.lua")
local m=33502123
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,cm.matfilter,2,true)
	local e1=Suyuz.fusli_i(c,CATEGORY_SPECIAL_SUMMON,m)
	--HZ
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,3))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(Suyuz.gaincon(m))
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
	--summon success
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(cm.effcon2)
	e3:SetOperation(cm.spsumsuc)
	c:RegisterEffect(e3)
	if not BZo_p then
		BZo_p={}
		BZo_p["Effects"]={}
	end
	BZo_p["Effects"]["c33502123"]={}
end
function cm.matfilter(c)
	return c:IsSetCard(0x2a80) and c:IsLevel(9)
end
--e2
function cm.toh(c)
	return c:IsSetCard(0x2a80) and c:IsAbleToGraveAsCost() and BZo_p["Effects"]["c"..c:GetCode()]~=nil
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.toh,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.toh,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.op(e,tp)
	local c=e:GetHandler()
	local g=Duel.GetOperatedGroup()
	--disable
	Duel.RaiseEvent(g,EVENT_CUSTOM,e,nil,nil,nil,nil)
	
end
--e3
function cm.effcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function cm.spsumsuc(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetCode(EFFECT_CHANGE_RACE)
	e1:SetValue(RACE_PLANT)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end