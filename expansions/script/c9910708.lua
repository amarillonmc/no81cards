--远古造物 利索维斯兽
require("expansions/script/c9910700")
function c9910708.initial_effect(c)
	--special summon
	Ygzw.AddSpProcedure(c,2)
	c:EnableReviveLimit()
	--flag
	Ygzw.AddTgFlag(c)
	--activate limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetValue(c9910708.aclimit)
	c:RegisterEffect(e1)
	--cannot attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCondition(c9910708.atkcon)
	e2:SetTarget(c9910708.atktg)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetOperation(c9910708.checkop2)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	if not c9910708.global_check then
		c9910708.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_BATTLED)
		ge1:SetOperation(c9910708.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c9910708.aclimit(e,re,tp)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and re:GetActivateLocation()==LOCATION_MZONE and rc:IsAttackPos()
		and rc:GetAttackedCount()==0 and rc:GetFlagEffect(9910708)==0
end
function c9910708.atkfilter(c)
	return c:GetAttackedCount()>0 and c:IsFaceup() and c:GetFlagEffect(9910708)==0
end
function c9910708.checkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9910708.atkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		tc:RegisterFlagEffect(9910708,RESET_EVENT+RESETS_STANDARD,0,1)
		tc=g:GetNext()
	end
end
function c9910708.atkcon(e)
	return e:GetHandler():GetFlagEffect(9910708)~=0
end
function c9910708.atktg(e,c)
	return c:GetFieldID()~=e:GetLabel()
end
function c9910708.checkop2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(9910708)~=0 then return end
	local fid=eg:GetFirst():GetFieldID()
	e:GetHandler():RegisterFlagEffect(9910708,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	e:GetLabelObject():SetLabel(fid)
end
