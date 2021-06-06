local m=82207044
local cm=c82207044

function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCountLimit(1,m)  
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_BATTLE_DESTROYED)  
	e1:SetTarget(cm.tg)  
	e1:SetOperation(cm.op)  
	c:RegisterEffect(e1)  
end

function cm.spfilter(c,e,tp)  
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsRace(RACE_AQUA) and c:IsAttack(100) and c:IsLevel(1) and not c:IsCode(m)
end  
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,0x03,0,1,nil,e,tp) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x03)  
end  
function cm.op(e,tp,eg,ep,ev,re,r,rp)  
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ct<=0 then return end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,0x03,0,1,ct,nil,e,tp)  
	if g then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) 
	end  
end  