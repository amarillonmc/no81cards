--疯狂的恩宠
local cm,m,o=GetID()
function cm.initial_effect(c)
	c:EnableCounterPermit(0x625,LOCATION_ONFIELD)
	
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetLabel(1,0)
	e1:SetTarget(cm.Countdowntg)
	e1:SetOperation(cm.Countdownop)
	c:RegisterEffect(e1)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetCondition(cm.dcon)
	e1:SetOperation(cm.dop)
	c:RegisterEffect(e1)
end
function cm.Countdowntg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanAddCounter(tp,0x625,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x625)
end
function cm.Countdownop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local num,tf=e:GetLabel()
	if c:IsRelateToEffect(e) then
		c:AddCounter(0x625,num)
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(60001511,1))
		e1:SetCategory(CATEGORY_COUNTER)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetCountLimit(1)
		e1:SetOperation(cm.Countdowncost)
		e1:SetRange(LOCATION_SZONE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		c:RegisterEffect(e1)
		local e1=Effect.CreateEffect(c)
		e1:SetCategory(CATEGORY_DESTROY)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_SZONE)
		e1:SetCode(EFFECT_SELF_DESTROY)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetCondition(cm.Countdowncon)
		c:RegisterEffect(e1)
		if tf==1 then
			local e3=Effect.CreateEffect(c)
			e3:SetDescription(aux.Stringid(60001511,2))
			e3:SetCategory(CATEGORY_COUNTER)
			e3:SetType(EFFECT_TYPE_QUICK_O)
			e3:SetCode(EVENT_FREE_CHAIN)
			e3:SetRange(LOCATION_SZONE)
			e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_NO_TURN_RESET)
			e3:SetCountLimit(1)
			e3:SetTarget(cm.CountdownAtg)
			e3:SetOperation(cm.CountdownAop)
			e3:SetReset(RESET_EVENT+RESETS_REDIRECT)
			c:RegisterEffect(e3)
		end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_LOSE_KOISHI)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetTargetRange(1,0)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.Countdowncost(e,tp,eg,ep,ev,re,r,rp)
	if Card.IsCanRemoveCounter(e:GetHandler(),tp,0x625,1,REASON_EFFECT) then
		Card.RemoveCounter(e:GetHandler(),tp,0x625,1,REASON_EFFECT)
	end
end
function cm.Countdowncon(e)
	return Card.GetCounter(e:GetHandler(),0x625)==0
end
function cm.CountdownAtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Card.IsCanRemoveCounter(e:GetHandler(),tp,0x625,1,REASON_EFFECT) 
		and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x625)
end
function cm.CountdownAop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsDiscardable,tp,LOCATION_HAND,0,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc and c:IsRelateToEffect(e) and Duel.SendtoGrave(tc,REASON_EFFECT+REASON_DISCARD)~=0 then
		Card.RemoveCounter(e:GetHandler(),tp,0x625,1,REASON_EFFECT)
	end
end
function cm.dcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0 and e:GetHandler():IsPreviousLocation(LOCATION_SZONE)
end
function cm.dop(e,tp,eg,ep,ev,re,r,rp)
	local lp=Duel.GetLP(tp)
	if lp>4000 then lp=lp-4000
	elseif lp<=4000 then lp=0 end
	Duel.SetLP(tp,lp)
end