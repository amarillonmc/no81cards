--小圣地亚哥
local m=25800045
local cm=_G["c"..m]
function cm.initial_effect(c)

aux.EnableChangeCode(c,25800049,LOCATION_MZONE+LOCATION_GRAVE)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,m+1)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetCondition(cm.condition)
	c:RegisterEffect(e4)
end
function cm.thfilter(c)
	return c:IsSetCard(0xa211) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,1,tp,1)
end
function cm.disfilter(c)
	return c:IsSetCard(0x211) 
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()==0 then return end
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	Duel.BreakEffect()
	Duel.DiscardHand(tp,cm.disfilter,1,1,REASON_EFFECT)
end
--2
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function cm.spfilter2(c,e,tp)
	return c:IsSetCard(0xa211) and c:IsLevelAbove(5) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand()
		and Duel.IsExistingMatchingCard(cm.spfilter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) 
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
function cm.thfilter2(c)
	return c:IsFaceup()  and c:IsCode(25800049)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter2),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then   
			if  not Duel.IsExistingMatchingCard(cm.thfilter2,tp,LOCATION_MZONE,0,2,nil) then
				 Duel.SendtoHand(c,nil,REASON_EFFECT)
			end
			end
		end
end


