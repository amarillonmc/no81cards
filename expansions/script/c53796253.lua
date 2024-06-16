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
