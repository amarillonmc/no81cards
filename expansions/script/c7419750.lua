--玉莲帮
local m=7419750
local cm=_G["c"..m]
function cm.Qingyu(c)
	local m=_G["c"..c:GetCode()]
	return (m and m.named_with_Qingyu) or c:IsCode(7419700)
end

function cm.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(cm.splimit)
	c:RegisterEffect(e1)
	--adjust
	local e01=Effect.CreateEffect(c)
	e01:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e01:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e01:SetCode(EVENT_ADJUST)
	e01:SetRange(0xff)
	e01:SetCountLimit(1,m+EFFECT_COUNT_CODE_DUEL)
	e01:SetOperation(cm.adjustop)
	c:RegisterEffect(e01)
end
function cm.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_LINK)==0 
end
function cm.adjustop(e,tp,eg,ep,ev,re,r,rp)
	--
	if not cm.global_effect then
		cm.global_effect=true
		local c=e:GetHandler()
		Duel.ConfirmCards(0,c)
		Duel.Hint(HINT_CARD,0,m)
		local atkc=Duel.GetRegistryValue("Jade_Lotus_Match_Count")
		if atkc then
			local atkc=tonumber(Duel.GetRegistryValue("Jade_Lotus_Match_Count"))
			if atkc>0 then
				for i=0,atkc do
					Duel.RegisterFlagEffect(tp,7419700,0,0,1)
					local e2=Effect.CreateEffect(c)
					e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
					e2:SetCode(EVENT_SPSUMMON_SUCCESS)
					e2:SetOperation(cm.sucop)
					Duel.RegisterEffect(e2,tp)
				end
			end
		else
			Duel.SetRegistryValue("Jade_Lotus_Match_Count",0)
		end
		local DRegisterFlagEffect=Duel.RegisterFlagEffect
		Duel.RegisterFlagEffect=function(pl,code,reset_flag,property,reset_count,label)
			if code==7419700 then
				local atkc=tonumber(Duel.GetRegistryValue("Jade_Lotus_Match_Count"))+1
				Duel.SetRegistryValue("Jade_Lotus_Match_Count",atkc)
			end
			local val=Duel.GetFlagEffect(pl,7419700)
			return DRegisterFlagEffect(pl,code,reset_flag,property,reset_count,label)
		end
	end
	e:Reset()
end
function cm.sucfilter(c,tp)
	return c:IsCode(7419700)
end
function cm.sucop(e,tp,eg,ep,ev,re,r,rp)
	local tg=eg:Filter(cm.sucfilter,nil,tp)
	if tg:GetCount()>0 then
		local tc=tg:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_BASE_ATTACK)
			e1:SetValue(tc:GetBaseAttack()+500)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_SET_BASE_DEFENSE)
			e2:SetValue(tc:GetBaseDefense()+500)
			tc:RegisterEffect(e2)
			local e3=e1:Clone()
			e3:SetCode(EFFECT_UPDATE_LEVEL)
			e3:SetValue(1)
			tc:RegisterEffect(e3)
			tc=tg:GetNext()
		end
	end
end
