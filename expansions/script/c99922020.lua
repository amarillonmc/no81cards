--区间窃取灵·伤疤劣化者
local s,id,o=GetID()
function s.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,s.matfilter,1,1)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(s.atktg)
	e1:SetValue(s.atkval)
	c:RegisterEffect(e1)	
	--act in set turn
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_SZONE,0)
	e3:SetTarget(s.etarget)
	c:RegisterEffect(e3)	
end
function s.matfilter(c,lc,sumtype,tp)
	return c:IsLevelBelow(4) and c:IsLinkSetCard(0x70ab)
end
function s.atktg(e,c)
	return c~=e:GetHandler() and not e:GetHandler():GetLinkedGroup():IsContains(c)
end
function s.etarget(e,c)
	return c:GetType()==TYPE_TRAP and c:IsSetCard(0x70ab)
end
function s.atkval(e,c)
	return -e:GetHandler():GetAttack()
end