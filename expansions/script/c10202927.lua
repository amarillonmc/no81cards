--海啸之天气模样
function c10202927.initial_effect(c)
	aux.AddCodeList(c,22702055)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c10202927.activate)
	c:RegisterEffect(e1)
	--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c10202927.tg2)
	e3:SetValue(c10202927.filter2)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10202927,2))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_BATTLE_START)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c10202927.con3)
	e4:SetTarget(c10202927.tg3)
	e4:SetOperation(c10202927.op3)
	c:RegisterEffect(e4)
end
--1
function c10202927.filter1(c,tp)
	return c:IsCode(22702055) and (c:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0)
		and c:GetActivateEffect() and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function c10202927.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c10202927.filter1),tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,nil,tp)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(10202927,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10202927.filter1),tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil,tp):GetFirst()
		if tc then
			local field=tc:IsType(TYPE_FIELD)
			if field then
				local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
				if fc then
					Duel.SendtoGrave(fc,REASON_RULE)
					Duel.BreakEffect()
				end
				Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
			else
				Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			end
			local te=tc:GetActivateEffect()
			te:UseCountLimit(tp,1,true)
			local tep=tc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
			if field then
				Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
			end
		end
	end
end
--2
function c10202927.tg2(e,c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER)
end
function c10202927.filter2(e,re,rp)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and rc:IsControler(1-e:GetHandlerPlayer()) and rc:IsNonAttribute(ATTRIBUTE_WATER)
end
--3
function c10202927.con3(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsEnvironment(22702055) then return false end
	local tc=Duel.GetAttacker()
	local bc=Duel.GetAttackTarget()
	if not bc then return false end
	if tc:IsControler(1-tp) then tc,bc=bc,tc end
	if tc:IsFaceup() and tc:GetOriginalLevel()>=0 and tc:IsAttribute(ATTRIBUTE_WATER) then
		e:SetLabelObject(bc)
		return true
	else return false end
end
function c10202927.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local bc=e:GetLabelObject()
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,bc,1,0,0)
end
function c10202927.op3(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetLabelObject()
	if bc:IsRelateToBattle() then
		Duel.Destroy(bc,REASON_EFFECT)
	end
end