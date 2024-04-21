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
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCode(EVENT_RELEASE)
	e4:SetCountLimit(2,m)
	e4:SetCondition(cm.con2)
	e4:SetTarget(cm.tg2)
	e4:SetOperation(cm.op2)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetCode(EFFECT_ADD_EXTRA_TRIBUTE)
	e5:SetTargetRange(LOCATION_HAND+LOCATION_SZONE,0)
	e5:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x9d1))
	e5:SetValue(POS_FACEUP_ATTACK)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e6:SetRange(LOCATION_FZONE)
	e6:SetTargetRange(LOCATION_HAND,0)
	e6:SetTarget(cm.tg4)
	e6:SetLabelObject(e5)
	c:RegisterEffect(e6)
	  
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