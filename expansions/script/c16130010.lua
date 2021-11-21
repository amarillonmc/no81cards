--安布雷拉
local m=16130010
local cm=_G["c"..m]
Duel.LoadScript("c16199990.lua")
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ANNOUNCE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.sptg1)
	e1:SetOperation(cm.spop1)
	c:RegisterEffect(e1)
end
function cm.spfilter1(c,e,tp)
	return (rk.check(c,"BOW") or (c:IsRace(RACE_ZOMBIE) and Duel.GetFlagEffect(tp,m)>=1))
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end
function cm.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac=Duel.AnnounceCard(tp,TYPE_MONSTER,OPCODE_ISTYPE)
	e:SetLabel(ac)
end
function cm.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local code=e:GetLabel()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetLabel(code)
	e1:SetOperation(cm.op)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetLabelObject(e1)
	Duel.RegisterEffect(e1,tp)
end
function cm.filter(c,code)
	return c:IsCode(code) and c:IsFaceup()
end
function cm.op(e,tp,eg)
	local code=e:GetLabel()
	local se=e:GetLabelObject()
	local c=e:GetHandler()
	if eg:IsExists(cm.filter,1,nil,code) then
		local sg=eg:Filter(cm.filter,nil,code)
		for tc in aux.Next(sg) do
			local att=tc:GetOriginalAttribute()
			local race=tc:GetOriginalRace()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetTargetRange(0x7f,0x7f)
			e1:SetTarget(cm.crtg)
			e1:SetCode(EFFECT_CHANGE_RACE)
			e1:SetValue(RACE_ZOMBIE)
			e1:SetLabel(att)
			e1:SetReset(RESET_PHASE+PHASE_END,4)
			Duel.RegisterEffect(e1,tp)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetTargetRange(0x7f,0x7f)
			e2:SetTarget(cm.crtg1)
			e2:SetCode(EFFECT_CHANGE_RACE)
			e2:SetValue(RACE_ZOMBIE)
			e2:SetLabel(race)
			e2:SetReset(RESET_PHASE+PHASE_END,4)
			Duel.RegisterEffect(e2,tp)
		end
		if se then
			se:Reset()
		end
		e:Reset()
	end
end
function cm.crtg(e,c)
	local att=e:GetLabel()
	return c:IsAttribute(att)
end
function cm.crtg1(e,c)
	local race=e:GetLabel()
	return c:IsRace(race)
end 