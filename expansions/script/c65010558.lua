--天知之翼骑士
function c65010558.initial_effect(c)
	 --set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65010558,0))
	e1:SetCategory(CATEGORY_LEAVE_GRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,65010558)
	e1:SetTarget(c65010558.settg)
	e1:SetOperation(c65010558.setop)
	c:RegisterEffect(e1)
	local e0=e1:Clone()
	e0:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e0)
	 --special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_REMOVE)
	e2:SetOperation(c65010558.spreg)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(65010558,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetCountLimit(1,65010559)
	e3:SetCondition(c65010558.spcon)
	e3:SetTarget(c65010558.sptg)
	e3:SetOperation(c65010558.spop)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
end
function c65010558.spreg(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if Duel.GetTurnPlayer()~=tp then
			e:SetLabel(Duel.GetTurnCount()+1)
			c:RegisterFlagEffect(65010558,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
		else
			e:SetLabel(Duel.GetTurnCount()+2)
			c:RegisterFlagEffect(65010558,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,3)
		end
end
function c65010558.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetLabel()==Duel.GetTurnCount() and e:GetHandler():GetFlagEffect(65010558)>0
end
function c65010558.tdfil(c)
	return c:IsCode(65010556) and c:IsAbleToDeck()
end
function c65010558.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65010558.tdfil,tp,LOCATION_REMOVED,0,1,nil) and e:GetHandler():IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	e:GetHandler():ResetFlagEffect(65010558)
end
function c65010558.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local g=Duel.SelectMatchingCard(tp,c65010558.tdfil,tp,LOCATION_REMOVED,0,1,1,nil)
		g:AddCard(c)
		if g:GetCount()==2 then
			Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		end
	end
end

function c65010558.setfilter(c)
	return c:IsCode(65010556) and c:IsSSetable()
end
function c65010558.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c65010558.setfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil) end
end
function c65010558.setop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c65010558.setfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SSet(tp,tc)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
	end
end