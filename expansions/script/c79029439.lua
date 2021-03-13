--让我康康！！！
function c79029439.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,79029439)
	e1:SetTarget(c79029439.target)
	e1:SetOperation(c79029439.activate)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,09029439)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c79029439.destg)
	e2:SetOperation(c79029439.desop)
	c:RegisterEffect(e2)
end
function c79029439.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
end   
function c79029439.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetTargetRange(0,LOCATION_HAND)
	Duel.RegisterEffect(e1,tp)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCountLimit(1)
	e2:SetLabelObject(e1)
	e2:SetCondition(c79029439.sdbcon)
	e2:SetOperation(c79029439.sdbop)
	Duel.RegisterEffect(e2,tp)
end   
function c79029439.sdbcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp   
end
function c79029439.tgfil(c)
	return c:IsSetCard(0xa900) and c:IsAbleToGrave()
end
function c79029439.sdbop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c79029439.tgfil,tp,LOCATION_HAND,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(79029439,0)) then 
	dg=Duel.SelectMatchingCard(tp,c79029439.tgfil,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(dg,REASON_EFFECT)
	else
	e:GetLabelObject():Reset()
	e:Reset()
	end
end
function c79029439.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_EXTRA,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c79029439.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	if e:GetHandler():IsRelateToEffect(e) and Duel.Destroy(e:GetHandler(),REASON_EFFECT)>0 and g:GetCount()>0 then
		Duel.BreakEffect()
		Duel.ConfirmCards(tp,g)
		local tc=g:FilterSelect(tp,nil,1,1,nil):GetFirst()
	local flag=0
	if tc:IsType(TYPE_RITUAL) then flag=bit.bor(flag,TYPE_RITUAL) end
	if tc:IsType(TYPE_FUSION) then flag=bit.bor(flag,TYPE_FUSION) end
	if tc:IsType(TYPE_SYNCHRO) then flag=bit.bor(flag,TYPE_SYNCHRO) end
	if tc:IsType(TYPE_XYZ) then flag=bit.bor(flag,TYPE_XYZ) end
	if tc:IsType(TYPE_PENDULUM) then flag=bit.bor(flag,TYPE_PENDULUM) end
	if tc:IsType(TYPE_LINK) then flag=bit.bor(flag,TYPE_LINK) end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetLabel(flag)
	e1:SetTargetRange(1,1)
	e1:SetTarget(c79029439.sumlimit)
	e1:SetReset(RESET_PHASE+PHASE_END,2)	
		Duel.ShuffleExtra(1-tp)
	end
end
function c79029439.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return c:IsType(e:GetLabel())
end









