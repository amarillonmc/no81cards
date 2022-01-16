--动物朋友 GothicxLuck
local m=33701357
local cm=_G["c"..m]
function cm.initial_effect(c)
		--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode2(c,33701355,33701356,true,true)
	aux.AddContactFusionProcedure(c,Card.IsAbleToGraveAsCost,LOCATION_ONFIELD+LOCATION_HAND,0,Duel.SendtoGrave,REASON_COST)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e0)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_CUSTOM+33700000)
	e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(cm.spcon1)
	e1:SetTarget(cm.sptg1)
	e1:SetOperation(cm.spop1)
	c:RegisterEffect(e1)
end
function cm.check(c,re)
	return c:IsSetCard(0x442) and re:GetHandler():IsSetCard(0x442) and c:IsLocation(LOCATION_DECK)
end
function cm.spcheck(c,re,e,tp)
	return c:IsSetCard(0x442) and re:GetHandler():IsSetCard(0x442) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLocation(LOCATION_DECK)
end
function cm.thcheck(c,re)
	return c:IsSetCard(0x442) and re:GetHandler():IsSetCard(0x442) and c:IsAbleToHand() and c:IsLocation(LOCATION_DECK)
end
function cm.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.check,1,nil,re)
end
function cm.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local check=e:GetHandler():GetSequence()>4
	if chk==0 then 
		if check then
			return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and eg:IsExists(cm.spcheck,1,nil,re,e,tp) 
		else
			return eg:IsExists(cm.thcheck,1,nil,re)  
		end
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,eg,1,0,0)
end
function cm.spop1(e,tp,eg,ep,ev,re,r,rp)
	local check=e:GetHandler():GetSequence()>4
	if check then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and eg:IsExists(cm.spcheck,1,nil,re,e,tp) then
			local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
			local sg=eg:Filter(cm.spcheck,nil,re,e,tp)
			ft=math.min(ft,#sg)
			if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
			sg=sg:SelectSubGroup(tp,aux.dncheck,false,1,ft)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	else
		if eg:IsExists(cm.thcheck,1,nil,re) then
			local sg=eg:Filter(cm.thcheck,nil,re)
			if sg:GetCount()>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local ag=sg:SelectSubGroup(tp,aux.dncheck,false,1,3)
				Duel.SendtoHand(ag,tp,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,ag)
			end
		end
	end
end