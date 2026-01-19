--女神之令-授
local s,id,o=GetID()
function s.initial_effect(c)
	--①：仪式召唤 (卡组/墓地/除外)
	local e1=aux.AddRitualProcGreater2(c,s.filter,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_DECK,nil,nil,true)
	c:RegisterEffect(e1)

	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(s.reptg)
	e2:SetValue(s.repval)
	e2:SetOperation(s.repop)
	c:RegisterEffect(e2)
end

-- === 效果①：仪式召唤 ===
function s.filter(c,e,tp)
	return c:IsSetCard(0x611)
end

function s.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x611)
		and c:IsOnField() and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(s.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function s.repval(e,c)
	return s.repfilter(c,e:GetHandlerPlayer())
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end