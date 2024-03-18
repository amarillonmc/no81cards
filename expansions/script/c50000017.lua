--虹猫蓝兔七侠传 麒麟
function c50000017.initial_effect(c)
	aux.AddCodeList(c,50000000,50000017)
	c:SetUniqueOnField(1,0,50000017,LOCATION_MZONE)
	--act in set turn
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e0:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e0:SetCondition(c50000017.actcon)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCountLimit(1,50000017+EFFECT_COUNT_CODE_OATH)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c50000017.cost)
	e1:SetTarget(c50000017.target)
	e1:SetOperation(c50000017.activate)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_ONFIELD)
	e2:SetTarget(c50000017.reptg)
	e2:SetValue(c50000017.repval)
	e2:SetOperation(c50000017.repop)
	c:RegisterEffect(e2)
end
function c50000017.cfilter(c)
	return c:IsFaceup() and c:IsCode(50000000)
end
function c50000017.actcon(e)
	return Duel.IsExistingMatchingCard(c50000017.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c50000017.sprfilter(c)
	return c:IsFaceup() and c:IsCode(50000017)
end
function c50000017.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c50000017.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x999) and not (c:IsAttribute(ATTRIBUTE_DARK) and c:IsSetCard(0xa999))
end
function c50000017.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local rec=Duel.GetMatchingGroupCount(c50000017.filter1,tp,LOCATION_MZONE,0,nil)*500
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return rec>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsPlayerCanSpecialSummonMonster(tp,50000017,0x999,TYPES_NORMAL_TRAP_MONSTER,0,2800,10,RACE_BEAST,ATTRIBUTE_EARTH)
			and not Duel.IsExistingMatchingCard(c50000017.sprfilter,tp,LOCATION_MZONE,0,1,nil) end
	e:SetLabel(0)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(rec)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,rec)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c50000017.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rec=Duel.GetMatchingGroupCount(c50000017.filter,tp,LOCATION_MZONE,0,nil)*1000
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	if Duel.Recover(p,rec,REASON_EFFECT)>0 and c:IsRelateToEffect(e) 
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,50000017,0x999,TYPES_NORMAL_TRAP_MONSTER,0,2800,10,RACE_BEAST,ATTRIBUTE_EARTH) then
		Duel.BreakEffect()
		c:AddMonsterAttribute(TYPE_EFFECT)
		Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP_DEFENSE)
	end
end
function c50000017.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x999) and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function c50000017.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsFaceup() and c:IsAbleToDeck() and not c:IsStatus(STATUS_DESTROY_CONFIRMED)
		and eg:IsExists(c50000017.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c50000017.repval(e,c)
	return c50000017.repfilter(c,e:GetHandlerPlayer())
end
function c50000017.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end

