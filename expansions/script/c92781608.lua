--超机怪虫·光津嗜染质虫
function c92781608.initial_effect(c)
	c:SetUniqueOnField(1,0,92781608)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x104),1,1)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(c92781608.moveop)
	c:RegisterEffect(e1)
	--adjust
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetRange(LOCATION_ONFIELD)
	e2:SetOperation(c92781608.effop)
	c:RegisterEffect(e2)
	--adjust
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ADJUST)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e3:SetRange(LOCATION_ONFIELD)
	e3:SetTarget(c92781608.fieldtg)
	e3:SetOperation(c92781608.fieldop)
	c:RegisterEffect(e3)
end
function c92781608.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c92781608.moveop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	local e1=Effect.CreateEffect(c)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fc0000)
	e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_ONFIELD)
	e1:SetReset(RESET_EVENT+0x1fc0000)
	e2:SetValue(c92781608.efilter)
	c:RegisterEffect(e2)
	--can't activate
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_ONFIELD)
	e3:SetTargetRange(1,0)
	e3:SetValue(c92781608.aclimit)
	e3:SetReset(RESET_EVENT+0x1fc0000)
	c:RegisterEffect(e3,tp)
	--cannot set
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_SSET)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_ONFIELD)
	e4:SetTargetRange(1,0)
	e4:SetTarget(c92781608.cstg)
	c:RegisterEffect(e4)
end
function c92781608.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_FIELD)
end
function c92781608.cstg(e,c)
	return c:IsType(TYPE_FIELD)
end
function c92781608.efffilter(c,lg,ignore_flag)
	return c:IsType(TYPE_EFFECT) and c:IsSetCard(0x104)
		and c:GetSequence()<5
		and (ignore_flag or c:GetFlagEffect(92781608)==0)
end
function c92781608.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c92781608.efffilter,tp,LOCATION_MZONE,0,nil)
	if c:IsDisabled() then return end
	for tc in aux.Next(g) do
		tc:RegisterFlagEffect(92781608,RESET_EVENT+0x1fe0000,0,1)
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(92781608,0))
		e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
		e1:SetType(EFFECT_TYPE_QUICK_O)
		e1:SetCode(EVENT_CHAINING)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetLabelObject(c)
		e1:SetCondition(c92781608.discon2)
		e1:SetCost(c92781608.cost)
		e1:SetTarget(c92781608.distg2)
		e1:SetOperation(c92781608.disop2)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end
function c92781608.discon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local gc=e:GetLabelObject()
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return gc and gc:IsFaceup() and gc:IsLocation(LOCATION_ONFIELD)
		and (re:IsActiveType(TYPE_MONSTER) and loc==LOCATION_MZONE) or ((re:GetActiveType()==TYPE_SPELL or re:GetActiveType()==TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE)) and e:GetHandler():IsFacedown()
end
function c92781608.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsPosition(POS_FACEDOWN) end
	Duel.ChangePosition(e:GetHandler(),POS_FACEUP_DEFENSE)
end
function c92781608.distg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c92781608.filter,rp,0,LOCATION_ONFIELD,1,nil) end
end
function c92781608.disop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c92781608.repop)
end
function c92781608.filter(c)
	return c:IsType(TYPE_MONSTER)
end
function c92781608.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetType()==TYPE_SPELL or c:GetType()==TYPE_TRAP then
		c:CancelToGrave(false)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c92781608.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c92781608.fdfilter(c,tp)
	return c:IsCode(67831115)
end
function c92781608.fieldtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	if tc then return false end
	if chk==0 then return Duel.IsExistingMatchingCard(c92781608.fdfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) and Duel.GetCurrentChain()==0 end
end
function c92781608.fieldop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	if tc then return false end
	local sc=Duel.GetFirstMatchingCard(c92781608.fdfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,tp)
	if sc then
		Duel.MoveToField(sc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
	end
end
