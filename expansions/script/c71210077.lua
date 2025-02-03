--码丽丝<代码>ALT-08
function c71210077.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCountLimit(1,71210077+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c71210077.target)
	e1:SetOperation(c71210077.activate)
	c:RegisterEffect(e1)
	--act in set turn
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetDescription(aux.Stringid(71210077,2))
	e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCost(c71210077.stcost)
	c:RegisterEffect(e2)
end
function c71210077.cfilter(c) 
	return c:IsFaceup() and c:IsSetCard(0x1bf) and c:IsAbleToRemoveAsCost() 
end 
function c71210077.stcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71210077.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c71210077.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c71210077.thfilter(c)
	return c:IsSetCard(0x1bf) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c71210077.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71210077.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c71210077.filter(c,mg)
	return c:IsLinkSummonable(mg,nil,1,99)
end
function c71210077.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c71210077.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g) 
		local mg=Duel.GetMatchingGroup(function(c) return c:IsFaceup() and c:IsRace(RACE_CYBERSE) and c:IsCanBeLinkMaterial(nil) end,tp,LOCATION_MZONE,0,nil)
		if Duel.IsExistingMatchingCard(c71210077.filter,tp,LOCATION_EXTRA,0,1,nil,mg) and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_MZONE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(71210077,0)) then 
			Duel.BreakEffect()
			local sc=Duel.SelectMatchingCard(tp,c71210077.filter,tp,LOCATION_EXTRA,0,1,1,nil,mg):GetFirst() 
			Duel.LinkSummon(tp,sc,mg,nil,1,99)  
		end 
	end
end

