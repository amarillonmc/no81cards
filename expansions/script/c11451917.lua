--真白梦游地下界
local cm,m=GetID()
function cm.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
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
	return c:IsLevelAbove(5) and c:IsRace(RACE_FAIRY) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_MZONE)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
		if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local rg=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_MZONE,0,1,1,nil)
			Duel.HintSelection(rg)
			Duel.BreakEffect()
			Duel.SendtoGrave(rg,REASON_EFFECT)
		end
	end
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=e:GetHandler():GetReasonCard()
	return rc and rc:IsLevelAbove(5) and rc:IsRace(RACE_FAIRY)
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