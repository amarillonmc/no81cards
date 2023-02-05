--魔惧会不旋球手 贾米尔
local m=40010758
local cm=_G["c"..m]
cm.named_with_Diablotherhood=1
function cm.Diablotherhood(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Diablotherhood
end
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_FIEND),2,2,cm.lcheck)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.spcon)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(500)
	e2:SetCondition(cm.atkcon1)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetCondition(cm.atkcon1)
	e3:SetValue(1)
	c:RegisterEffect(e3)   
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(1000)
	e2:SetCondition(cm.atkcon2)
	c:RegisterEffect(e2) 
end
function cm.atkcon1(e)
	return e:GetHandler():IsLinkState()
end
function cm.atkcon2(e)
	local tp=e:GetHandlerPlayer()
	return e:GetHandler():IsLinkState() and Duel.GetFlagEffect(tp,40010756)>0
end
function cm.dfilter(c)
	return c:IsFaceup() and c:IsCode(40010230)
end
function cm.lfilter(c)
	return cm.Diablotherhood(c)
end
function cm.lcheck(g,lc)
	return g:IsExists(cm.lfilter,1,nil)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function cm.spfilter(c,e,tp,zone)
	return cm.Diablotherhood(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local zone=bit.band(e:GetHandler():GetLinkedZone(tp),0x1f)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.spfilter(chkc,e,tp,zone) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,zone) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,cm.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,zone)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local zone=bit.band(e:GetHandler():GetLinkedZone(tp),0x1f)
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and zone~=0 then
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,zone)~=0 and (Duel.GetFlagEffect(tp,40009560)>0 or Duel.IsExistingMatchingCard(cm.dfilter,tp,LOCATION_MZONE,0,1,nil)) and Duel.IsExistingMatchingCard(nil,tp,LOCATION_REMOVED,0,3,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local sg=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_REMOVED,0,3,3,nil)
			Duel.HintSelection(sg)
			Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		end
	end

end



