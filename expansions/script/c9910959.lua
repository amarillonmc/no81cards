--永夏的释怀
require("expansions/script/c9910950")
function c9910959.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_REMOVE+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9910959+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c9910959.cost)
	e1:SetTarget(c9910959.target)
	e1:SetOperation(c9910959.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(9910959,ACTIVITY_CHAIN,aux.FALSE)
end
function c9910959.costfilter(c)
	return c:IsSetCard(0x5954) and c:IsType(TYPE_MONSTER) and c:IsReleasable()
end
function c9910959.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,c9910959.costfilter,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectReleaseGroupEx(tp,c9910959.costfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c9910959.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanRemove(tp) and Duel.IsPlayerCanDraw(tp,3) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(3)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,3)
end
function c9910959.thfilter(c)
	return c:IsFacedown() and c:IsSetCard(0x5954) and c:IsAbleToHand()
end
function c9910959.activate(e,tp,eg,ep,ev,re,r,rp)
	local res=false
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)>0 then
		Duel.ShuffleHand(p)
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(p,Card.IsAbleToRemove,p,LOCATION_HAND,0,2,2,nil,p,POS_FACEDOWN)
		if #g>1 then
			res=Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)>0
			if res and Duel.GetCustomActivityCount(9910959,1-tp,ACTIVITY_CHAIN)~=0
				and Duel.IsExistingMatchingCard(c9910959.thfilter,tp,LOCATION_REMOVED,0,1,nil)
				and Duel.SelectYesNo(tp,aux.Stringid(9910959,0)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local sg=Duel.SelectMatchingCard(tp,c9910959.thfilter,tp,LOCATION_REMOVED,0,1,1,nil)
				if #sg>0 then
					Duel.SendtoHand(sg,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,sg)
				end
			end
		end
	end
	QutryYx.ExtraEffectSelect(e,tp,res)
end
