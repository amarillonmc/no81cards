--苍岚业龙 灾漩逆
local m=40009724
local cm=_G["c"..m]
cm.named_with_Reverse=1
function c40009724.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x6f1d),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	c:SetUniqueOnField(1,0,40009724)	
	--add type
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c40009724.tncon)
	e1:SetOperation(c40009724.tnop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(c40009724.valcheck)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--disable
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(40009724,0))
	e3:SetCategory(CATEGORY_NEGATE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c40009724.discon)
	e3:SetCost(c40009724.cost)
	e3:SetTarget(c40009724.distg)
	e3:SetOperation(c40009724.disop)
	c:RegisterEffect(e3)
end
function c40009724.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsCode,1,nil,40009070) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function c40009724.tncon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) and e:GetLabel()==1
end
function c40009724.tnop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(600)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	c:RegisterEffect(e3)
end
function c40009724.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and rp==1-tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function c40009724.cfilter(c,tp)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c40009724.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40009724.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,c40009724.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
end
function c40009724.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:SetCategory(CATEGORY_NEGATE)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)==LOCATION_MZONE and re:GetHandler():IsRelateToEffect(re)
		and not re:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then
		e:SetCategory(CATEGORY_NEGATE+CATEGORY_POSITION)
		Duel.SetOperationInfo(0,CATEGORY_POSITION,eg,1,0,0)
	end
end
function c40009724.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)==LOCATION_MZONE
		and re:GetHandler():IsRelateToEffect(re) and not re:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then
		Duel.BreakEffect()
		if Duel.ChangePosition(re:GetHandler(),POS_FACEDOWN_DEFENSE)~=0 then
			local og=Duel.GetOperatedGroup()
			local tc=og:GetFirst()
			while tc do
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
				tc=og:GetNext()
			end
		end
	end
end




