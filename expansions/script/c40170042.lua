--执行官-黑魔术师
local s,id=GetID()
function s.initial_effect(c)
	c:SetUniqueOnField(1,0,id)
	aux.AddCodeList(c,46986414)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,46986414,aux.FilterBoolFunction(Card.IsRace,RACE_SPELLCASTER),1,true,true)	
	aux.AddContactFusionProcedure(c,aux.FilterBoolFunction(Card.IsReleasable,REASON_SPSUMMON),LOCATION_MZONE,0,Duel.Release,REASON_SPSUMMON+REASON_MATERIAL)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(s.aclimit)
	c:RegisterEffect(e0)
	--lock
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,1)
	e1:SetValue(s.fuslimit)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(s.damop)
	c:RegisterEffect(e2)
end
function s.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or aux.fuslimit(e,se,sp,st)
end
function s.aclimit(e,re,tp)
	local rc=re:GetHandler()
	return not (re:IsActiveType(TYPE_SPELL) and rc:GetOriginalType()==TYPE_SPELL and aux.IsCodeListed(rc,46986414))
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetActiveType()==TYPE_SPELL and re:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.Damage(1-tp,800,REASON_EFFECT)
	end
end