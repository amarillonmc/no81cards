--此即人人
local m=25000403
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCondition(cm.condition)
	e1:SetOperation(cm.operation)
	Duel.RegisterEffect(e1,0)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(25000000)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCondition(cm.condition2)
	e2:SetOperation(cm.operation)
	Duel.RegisterEffect(e2,0)
end
function cm.condition(e,tp)
	return Duel.GetFlagEffect(tp,25000000)==0 and Duel.GetFlagEffect(1-tp,25000000)==0
end
function cm.condition2(e,tp)
	return Duel.GetFlagEffect(tp,25000000)>0 or Duel.GetFlagEffect(1-tp,25000000)>0
end
function cm.spcheck(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,true,true) and c:GetOriginalCode()==25000000
end
function cm.check(c)
	return c:GetOriginalCode()==m and c:IsAbleToExtra()
end
function cm.operation(e,tp) 
	local rg=Duel.GetMatchingGroup(cm.check,tp,LOCATION_PZONE,0,nil)
	if rg:GetCount()==0 or Duel.GetLocationCount(tp,LOCATION_MZONE)==0 or not Duel.IsExistingMatchingCard(cm.spcheck,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) then 
		return
	end
	local c=rg:Select(tp,1,1,nil):GetFirst()
	Duel.SendtoExtraP(c,tp,REASON_COST)
	getmetatable(e:GetHandler()).announce_filter={TYPE_EFFECT,OPCODE_ISTYPE,code,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND}
	local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=Duel.SelectMatchingCard(tp,cm.spcheck,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
		if Duel.SpecialSummonStep(sc,0,tp,tp,true,true,POS_FACEUP) then
			sc:CopyEffect(ac,RESET_EVENT+0x7e0000)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetValue(TYPE_MONSTER+TYPE_EFFECT)
			e1:SetReset(RESET_EVENT+0x7e0000)
			sc:RegisterEffect(e1)
		end
	end
end