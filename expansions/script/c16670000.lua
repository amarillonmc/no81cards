--存在之间
it=it or {}
local cm=it
--无尽贪欲
function it.num(num,tp)
	if Duel.GetFlagEffect(tp,16602091)>0 then
        local num2=Duel.GetFlagEffect(tp,16602091)*5
        num=num-num2
        if num<0 then num=0	end
    end
	return num
end
--失落之魂
sl=sl or {}
function sl.fuslimit(e,c,sumtype)
	return sumtype==SUMMON_TYPE_FUSION
end
function sl.sc(c)
	local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(1)
		c:RegisterEffect(e1)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		e3:SetValue(sl.fuslimit)
		c:RegisterEffect(e3)
		local e5=e1:Clone()
		e5:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		c:RegisterEffect(e5)
		local e6=e1:Clone()
		e6:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		c:RegisterEffect(e6)
	return e1,e3,e5,e6
end
--里世界
ls=ls or {}

--泛用
function cm.GetEffectValue(e,...)
	local v=e:GetValue()
	if aux.GetValueType(v)=="function" then
		return v(e,...)
	else
		return v
	end
end
--
function cm.replace_function(of)
	return function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		local f=Duel.IsPlayerAffectedByEffect
		Duel.IsPlayerAffectedByEffect=cm.replace_play(f)
		local res=(not of or of(e,tp,eg,ep,ev,re,r,rp,chk,chkc))
		Duel.IsPlayerAffectedByEffect=f
		return res
	end
end
function cm.replace_play(f)
	return function(tp,code)
		local p=tp
		return f(p,code)
	end
end
--