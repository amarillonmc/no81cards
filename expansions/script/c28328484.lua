--第84届一等星讨论会！
function c28328484.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--field effect
	--[[local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_ADD_SETCODE)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTargetRange(LOCATION_DECK,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsOriginalSetCard,0x284))
	e1:SetValue(0x283)
	c:RegisterEffect(e1)]]--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x284))
	e2:SetValue(500)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EFFECT_UPDATE_LEVEL)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--search
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(28328484,0))
	e5:SetCategory(CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCountLimit(1)
	e5:SetTarget(c28328484.dthtg)
	e5:SetOperation(c28328484.dthop)
	c:RegisterEffect(e5)
	--to hand
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(28328484,1))
	e6:SetCategory(CATEGORY_TOHAND)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_TO_GRAVE)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetRange(LOCATION_FZONE)
	e6:SetTarget(c28328484.gthtg)
	e6:SetOperation(c28328484.gthop)
	c:RegisterEffect(e6)
end
function c28328484.disfilter(c)
	return c:IsSetCard(0x284) and c:IsDiscardable(REASON_EFFECT)
end
function c28328484.thfilter(c)
	return c:IsSetCard(0x284) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c28328484.dthtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28328484.disfilter,tp,LOCATION_HAND,0,1,nil)
		and Duel.IsExistingMatchingCard(c28328484.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c28328484.dthop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c28328484.thfilter,tp,LOCATION_DECK,0,nil)
	local ct=g:GetClassCount(Card.GetAttribute)
	local ds=Duel.DiscardHand(tp,c28328484.disfilter,1,ct,REASON_EFFECT+REASON_DISCARD,nil)
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=g:SelectSubGroup(tp,aux.dabcheck,false,ds,ds)
	Duel.SendtoHand(tg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tg)
end
function c28328484.cfilter(c,re,tp)
	return c:IsSetCard(0x284) and c:IsType(TYPE_MONSTER) and c:IsReason(REASON_COST) and re:IsActivated() and re:IsActiveType(TYPE_XYZ) and c:IsPreviousLocation(LOCATION_OVERLAY) and c:IsLocation(LOCATION_GRAVE) and c:IsAbleToHand() and c:IsControler(tp)
end
function c28328484.gthtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(c28328484.cfilter,nil,re,tp)
	if chk==0 then return #g>0 end
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,nil)
end
function c28328484.gthop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c28328484.cfilter,nil,re,tp)
	local mg=g:Filter(Card.IsRelateToChain,nil)
	if #mg>0 then
		local tc=mg:GetFirst()
		if #mg>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			tc=mg:Select(tp,1,1,nil):GetFirst()
		end
		Duel.HintSelection(Group.FromCards(tc))
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
