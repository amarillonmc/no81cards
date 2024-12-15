--真白梦游地下界
local cm,m=GetID()
function cm.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetCondition(cm.thcon)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
end
function cm.spfilter(c,e,tp)
	return c:IsLevelAbove(5) and c:IsRace(RACE_FAIRY) and c:IsAbleToHand()
end
function cm.smfilter(c)
	return not c:IsRace(RACE_FAIRY) and c:IsSummonable(true,nil)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(cm.smfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	if tc and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		local rg=Duel.SelectMatchingCard(tp,cm.smfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,nil)
		if #rg>0 then
			Duel.BreakEffect()
			Duel.Summon(tp,rg:GetFirst(),true,nil)
		end
	end
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=e:GetHandler():GetReasonCard()
	return rc and rc:IsLevelAbove(5) and rc:IsRace(RACE_FAIRY) and r&REASON_EFFECT>0
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	if chk==0 then return #tg>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,tg,#tg,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,aux.ExceptThisCard(e))
	Duel.SendtoGrave(tg,REASON_EFFECT)
end