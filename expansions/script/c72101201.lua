--深空 黑暗神 月暗
function c72101201.initial_effect(c)
	c:SetUniqueOnField(1,1,72101201)
	--link summon
	aux.AddLinkProcedure(c,nil,2,3,c72101201.lcheck)
	c:EnableReviveLimit()

	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(72101201,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_LEAVE_GRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_GRAVE+LOCATION_REMOVED,0)
	e1:SetTarget(c72101201.seatg)
	e1:SetOperation(c72101201.seaop)
	c:RegisterEffect(e1)

	--be dark
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(72101201,0))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,72101201)
	e2:SetHintTiming(0,TIMING_MAIN_END)
	e2:SetCost(c72101201.bdcost)
	e2:SetTarget(c72101201.bdtg)
	e2:SetOperation(c72101201.bdop)
	c:RegisterEffect(e2)
	local e11=e2:Clone()
	e11:SetType(EFFECT_TYPE_QUICK_O)
	e11:SetCode(EVENT_FREE_CHAIN)
	e11:SetHintTiming(0,TIMING_BATTLE_END+TIMING_END_PHASE)
	e11:SetCondition(c72101201.bdcon)
	c:RegisterEffect(e11)
	local e12=e2:Clone()
	e12:SetType(EFFECT_TYPE_QUICK_O)
	e12:SetCode(EVENT_FREE_CHAIN)
	e12:SetHintTiming(0,TIMING_BATTLE_END+TIMING_END_PHASE)
	e12:SetCost(c72101201.bedcost)
	e12:SetCondition(c72101201.bedcon)
	c:RegisterEffect(e12)

	--extra material
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_ADD_EXTRA_TRIBUTE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetTarget(c72101201.exrtg)
	e3:SetValue(POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e4:SetRange(LOCATION_ONFIELD)
	e4:SetTargetRange(LOCATION_HAND,0)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_MONSTER,Card.IsSetCard,0xcea,Card.IsAttribute,ATTRIBUTE_DEVINE))
	e4:SetLabelObject(e3)
	c:RegisterEffect(e4)

	--changdi zhaohuan bubei wuxiao
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_SINGLE)
	e13:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	e13:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e13:SetValue(c72101201.cdval)
	c:RegisterEffect(e13)
	--changdi zhaohuan buneng fadong
	local e14=Effect.CreateEffect(c)
	e14:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e14:SetCode(EVENT_SUMMON_SUCCESS)
	e14:SetCondition(c72101201.cdcon)
	e14:SetOperation(c72101201.cdop)
	c:RegisterEffect(e14)


end

--link summon
function c72101201.lcheck(g)
	return g:IsExists(Card.IsLinkAttribute,1,nil,ATTRIBUTE_DARK)
end

--search
function c72101201.seafilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsLevel(10) and c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DIVINE) and c:IsAbleToHand()
end
function c72101201.seatg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c72101201.seafilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c72101201.seaop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.SelectMatchingCard(tp,c72101201.seafilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end

--be dark
	--1
function c72101201.bdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x7210,1,REASON_COST) end
	Duel.RemoveCounter(tp,1,1,0x7210,1,REASON_COST)
end
function c72101201.bdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
end
function c72101201.bdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e20=Effect.CreateEffect(c)
	e20:SetType(EFFECT_TYPE_FIELD)
	e20:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e20:SetTargetRange(0,LOCATION_MZONE)
	e20:SetValue(ATTRIBUTE_DARK)
	Duel.RegisterEffect(e20,tp)
end
	--2
function c72101201.bdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,72101207) and Duel.GetTurnPlayer()==tp
end
	--3
function c72101201.bedcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,3)
	if chk==0 then return g:FilterCount(Card.IsAbleToRemoveAsCost,nil,POS_FACEDOWN)==3 
	end
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x7210,1,REASON_COST) end
	Duel.RemoveCounter(tp,1,1,0x7210,1,REASON_COST)
end
function c72101201.bedcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,72101207) and not (Duel.GetTurnPlayer()==tp)
end

--extra material
function c72101201.exrtg(e,c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DARK)
end

--changdi zhaohuan bubei wuxiao
function c72101201.cdval(e,tp)
	return Duel.IsPlayerAffectedByEffect(tp,72101207) 
end

--changdi zhaohuan chenggong bufadong
function c72101201.cdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,72101207) 
end
function c72101201.genchainlm(c)
	return  function (e,rp,tp)
				return e:GetHandler():IsSetCard(0xcea)
			end
end
function c72101201.cdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimitTillChainEnd(c72101201.genchainlm(e:GetHandler()))
end