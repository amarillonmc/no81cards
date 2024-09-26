local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1,1)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c,false)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(id)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MUST_USE_MZONE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCondition(s.frccon)
	e2:SetValue(s.frcval)
	c:RegisterEffect(e2)
	if not s.global_check then
		s.global_check=true
		local f1=Card.IsFaceup
		local f2=aux.PConditionFilter
		aux.PConditionFilter=function(...)
			Card.IsFaceup=function(sc)return f1(sc) or sc:IsHasEffect(id)end
			local res=f2(...)
			Card.IsFaceup=f1
			return res
		end
	end
end
function s.frccon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_PENDULUM)
end
function s.frcval(e,c,fp,rp,r)
	return e:GetHandler():GetLinkedZone() | 0x600060
end
