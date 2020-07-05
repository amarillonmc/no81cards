local m=82206027
local cm=_G["c"..m]
cm.name="植占师7-灯台"
function cm.initial_effect(c)
	--synchro summon  
	aux.AddSynchroProcedure(c,cm.synfilter,aux.NonTuner(cm.synfilter),1)  
	c:EnableReviveLimit()
	--kkgk
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,0))  
	e1:SetCategory(CATEGORY_POSITION)  
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e1:SetProperty(EFFECT_FLAG_DELAY)  
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)  
	e1:SetCondition(cm.kkcon)  
	e1:SetTarget(cm.kktg)  
	e1:SetOperation(cm.kkop)  
	c:RegisterEffect(e1)
	--special summon  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,1))  
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e2:SetType(EFFECT_TYPE_IGNITION)  
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetCountLimit(1,m)  
	e2:SetCondition(cm.spcon)  
	e2:SetTarget(cm.sptg)  
	e2:SetOperation(cm.spop)  
	c:RegisterEffect(e2)	 
end
function cm.synfilter(c)  
	return c:IsRace(RACE_PLANT)  
end
function cm.kkcon(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)  
end
function cm.filter(c)  
	return c:IsFacedown()  
end  
function cm.kktg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,0,LOCATION_ONFIELD,1,nil) end  
	local g=Duel.GetMatchingGroup(cm.filter,tp,0,LOCATION_ONFIELD,nil)	
end  
function cm.kkop(e,tp,eg,ep,ev,re,r,rp)  
	local g=Duel.GetMatchingGroup(cm.filter,tp,0,LOCATION_ONFIELD,nil)  
	Duel.ConfirmCards(tp,g)  
end  
function cm.spfilter(c,e,tp)  
	return c:IsSetCard(0x129d) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) and c:IsLevelAbove(1)  
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.GetLP(tp)>Duel.GetLP(1-tp)  
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.spfilter(chkc,e,tp) end  
	if chk==0 then return Duel.GetMZoneCount(tp,e:GetHandler())>0  
		and Duel.IsExistingTarget(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
	local g=Duel.SelectTarget(tp,cm.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)  
end  
function cm.spop(e,tp,eg,ep,ev,re,r,rp)  
	local tc=Duel.GetFirstTarget()  
	if tc:IsRelateToEffect(e) then  
		if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE) then
			local e1=Effect.CreateEffect(e:GetHandler())  
			e1:SetType(EFFECT_TYPE_SINGLE)  
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
			e1:SetCode(EFFECT_UPDATE_LEVEL)  
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)	
			e1:SetValue(1) 
			tc:RegisterEffect(e1)
			Duel.SpecialSummonComplete()
		end
	end  
end  