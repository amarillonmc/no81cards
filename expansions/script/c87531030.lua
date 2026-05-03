--吉塔厦探刺
function c87531030.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_TOHAND)
	e1:SetCountLimit(1,87531030+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c87531030.cost)
	e1:SetTarget(c87531030.target)
	e1:SetOperation(c87531030.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(87531030,ACTIVITY_CHAIN,c87531030.chainfilter)
end
function c87531030.chainfilter(re,tp,cid)
	local rc=re:GetHandler()
	if re:IsActiveType(TYPE_SPELL) and rc:IsType(TYPE_QUICKPLAY) then
		Duel.RegisterFlagEffect(tp,87531030,0,0,0)
	end
	return not (re:IsActiveType(TYPE_SPELL) and rc:IsType(TYPE_QUICKPLAY))
end
function c87531030.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tp=c:GetControler()
	if chk==0 then return Duel.GetFlagEffect(tp,87531030)==0 end
	Duel.PayLPCost(tp,2000)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetValue(c87531030.aclimit)
	Duel.RegisterEffect(e1,tp)
end
function c87531030.aclimit(e,re,tp)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_SPELL) and rc:IsType(TYPE_QUICKPLAY) 
end
function c87531030.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c87531030.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g:GetCount()>0 then
		Duel.ConfirmCards(tp,g)
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
		Duel.ShuffleHand(1-tp)
	end
end
