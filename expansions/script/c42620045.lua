--海晶少女流风
local m=42620045
local cm=_G["c"..m]

function cm.initial_effect(c)
	--act in hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e1:SetCondition(cm.handcon)
	c:RegisterEffect(e1)
	--Draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(cm.condition)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.activate)
	c:RegisterEffect(e2)
end

function cm.hcfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x12b) and c:IsLinkAbove(3)
end

function cm.handcon(e)
	return Duel.IsExistingMatchingCard(cm.hcfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end

function cm.condfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x12b) and c:IsType(TYPE_LINK)
end

function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.condfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end

function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end

function cm.opdfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x12b) and c:IsLink(4)
end

function cm.oplfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x12b) and c:IsLinkAbove(2)
end

function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	Duel.ShuffleHand(p)
	Duel.BreakEffect()
	if Duel.IsExistingMatchingCard(cm.opdfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil) 
	and Duel.IsExistingMatchingCard(Card.IsDiscardable,e:GetHandlerPlayer(),LOCATION_HAND,0,1,nil)
	and Duel.IsExistingMatchingCard(Card.IsDiscardable,e:GetHandlerPlayer(),0,LOCATION_HAND,1,nil) 
	and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT,nil)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_DISCARD)
		Duel.DiscardHand(1-tp,Card.IsDiscardable,1,1,REASON_EFFECT,nil)
		if Duel.IsExistingMatchingCard(cm.oplfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil) then
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetRange(LOCATION_SZONE)
			e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e2:SetTargetRange(0,1)
			e2:SetTarget(cm.splimit)
			e2:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e2,tp)
		end
	elseif Duel.IsExistingMatchingCard(Card.IsDiscardable,e:GetHandlerPlayer(),LOCATION_HAND,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT,nil)
		if Duel.IsExistingMatchingCard(cm.oplfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil) then
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetRange(LOCATION_SZONE)
			e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e2:SetTargetRange(0,1)
			e2:SetTarget(cm.splimit)
			e2:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e2,tp)
		end
	end
end

function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_DECK) or c:IsLocation(LOCATION_GRAVE)
end