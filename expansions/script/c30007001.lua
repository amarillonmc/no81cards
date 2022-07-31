--电子暗黑爆破 
local cm,m,ot=GetID()  
function cm.initial_effect(c)
	--Effect 1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--Effect 2 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY) 
	e2:SetCondition(cm.reccon)
	e2:SetCost(cm.reccost)
	e2:SetTarget(cm.rectg)
	e2:SetOperation(cm.recop)
	c:RegisterEffect(e2) 
end
--Effect 1
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function cm.desfilter(c,sc)
	return  c~=sc
end
function cm.cfilter(c,sc,tp)
	return c:IsFaceup() and c:GetEquipTarget() and c:GetEquipTarget():IsRace(RACE_MACHINE) 
		and c:IsAbleToGraveAsCost()
		and Duel.IsExistingTarget(cm.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c,sc)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local sc=e:GetHandler()
	if chkc then return chkc:IsOnField() and chkc~=sc end
	if chk==0 then
		if e:GetLabel()==1 then
			e:SetLabel(0)
			return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_SZONE,0,1,nil,sc,tp)
		else
			return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,sc)
		end
	end
	if e:GetLabel()==1 then
		e:SetLabel(0)
		local sg=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_SZONE,0,1,1,nil,sc,tp)
		Duel.SendtoGrave(sg,REASON_COST)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,2,sc)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if Duel.Destroy(dg,REASON_EFFECT)~=0 then
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.actfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,tp)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0))  then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
			local sg=g:Select(tp,1,1,nil)
			local sc=sg:GetFirst()
			Duel.MoveToField(sc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
			local te=sc:GetActivateEffect()
			te:UseCountLimit(tp,1,true)
			local tep=sc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
			Duel.RaiseEvent(sc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
		end
	end
end
function cm.actfilter(c,tp)
	return c:IsType(TYPE_FIELD) and c:IsCode(44352516) and c:GetActivateEffect():IsActivatable(tp,true,true)
end
--Effect 2
function cm.eqc(c,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_SZONE) and c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousEquipTarget() and c:GetPreviousEquipTarget():IsRace(RACE_MACHINE)
		and bit.band(c:GetPreviousTypeOnField(),TYPE_EQUIP)~=0
end
function cm.reccon(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:FilterCount(cm.eqc,nil,tp)
	return ct>0
end
function cm.reccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),tp,SEQ_DECKSHUFFLE,REASON_COST)
end
function cm.filter(c)
	return c:IsSetCard(0x4093) and c:IsFaceup() and c:IsType(TYPE_EFFECT) and c:GetAttack()>0
end
function cm.rectg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,nil)
	local atk=g:GetFirst():GetAttack()
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,atk)
end
function cm.recop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:GetAttack()>0 then
		Duel.Recover(tp,tc:GetAttack(),REASON_EFFECT)
	end
end
