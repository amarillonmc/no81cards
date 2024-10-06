--芳青之梦 九魂猫秘术
local s,id,o=GetID()
function s.initial_effect(c)
	--act in set turn
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,0))
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e0:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e0:SetCondition(s.actcon)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(s.setcon)
	e2:SetTarget(s.settg)
	e2:SetOperation(s.setop)
	c:RegisterEffect(e2)
end
function s.actfilter(c)
	return c:IsDisabled() and c:IsSetCard(0xc914) and c:IsFaceup()
end
function s.actcon(e)
	return Duel.GetMatchingGroupCount(s.actfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil)>0
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,id,0xc914,TYPES_NORMAL_TRAP_MONSTER,2000,2000,7,RACE_BEAST,ATTRIBUTE_WIND) and Duel.GetFieldGroupCount(tp,LOCATION_REMOVED,LOCATION_REMOVED)>0 end
	local g=Duel.GetFieldGroup(tp,LOCATION_REMOVED,LOCATION_REMOVED,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,LOCATION_REMOVED,LOCATION_REMOVED)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,LOCATION_REMOVED,LOCATION_REMOVED)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK)
	if ct>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,id,0xc914,TYPES_NORMAL_TRAP_MONSTER,2000,2000,7,RACE_BEAST,ATTRIBUTE_WIND) then
		c:AddMonsterAttribute(TYPE_NORMAL+TYPE_TRAP)
		if Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)~=0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(ct*500)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			c:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DIRECT_ATTACK)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			c:RegisterEffect(e2)
		end
	end
end
function s.setfilter(c)
	return c:IsSetCard(0xc914) and c:IsFaceup()
end
function s.setcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(s.setfilter,tp,LOCATION_MZONE,0,nil)>0
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SSet(tp,c)
	end
end