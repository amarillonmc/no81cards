--时光史书
local m=33703015
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Effect 1
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_DAMAGE)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetTarget(cm.damtg)
	e0:SetOperation(cm.damop)
	c:RegisterEffect(e0)
	--Effect 2  
	local e02=Effect.CreateEffect(c)  
	e02:SetDescription(aux.Stringid(m,0))
	e02:SetCategory(CATEGORY_DECKDES+CATEGORY_TOHAND)
	e02:SetType(EFFECT_TYPE_IGNITION)
	e02:SetRange(LOCATION_SZONE)
	e02:SetCountLimit(1)
	e02:SetCondition(cm.con)
	e02:SetTarget(cm.tg)
	e02:SetOperation(cm.op)
	c:RegisterEffect(e02)   
end
--Effect 1
function cm.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,2000)
end
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
--Effect 2
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 
end 
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local dg=Duel.GetMatchingGroup(nil,tp,LOCATION_GRAVE,0,nil)
	local thc=dg:GetMinGroup(Card.GetSequence):GetFirst()
	local b1=thc:IsAbleToHand()
	local b2=Duel.IsPlayerCanDiscardDeck(tp,1)
	if chk==0 then return b1  end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,thc,1,0,0)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetMatchingGroup(nil,tp,LOCATION_GRAVE,0,nil)
	local thc=dg:GetMinGroup(Card.GetSequence):GetFirst()
	if thc:IsHasEffect(EFFECT_NECRO_VALLEY) then return end
	if Duel.SendtoHand(thc,nil,REASON_EFFECT)==0 or thc:GetLocation()~=LOCATION_HAND then return false end
	if  Duel.IsPlayerCanDiscardDeck(tp,1) 
		and Duel.SelectYesNo(tp,aux.Stringid(m,0))  then
		Duel.BreakEffect()
		Duel.DiscardDeck(tp,1,REASON_EFFECT)
	end
	Duel.BreakEffect()
	Duel.SkipPhase(tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end