--天璀司的核晶
local m=82209090
local cm=_G["c"..m]
function cm.initial_effect(c)
	--activate  
	local e0=Effect.CreateEffect(c)  
	e0:SetType(EFFECT_TYPE_ACTIVATE)  
	e0:SetCode(EVENT_FREE_CHAIN)  
	c:RegisterEffect(e0)  
	--atk&def  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetCode(EFFECT_UPDATE_ATTACK)  
	e1:SetRange(LOCATION_SZONE)  
	e1:SetTargetRange(LOCATION_MZONE,0)  
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x9298))  
	e1:SetValue(500)  
	c:RegisterEffect(e1)  
	local e2=e1:Clone()  
	e2:SetCode(EFFECT_UPDATE_DEFENSE)  
	c:RegisterEffect(e2)  
	--spsummon  
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(m,0))  
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_COIN)  
	e3:SetType(EFFECT_TYPE_IGNITION)  
	e3:SetRange(LOCATION_SZONE)  
	e3:SetCountLimit(1,m)  
	e3:SetCondition(cm.spcon)  
	e3:SetTarget(cm.sptg)  
	e3:SetOperation(cm.spop)  
	c:RegisterEffect(e3)  
end
cm.toss_coin=true  

function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 or Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_MZONE,0,1,nil,TYPE_SYNCHRO)
end
function cm.spfilter(c,e,tp)  
	return c:IsSetCard(0x9298) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)  
end  
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end  
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)  
end  
function cm.spop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end  
	local ct=Duel.TossCoin(tp,1)+1
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		if Duel.IsPlayerAffectedByEffect(tp,59822133) or Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then
			ct=1
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
		local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,ct,nil,e,tp)  
		if g:GetCount()>0 then  
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)  
		end  
	end
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)  
	e1:SetTargetRange(1,0)  
	e1:SetTarget(cm.splimit)  
	e1:SetReset(RESET_PHASE+PHASE_END,2)   
	Duel.RegisterEffect(e1,tp)  
end  
function cm.splimit(e,c)  
	return c:IsLocation(LOCATION_EXTRA) and not c:IsType(TYPE_SYNCHRO)
end  