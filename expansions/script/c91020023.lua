--真神招来
local m=91020023
local cm=c91020023
function c91020023.initial_effect(c)
--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Atk&Def
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCode(EVENT_RELEASE)
	e4:SetCountLimit(1,m)
	e4:SetCondition(cm.con2)
	e4:SetTarget(cm.tg2)
	e4:SetOperation(cm.op2)
	c:RegisterEffect(e4)
   local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x9d1))
	e2:SetValue(500)
	c:RegisterEffect(e2)
end
function cm.tg4(e,c)
return c:IsRace(RACE_DIVINE)
end
function cm.fit2(c)
	return  c:IsSetCard(0x9d1) 
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return  eg:IsExists(cm.fit2,1,nil)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end	
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,nil,0,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,nil,0,LOCATION_REMOVED)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,cm.fit2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)	
end
function cm.op5(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,cm.fit2,tp,LOCATION_DECK,0,1,1,nil)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function cm.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c:IsSetCard(0x9d1)
end
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.SelectMatchingCard(tp,cm.fit2,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SendtoHand(sg,tp,REASON_EFFECT)
end