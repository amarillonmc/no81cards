--梦的无限回廊
function c67200755.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	--e1:SetCountLimit(1,67200755+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c67200755.activate)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67200755,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCountLimit(1,67200755)
	e2:SetTarget(c67200755.thtg)
	e2:SetOperation(c67200755.thop)
	c:RegisterEffect(e2)  
	--
	local e8=Effect.CreateEffect(c)
	e8:SetCategory(CATEGORY_TOHAND)
	e8:SetType(EFFECT_TYPE_IGNITION)
	e8:SetRange(LOCATION_GRAVE)
	e8:SetCountLimit(1,67200755)
	e8:SetCost(aux.bfgcost)
	e8:SetTarget(c67200755.thtg)
	e8:SetOperation(c67200755.thop)
	c:RegisterEffect(e8)  
end
function c67200755.linkfilter(c)
	return c:IsLinkSummonable(nil) and c:IsSetCard(0x367d)
end
function c67200755.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetMZoneCount(tp)<1 then return end
	local gg=Duel.GetMatchingGroup(c67200755.linkfilter,tp,LOCATION_EXTRA,0,nil)
	if gg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(67200755,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=gg:Select(tp,1,1,nil):GetFirst()
		Duel.LinkSummon(tp,tc,nil)
	end
end
--
function c67200755.thfilter(c)
	return c:IsSetCard(0x367d) and IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c67200755.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200755.thfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c67200755.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c67200765.thfilter,tp,LOCATION_REMOVED,0,1,1,nil)  
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end