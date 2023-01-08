--虚幻之地 帕西菲斯
function c98910025.initial_effect(c)	
	aux.AddCodeList(c,22702055)
		--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c98910025.handcon)
	c:RegisterEffect(e2)  
  --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c98910025.condition)
	e1:SetCost(c98910025.cost)
	e1:SetTarget(c98910025.target)
	e1:SetOperation(c98910025.operation)
	c:RegisterEffect(e1)	
--equip
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98910025,0))
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c98910025.eqtg)
	e3:SetOperation(c98910025.eqop)
	c:RegisterEffect(e3)
end
function c98910025.handcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_ONFIELD,0)==0 or Duel.IsEnvironment(22702055)
end
function c98910025.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsType(TYPE_EFFECT)
end
function c98910025.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(m,tp,ACTIVITY_SUMMON)==0
		and Duel.GetCustomActivityCount(m,tp,ACTIVITY_SPSUMMON)==0 
		and Duel.GetCustomActivityCount(m,tp,ACTIVITY_FLIPSUMMON)==0 and Duel.GetCustomActivityCount(m,tp,ACTIVITY_CHAIN)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c98910025.sumlimit)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e2,tp)
	local e4=Effect.CreateEffect(e:GetHandler())
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetTargetRange(1,0)
	e4:SetValue(c98910025.aclimit)
	e4:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e4,tp)
end
function c98910025.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER)
end
function c98910025.filter(c,tp)
		return c:IsCode(22702055) and (c:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0)
		and c:GetActivateEffect() and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function c98910025.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c98910025.spcfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c98910025.spcfilter(c)
	return c:IsType(TYPE_EFFECT) and c:IsFaceup()
end
function c98910025.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98910025.filter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,nil,tp) end
	if not Duel.CheckPhaseActivity() then e:SetLabel(1) else e:SetLabel(0) end
end
function c98910025.operation(e,tp,eg,ep,ev,re,r,rp)
	local b=Duel.IsEnvironment(22702055,tp,LOCATION_FZONE)
	if b and Duel.SelectYesNo(tp,aux.Stringid(98910025,0)) then 
		if not c98910025.rmtg(e,tp,eg,ep,ev,re,r,rp,0) then return end   
		 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		 local g1=Duel.SelectMatchingCard(tp,c98910025.rmfilter,tp,LOCATION_MZONE,0,1,1,nil)
		 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		 local g2=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil,tp)
		 g1:Merge(g2)
		 Duel.HintSelection(g1)
		 Duel.Remove(g1,POS_FACEUP,REASON_EFFECT)
	else
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(98910025,0))
		if e:GetLabel()==1 then Duel.RegisterFlagEffect(tp,98910025,RESET_CHAIN,0,1) end
		local tc=Duel.SelectMatchingCard(tp,c98910025.filter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
		Duel.ResetFlagEffect(tp,98910025)
		if tc then
			local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
			Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
			local te=tc:GetActivateEffect()
			te:UseCountLimit(tp,1,true)
			local tep=tc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
			Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
		end
	end
end
function c98910025.rmfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsType(TYPE_NORMAL) and c:IsFaceup() and c:IsAbleToRemove()
end
function c98910025.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98910025.rmfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil,tp) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,PLAYER_ALL,LOCATION_ONFIELD)
end
function c98910025.efilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_NORMAL)
		and Duel.IsExistingMatchingCard(c98910025.eqfilter,tp,LOCATION_DECK,0,1,nil,c)
end
function c98910025.eqfilter(c,tc)
	return c:IsType(TYPE_EQUIP) and c:IsSetCard(0xfa) and c:CheckEquipTarget(tc)
end
function c98910025.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c98910025.efilter(chkc,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c98910025.efilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c98910025.efilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function c98910025.eqop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c98910025.eqfilter),tp,LOCATION_DECK,0,1,1,nil,tc)
	local eq=g:GetFirst()
	if eq then
		Duel.Equip(tp,eq,tc)
	end
end