local m=15000355
local cm=_G["c"..m]
cm.name="蜂巢之血·维斯帕"
function cm.initial_effect(c)
	--link summon  
	aux.AddLinkProcedure(c,nil,2,2,cm.lcheck)  
	c:EnableReviveLimit()
	--special summon  
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)  
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)  
	e1:SetProperty(EFFECT_FLAG_DELAY)  
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)  
	e1:SetCountLimit(1,15000355)  
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	--spsummon  
	local e2=Effect.CreateEffect(c)  
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e2:SetType(EFFECT_TYPE_IGNITION)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e2:SetCountLimit(1,15010355)  
	e2:SetCost(cm.spcost)  
	e2:SetTarget(cm.sptg)  
	e2:SetOperation(cm.spop)  
	c:RegisterEffect(e2)
end
function cm.lcheck(g,lc)  
	return g:IsExists(Card.IsRace,1,nil,RACE_INSECT)  
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tp=e:GetHandler():GetControler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,15000356,0,0x4011,1000,1000,3,RACE_INSECT,ATTRIBUTE_FIRE) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,tp,0)
end  
function cm.operation(e,tp,eg,ep,ev,re,r,rp)  
	local tp=e:GetHandler():GetControler()
	local c=e:GetHandler()  
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,15000356,0,0x4011,1000,1000,3,RACE_INSECT,ATTRIBUTE_FIRE) then  
		local token=Duel.CreateToken(tp,15000356)  
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end  
end
function cm.cfilter(c,ft,tp)  
	return ft>0 or (c:IsControler(tp) and c:GetSequence()<5)  
end  
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	local tp=e:GetHandler():GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)  
	if chk==0 then return ft>-1 and Duel.CheckReleaseGroup(tp,cm.cfilter,1,nil,ft,tp) end  
	local g=Duel.SelectReleaseGroup(tp,cm.cfilter,1,1,nil,ft,tp)  
	Duel.Release(g,REASON_COST)  
end  
function cm.spfilter(c,e,tp)  
	return c:IsRace(RACE_INSECT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)  
end  
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	local tp=e:GetHandler():GetControler()
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and cm.spfilter(chkc,e,tp) end  
	if chk==0 then return Duel.IsExistingTarget(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
	local g=Duel.SelectTarget(tp,cm.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)  
end  
function cm.spop(e,tp,eg,ep,ev,re,r,rp)  
	local tp=e:GetHandler():GetControler()
	local tc=Duel.GetFirstTarget()  
	if tc:IsRelateToEffect(e) then  
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)  
	end  
	local e1=Effect.CreateEffect(e:GetHandler())  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)  
	e1:SetTargetRange(1,0)  
	e1:SetTarget(cm.splimit)  
	e1:SetReset(RESET_PHASE+PHASE_END)  
	Duel.RegisterEffect(e1,tp)  
end  
function cm.splimit(e,c,tp,sumtp,sumpos)
	return (c:IsType(TYPE_LINK) and not c:IsRace(RACE_INSECT)) and bit.band(sumtp,SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK 
end