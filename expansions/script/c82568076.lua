--灰蕈迷境
function c82568076.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DICE+CATEGORY_DRAW+CATEGORY_TOHAND+CATEGORY_REMOVE+CATEGORY_LEAVE_GRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,82568076+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c82568076.cost)
	e1:SetTarget(c82568076.target)
	e1:SetOperation(c82568076.activate)
	c:RegisterEffect(e1)
end
c82568076.toss_dice=true
function c82568076.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x5825,1,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x5825,1,REASON_COST)
end
function c82568076.filter1(c)
	return c:IsSetCard(0x825) and c:IsAbleToHand()
end
function c82568076.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,10)
	if chk==0 then return Duel.IsExistingMatchingCard(c82568076.filter1,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) 
		   and  Duel.IsPlayerCanDraw(tp,2) and Duel.IsPlayerCanDraw(1-tp,2) and g:FilterCount(Card.IsAbleToRemove,nil,POS_FACEDOWN)==10
		and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=10 end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function c82568076.activate(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetDecktopGroup(tp,10)
	local d=Duel.TossDice(tp,1)
	if d==1 or d==2 then
	local g=Duel.GetMatchingGroup(c82567864.filter1,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
		if g:GetCount()>0  then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local tc=g:Select(tp,1,1,nil):GetFirst()
			Duel.SendtoHand(tc,tp,REASON_EFFECT)
		end
	elseif d==3 or d==4 then
		Duel.Draw(1-tp,2,REASON_EFFECT)
		
	elseif d==5 then
		Duel.Draw(tp,2,REASON_EFFECT)
	elseif d==7 then
		return   
	else
		local dg=Duel.GetDecktopGroup(tp,10)
		if dg:FilterCount(Card.IsAbleToRemove,nil,POS_FACEDOWN)==10
		and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=10 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		   Duel.DisableShuffleCheck()
		   Duel.Remove(dg,POS_FACEDOWN,REASON_COST)
		end
	
   end
end
