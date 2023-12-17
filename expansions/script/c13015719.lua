--深海姬·汇流海马
function c13015719.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,99,c13015719.lcheck) 
	--to hand 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_TOGRAVE) 
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCountLimit(1,13015719)  
	--e1:SetCost(c13015719.thcost)
	e1:SetTarget(c13015719.thtg)
	e1:SetOperation(c13015719.thop) 
	c:RegisterEffect(e1) 
	--link summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(13015719,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCondition(c13015719.lkcon)
	e2:SetTarget(c13015719.lktg)
	e2:SetOperation(c13015719.lkop)
	c:RegisterEffect(e2)
end
function c13015719.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0xe01)
end 
function c13015719.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(function(c) return c:IsSetCard(0xe01) and c:IsAbleToGraveAsCost() end,tp,LOCATION_HAND,0,1,nil) end 
	local g=Duel.SelectMatchingCard(tp,function(c) return c:IsSetCard(0xe01) and c:IsAbleToGraveAsCost() end,tp,LOCATION_HAND,0,1,1,nil)  
	Duel.SendtoGrave(g,REASON_COST) 
end 
function c13015719.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(function(c) return c:IsAbleToHand() and c:IsSetCard(0xe01) end,tp,LOCATION_GRAVE,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end 
function c13015719.thop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_HAND,0,nil) 
	if g:GetCount()>0 then 
		local dg=g:Select(tp,1,1,nil)  
		local g=Duel.GetMatchingGroup(function(c) return c:IsAbleToHand() and c:IsSetCard(0xe01) end,tp,LOCATION_GRAVE,0,nil) 
		if Duel.SendtoGrave(dg,REASON_EFFECT)~=0 and g:GetCount()>0 then 
			Duel.BreakEffect()   
			local sg=g:Select(tp,1,1,nil) 
			Duel.SendtoHand(sg,tp,REASON_EFFECT) 
			Duel.ConfirmCards(1-tp,sg)   
		end  
	end 
end 
function c13015719.lkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
		and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c13015719.lktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(13015719)==0 and Duel.IsExistingMatchingCard(Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,1,nil,nil,e:GetHandler()) end 
	c:RegisterFlagEffect(13015719,RESET_CHAIN,0,1) 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c13015719.lkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsControler(1-tp) or not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local g=Duel.GetMatchingGroup(Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,nil,nil,c)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.LinkSummon(tp,sg:GetFirst(),nil,c)
	end
end
