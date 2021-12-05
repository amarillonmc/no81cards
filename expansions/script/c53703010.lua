local m=53703010
local cm=_G["c"..m]
cm.name="圆盘生物 诺巴"
function cm.initial_effect(c)
	aux.EnablePendulumAttribute(c,false)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x533),3,true)
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(m,0))
	e0:SetCategory(CATEGORY_TOGRAVE+CATEGORY_REMOVE)
	e0:SetRange(LOCATION_PZONE)
	e0:SetCountLimit(1)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetTarget(cm.target)
	e0:SetOperation(cm.activate)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetTarget(cm.pencon)
	e1:SetOperation(cm.penop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.tdcon)
	e2:SetOperation(cm.tdop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ADJUST)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetOperation(cm.op)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetOperation(cm.op2)
	c:RegisterEffect(e4)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,LOCATION_PZONE)
	if #g==0 then return end
	for tc in aux.Next(g) do
		tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD-RESET_LEAVE,0,0)
	end
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		if tc:GetFlagEffect(m)>0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_ADJUST)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e1:SetRange(0xff)
			e1:SetOperation(cm.op3)
			tc:RegisterEffect(e1,true)
		end
	end
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsLocation(LOCATION_MZONE) then
		e:GetHandler():ResetFlagEffect(m)
		e:Reset()
	end
end
function cm.filter(c)
	return c:IsAbleToRemove() or c:IsAbleToGrave()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>2 and Duel.GetDecktopGroup(tp,3):IsExists(cm.filter,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,0,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)<3 then return end
	Duel.ConfirmDecktop(1-tp,3)
	local g=Duel.GetDecktopGroup(1-tp,3)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:FilterSelect(tp,Card.IsAbleToGrave,1,1,nil)
		if #sg>0 then
			Duel.DisableShuffleCheck()
			Duel.SendtoGrave(sg,REASON_EFFECT)
			g:Sub(sg)
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		else
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
	end
end
function cm.penfilter(c)
	return c:IsSetCard(0x3533) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeckAsCost()
end
function cm.pencon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	local ph=Duel.GetCurrentPhase()
	return Duel.GetCurrentChain()==0 and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and Duel.IsExistingMatchingCard(cm.penfilter,tp,LOCATION_EXTRA,0,3,nil) and Duel.GetTurnPlayer()==tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function cm.penop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.penfilter,tp,LOCATION_EXTRA,0,3,3,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
	Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	e:GetHandler():CompleteProcedure()
end
function cm.tdcon(e,tp,eg,ep,ev,re,r,rp)
	if eg:GetCount()~=1 then return false end
	local tc=eg:GetFirst()
	return tc:IsFaceup() and tc:IsSetCard(0x3533) and tc:IsSummonPlayer(tp) and tc:GetFlagEffect(m)>0
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=eg:GetFirst()
	if c:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsImmuneToEffect(e) then
		c:SetCardTarget(tc)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetCondition(cm.rcon)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EFFECT_IMMUNE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetCondition(cm.rcon)
		e2:SetValue(cm.efilter)
		tc:RegisterEffect(e2)
	end
end
function cm.rcon(e)
	return e:GetOwner():IsHasCardTarget(e:GetHandler())
end
function cm.efilter(e,te)
	return te:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
