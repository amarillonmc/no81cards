--胧之渺翳 朱利安龙
function c9911319.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,9911319)
	e1:SetCost(c9911319.setcost)
	e1:SetTarget(c9911319.settg)
	e1:SetOperation(c9911319.setop)
	c:RegisterEffect(e1)
end
function c9911319.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c9911319.pfilter(c,tp)
	return c:IsType(TYPE_CONTINUOUS) and c:IsSetCard(0xa958) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c9911319.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c9911319.pfilter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function c9911319.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local fid=c:GetFieldID()
	c:RegisterFlagEffect(9911319,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2,fid)
	local g=Group.FromCards(c)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local tc=Duel.SelectMatchingCard(tp,c9911319.pfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
		if tc and Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
			tc:RegisterFlagEffect(9911319,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2,fid)
			g:AddCard(tc)
		end
	end
	g:KeepAlive()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	if Duel.GetCurrentPhase()==PHASE_STANDBY then
		e1:SetLabel(fid,Duel.GetTurnCount())
		e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
	else
		e1:SetLabel(fid,0)
		e1:SetReset(RESET_PHASE+PHASE_STANDBY)
	end
	e1:SetLabelObject(g)
	e1:SetCondition(c9911319.descon)
	e1:SetOperation(c9911319.desop)
	Duel.RegisterEffect(e1,tp)
end
function c9911319.desfilter(c,fid)
	return c:GetFlagEffectLabel(9911319)==fid
end
function c9911319.descon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local lab1,lab2=e:GetLabel()
	if not g:IsExists(c9911319.desfilter,1,nil,lab1) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return Duel.GetTurnCount()~=lab2 end
end
function c9911319.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local lab1,lab2=e:GetLabel()
	local sg=g:Filter(c9911319.desfilter,nil,lab1)
	g:DeleteGroup()
	Duel.Destroy(sg,REASON_EFFECT)
end
