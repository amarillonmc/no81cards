--时崎狂三 破灭世界的重塑者
local m=33400020
local cm=_G["c"..m]
function cm.initial_effect(c)
c:EnableCounterPermit(0x34f)
	 --link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x341),2)
	c:EnableReviveLimit()
--activate from hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(aux.TargetBoolFunction(cm.afilter))
	e1:SetTargetRange(LOCATION_HAND,0)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.con)
	e2:SetCost(cm.spcost)   
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
 --search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED)
	e3:SetCountLimit(1,m+10000)
	e3:SetCondition(cm.thcon2)
	e3:SetCost(cm.spcost2)
	e3:SetTarget(cm.thtg2)
	e3:SetOperation(cm.thop2)
	c:RegisterEffect(e3)
end
function cm.afilter(c)
	return c:IsSetCard(0x3340) and c:IsType(TYPE_QUICKPLAY)
end

function cm.con(e,tp,eg,ep,ev,re,r,rp)
 local g=Duel.GetMatchingGroup(nil,e:GetHandlerPlayer(),LOCATION_DECK,0,nil)
	return  g:GetClassCount(Card.GetCode)==g:GetCount()
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
 local hg=Duel.GetMatchingGroup(nil,tp,LOCATION_DECK,0,nil)
	Duel.ConfirmCards(tp,hg)
	Duel.ConfirmCards(1-tp,hg)
end
function cm.filter(c,e,tp)
	return c:IsLevel(4) and  c:IsSetCard(0x341) and ((c:IsType(TYPE_RITUAL) and  c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,true)) or c:IsCanBeSpecialSummoned(e,0,tp,false,false) )
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	 if chkc then return true end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) end
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND,0,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		  local g1=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
		  if g1:GetCount()<=0 then return end 
		  local tc=g1:GetFirst()
		  if tc:IsType(TYPE_RITUAL)  then
		  Duel.SpecialSummon(g1,SUMMON_TYPE_RITUAL,tp,tp,true,true,POS_FACEUP)
		  else
		  Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
		  end
		  e:GetHandler():AddCounter(0x34f,3)
end

function cm.thcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),33420330)>0
end
function cm.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToExtraAsCost() end
	Duel.SendtoDeck(c,nil,SEQ_DECKTOP,REASON_COST)
end
function cm.thfilter2(c)
	return c:IsSetCard(0x340,0x341)  and c:IsAbleToHand()
end
function cm.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter2,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function cm.thop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end