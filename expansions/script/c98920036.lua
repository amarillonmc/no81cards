--科技属 进步战士
function c98920036.initial_effect(c)
		--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_SYNCHRO),aux.NonTuner(nil),1)
	c:EnableReviveLimit()   
 --Decrease Atk
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetValue(c98920036.atkval)
	c:RegisterEffect(e3)   
 --negate activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920036,1))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(c98920036.tgcon)
	e2:SetTarget(c98920036.target)
	e2:SetOperation(c98920036.operation)
	c:RegisterEffect(e2)
end
function c98920036.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x27)
end
function c98920036.atkval(e)
	local g=Duel.GetMatchingGroup(c98920036.atkfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil)
	return g:GetClassCount(Card.GetCode)*-100
end
function c98920036.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and re:GetActivateLocation()==LOCATION_MZONE 
end
function c98920036.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c98920036.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)>0
		and Duel.SelectYesNo(tp,aux.Stringid(98920036,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local tg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
			local rc=tg:GetFirst()
			if Duel.Remove(rc,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
				rc:RegisterFlagEffect(98920036,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_PHASE+PHASE_END)
				e1:SetReset(RESET_PHASE+PHASE_END,2)
				e1:SetLabelObject(rc)
				e1:SetCountLimit(1)
				e1:SetCondition(c98920036.retcon)
				e1:SetOperation(c98920036.retop)			   
				e1:SetLabel(Duel.GetTurnCount())
				Duel.RegisterEffect(e1,tp)
			end
	end
end
function c98920036.retcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return Duel.GetTurnCount()~=e:GetLabel() and tc:GetFlagEffect(98920036)~=0
end
function c98920036.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end