--同盟的凯歌
local s,id,o=GetID()
function s.initial_effect(c)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_ACTIVATE)
	e5:SetCode(EVENT_BATTLE_DESTROYING)
	e5:SetCountLimit(1,id)
	e5:SetCondition(s.descon)
	e5:SetOperation(s.desop)
	c:RegisterEffect(e5)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(s.reptg)
	e2:SetValue(s.repval)
	e2:SetOperation(s.repop)
	c:RegisterEffect(e2)
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	local rc=eg:GetFirst()
	return rc:IsRelateToBattle() and rc:IsSetCard(0xc31) and rc:IsFaceup() and rc:IsControler(tp)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local ec=eg:GetFirst()
	if not ec:IsRelateToBattle() then return end
	local bc=ec:GetBattleTarget()
	if bc and bc:IsControler(1-tp) and bc:IsStatus(STATUS_BATTLE_DESTROYED) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_SUMMON)
		e1:SetTargetRange(0,1)
		e1:SetLabelObject(ec)
		e1:SetTarget(s.splimit)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		Duel.RegisterEffect(e2,tp)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CANNOT_MSET)
		Duel.RegisterEffect(e3,tp)
	end
end
function s.splimit(e,c)
	local ec=e:GetLabelObject()
	return c:IsAttribute(ec:GetAttribute()) or c:GetType()&ec:GetType()&(TYPE_RITUAL+TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_PENDULUM+TYPE_LINK)>0
end
function s.anfilter(c)
	return c:IsType(TYPE_LINK) and c:IsSetCard(0xc31) and c:IsFaceup()
end
function s.anfilter2(c,tc)
	return c:GetLinkedGroup():IsContains(tc)
end
function s.repfilter(c,tp,g)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE) and g:IsExists(s.anfilter2,1,nil,c)
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(s.anfilter,e:GetHandlerPlayer(),LOCATION_MZONE,LOCATION_MZONE,nil)
		return e:GetHandler():IsAbleToRemove() and eg:IsExists(s.repfilter,1,nil,tp,g)
	end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function s.repval(e,c)
	local g=Duel.GetMatchingGroup(s.anfilter,e:GetHandlerPlayer(),LOCATION_MZONE,LOCATION_MZONE,nil)
	return s.repfilter(c,e:GetHandlerPlayer(),g)
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
