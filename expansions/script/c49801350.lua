--炎煌号 阿波罗斯特
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--material
	aux.AddXyzProcedure(c,nil,9,2,s.mfilter,aux.Stringid(id,0),2,s.altop)
	--Atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetCondition(s.atkcon)
	e1:SetTarget(s.atktg)
	e1:SetValue(s.atkvalue)
	c:RegisterEffect(e1)
	
	--cannot spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.matcon)
	e2:SetOperation(s.matop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(id+10000)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(1,1)
	c:RegisterEffect(e3)
end
function s.mfilter(c,e,tp)
	return c:GetAttack()>c:GetBaseAttack()
end
function s.altop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,id+10000)==0 and Duel.GetMatchingGroupCount(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)==1 end
	Duel.RegisterFlagEffect(tp,id+10000,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function s.atkcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)>=Duel.GetFieldGroupCount(tp,0,LOCATION_EXTRA)
end
function s.atktg(e,c)
	return c~=e:GetHandler()
end
function s.atkvalue(e,c)
	return e:GetHandler():GetOverlayCount()*100
end
function s.matfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:GetFlagEffect(id+10000)==0
end
function s.matcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.matfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function s.matop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.matfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	for tc in aux.Next(g) do
		tc:RegisterFlagEffect(id+10000,RESET_EVENT+RESETS_STANDARD,0,1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_SINGLE_RANGE)
		e2:SetValue(s.matlimit)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2,true)
		local e3=e2:Clone()
		e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		e3:SetValue(s.fuslimit)
		tc:RegisterEffect(e3,true)
		local e4=e2:Clone()
		e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		tc:RegisterEffect(e4,true)
		local e5=e2:Clone()
		e5:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		tc:RegisterEffect(e5,true)
	end
end
function s.matlimit(e,c)
	local tp=e:GetHandler():GetControler()
	--Debug.Message(e:GetHandler():GetAttack())
	--Debug.Message(c:GetAttack())
	return Duel.IsPlayerAffectedByEffect(tp,id+10000) and e:GetHandler():GetAttack()>c:GetAttack()
end
function s.fuslimit(e,c,st)
	return Duel.IsPlayerAffectedByEffect(tp,id+10000) and e:GetHandler():GetAttack()>c:GetAttack() and st==SUMMON_TYPE_FUSION
end