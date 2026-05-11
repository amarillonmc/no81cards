--祈愿缔约 美树沙耶香
local s,id=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,82706000)
	c:EnableReviveLimit()
	
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SSET)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id+1)
	e2:SetTarget(s.drtg)
	e2:SetOperation(s.drop)
	c:RegisterEffect(e2)
end

function s.setfilter(c)
	return c:IsSetCard(0xbd7) and c:IsType(TYPE_SPELL) and c:IsType(TYPE_RITUAL) and (c:IsAbleToHand() or c:IsSSetable())
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if not tc then return end
	local op=0
	if tc:IsAbleToHand() and tc:IsSSetable() then
		op=Duel.SelectOption(tp,1190,1153)
	elseif tc:IsAbleToHand() then
		op=0
	else
		op=1
	end
	if op==0 then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	else
		Duel.SSet(tp,tc)
	end
end

function s.drfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xbd7)
end

function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.drfilter,tp,LOCATION_MZONE,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	local drc=math.floor(ct/2)
	if chk==0 then return drc>0 and Duel.IsPlayerCanDraw(tp,drc) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(drc)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,drc)
end

function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetMatchingGroup(s.drfilter,tp,LOCATION_MZONE,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	local drc=math.floor(ct/2)
	if drc<=0 then return end
	local drawn=Duel.Draw(p,drc,REASON_EFFECT)
	if drawn>0 then
	    Duel.ShuffleHand(p)
		local bg=Duel.GetMatchingGroup(Card.IsAbleToDeck,p,LOCATION_HAND,0,nil)
		if bg:GetCount()>=drawn then
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
			local sg=bg:Select(p,drawn,drawn,nil)
			Duel.SendtoDeck(sg,nil,SEQ_DECKTOP,REASON_EFFECT)
			Duel.ShuffleDeck(p)
		end
	end
end