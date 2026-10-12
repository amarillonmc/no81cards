--女仆议会 作战
local s,id,o=GetID()
function s.initial_effect(c)
	--手卡发动（丢弃1张手卡）
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,0))
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCost(s.handcost)
	c:RegisterEffect(e0)
	--①
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1190)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.thtg1)
	e1:SetOperation(s.thop1)
	c:RegisterEffect(e1)
	--②
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES_SELF+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DISCARD)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCountLimit(1,id+1)
	e2:SetTarget(s.drawtg2)
	e2:SetOperation(s.drawop2)
	c:RegisterEffect(e2)
end
function s.handcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function s.thfilter1(c)
	return c:IsSetCard(0x3A71) and c:IsAbleToHand() and c:IsFaceup()
end
function s.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function s.thop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thfilter1),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if #g==0 then return end
	Duel.HintSelection(g)
	local tc=g:GetFirst()
	if Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,tc)
		if tc:IsType(TYPE_MONSTER) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and tc:IsCanBeSpecialSummoned(e,0,tp,true,false) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
		end
	end
end
function s.cfilter(c)
	return c:IsSetCard(0xA71) and c:IsDiscardable(REASON_EFFECT)
end
function s.drawtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function s.drawop2(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)==d then
		Duel.BreakEffect()
		if Duel.IsExistingMatchingCard(s.cfilter,p,LOCATION_HAND,0,1,nil) then
			local dg=Duel.SelectMatchingCard(p,s.cfilter,p,LOCATION_HAND,0,1,1,nil)
			if dg:GetCount()>0 then
				Duel.ShuffleHand(p)
				Duel.SendtoGrave(dg,REASON_EFFECT+REASON_DISCARD,p)
			end
		else
			local sg=Duel.GetFieldGroup(p,LOCATION_HAND,0)
			if Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)==0 then
				Duel.ConfirmCards(1-p,sg)
				Duel.ShuffleHand(p)
			end
		end
	end
end