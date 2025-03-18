--幽兰之爪 莉拉·德西亚斯
function c75011026.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x75e),5,2,c75011026.ovfilter,aux.Stringid(75011026,0),2,c75011026.xyzop)
	c:EnableReviveLimit()
	--select
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMING_END)
	e1:SetCondition(c75011026.condition)
	e1:SetCost(c75011026.cost)
	e1:SetOperation(c75011026.operation)
	c:RegisterEffect(e1)
	--summon reg
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCondition(c75011026.regcon)
	e2:SetOperation(c75011026.regop)
	c:RegisterEffect(e2)
	--actlimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,1)
	e3:SetValue(1)
	e3:SetCondition(c75011026.actcon)
	c:RegisterEffect(e3)
	--atk
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c75011026.atkcon)
	e4:SetValue(c75011026.atkval)
	c:RegisterEffect(e4)
	if not c75011026.global_check then
		c75011026.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DAMAGE)
		ge1:SetOperation(c75011026.chkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c75011026.ovfilter(c)
	return c:IsLevelAbove(5) and c:IsSetCard(0x75e) and c:IsFaceup()
end
function c75011026.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,75011026)==0 and Duel.GetFlagEffect(1-tp,75011027)>0 end
	Duel.RegisterFlagEffect(tp,75011026,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c75011026.chkop(e,tp,eg,ep,ev,re,r,rp)
	if r&REASON_EFFECT>0 then Duel.RegisterFlagEffect(ep,75011027,RESET_PHASE+PHASE_END,0,1) end
end
function c75011026.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(75011026)~=0
end
function c75011026.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	local g=e:GetHandler():GetOverlayGroup()
	e:SetLabel(g:GetCount())
	Duel.SendtoGrave(g,REASON_COST)
end
function c75011026.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	local b1=true
	local b2=Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil)
	local b3=b2 and ct>=2
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(75011026,1)},
		{b2,aux.Stringid(75011026,2)},
		{b3,aux.Stringid(75011026,4)})
	if op~=2 then
		Duel.Damage(1-tp,700,REASON_EFFECT)
	end
	if op==3 then Duel.BreakEffect() end
	if op~=1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tc=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil):GetFirst()
		if tc then
			Duel.HintSelection(Group.FromCards(tc))
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		end
	end
end
function c75011026.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c75011026.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(75011026,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(75011026,3))
end
function c75011026.actcon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end
function c75011026.atkcon(e)
	return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL
end
function c75011026.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x75e)
end
function c75011026.atkval(e,c)
	return Duel.GetMatchingGroupCount(c75011026.atkfilter,c:GetControler(),LOCATION_MZONE,0,nil)*500
end
