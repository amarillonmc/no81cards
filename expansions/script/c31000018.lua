--Fallacio Non Sequitur
function c31000018.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,31000018+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c31000018.condition)
	e1:SetOperation(c31000018.activate)
	c:RegisterEffect(e1)
	--Set
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_LEAVE_GRAVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c31000018.setcon)
	e2:SetTarget(c31000018.settg)
	e2:SetOperation(c31000018.setop)
	c:RegisterEffect(e2)
	if not c31000018.global_check then
		c31000018.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(c31000018.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end

function c31000018.condition(e,tp,eg,ep,ev,re,r,rp)
	local filter=function(c)
		return c:IsSetCard(0x308) and c:IsSummonLocation(LOCATION_EXTRA)
	end
	return Duel.GetMatchingGroupCount(filter,tp,LOCATION_MZONE,0,nil)>0
end

function c31000018.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x308))
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	Duel.RegisterEffect(e2,tp)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetValue(aux.tgoval)
	Duel.RegisterEffect(e3,tp)
end

function c31000018.checkfilter(c,tp)
	return c:IsSetCard(0x308) and c:IsType(TYPE_MONSTER) and c:IsControler(tp)
end

function c31000018.checkop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c31000018.checkfilter,1,nil,0) then Duel.RegisterFlagEffect(0,31000018,RESET_PHASE+PHASE_END,0,1) end
	if eg:IsExists(c31000018.checkfilter,1,nil,1) then Duel.RegisterFlagEffect(1,31000018,RESET_PHASE+PHASE_END,0,1) end
end

function c31000018.setcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,31000018)~=0
end

function c31000018.filter(c)
	return c:IsSetCard(0x308) and c:IsType(TYPE_MONSTER)
end

function c31000018.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroupCount(c31000018.filter,tp,LOCATION_GRAVE,0,nil)
	if chk==0 then return e:GetHandler():IsAbleToHand() and g>0 end
	
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,0)
end

function c31000018.setop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c31000018.filter,tp,LOCATION_GRAVE,0,nil)
	local sg=g:Select(tp,1,1,nil)
	Duel.SendtoDeck(sg,tp,2,REASON_EFFECT)
	Duel.SSet(tp,e:GetHandler())
end