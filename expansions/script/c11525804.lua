--异响鸣的孤奏
function c11525804.initial_effect(c)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(c11525804.handcon)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER+CATEGORY_REMOVE+CATEGORY_DAMAGE+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1,11535804)
	e1:SetCondition(c11525804.condition)
	e1:SetOperation(c11525804.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetCountLimit(1,11545804)
	e2:SetCost(c11525804.cpcost)
	e2:SetTarget(c11525804.cptg)
	e2:SetOperation(c11525804.cpop)
	c:RegisterEffect(e2)
end
function c11525804.hcfilter(c)
	return c:IsSetCard(0x1a3) and c:IsType(TYPE_LINK) and c:IsFaceup()
end
function c11525804.handcon(e)
	return Duel.IsExistingMatchingCard(c11525804.hcfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c11525804.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x1a3) and c:GetOriginalType()&TYPE_MONSTER>0
end
function c11525804.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c11525804.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c11525804.rmfilter(c)
	return c:IsAbleToRemove() and c:IsSetCard(0x1a3) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c11525804.activate(e,tp,eg,ep,ev,re,r,rp,op)
	if op==nil and not c11525804.condition(e,tp) then return end
	local c=e:GetHandler()
	if op==nil then
		op=aux.SelectFromOptions(tp,
			{true,aux.Stringid(11525803,0)},
			{true,aux.Stringid(11525803,1)})
	end
	if op&1>0 and Duel.Recover(tp,500,REASON_EFFECT)>0 then
		if Duel.IsExistingMatchingCard(c11525804.rmfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(11525804,2) ) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local rc=Duel.SelectMatchingCard(tp,c11525804.rmfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
			Duel.Remove(rc,POS_FACEUP,REASON_EFFECT)
		end
	end
	if op&2>0 and Duel.Damage(tp,500,REASON_EFFECT)>0 then
		if Duel.IsCanRemoveCounter(tp,1,0,0x6a,1,REASON_EFFECT) and Duel.IsExistingMatchingCard(Card.IsAbleToGrave(),tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then
			local ct=Duel.GetCounter(tp,LOCATION_ONFIELD,0,0x6a)
			local gc=3
			if ct>0 and ct<3 then gc=ct end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local tg=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave(),tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,gc,nil)
			local tgc=tg:GetCount()
			Duel.RemoveCounter(tp,1,0,0x6a,tgc,REASON_EFFECT)
			Duel.HintSelection(tg)
			Duel.SendtoGrave(tg,REASON_EFFECT)
		end
	end
end

function c11525804.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c11525804.cpfilter(c)
	return c:IsSetCard(0x1a3) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:CheckActivateEffect(false,true,false)~=nil
end
function c11525804.cptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c11525804.cpfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,e:GetHandler())
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local g=Duel.SelectMatchingCard(tp,c11525804.cpfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,e:GetHandler())
	Duel.HintSelection(g)
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(false,true,true)
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
end
function c11525804.cpop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if te then
		e:SetLabelObject(te:GetLabelObject())
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
	end
end