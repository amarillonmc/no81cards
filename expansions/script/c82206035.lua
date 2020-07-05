local m=82206035
local cm=_G["c"..m]
cm.name="植占师15-迷惑"
function cm.initial_effect(c)
	--pendulum summon  
	aux.EnablePendulumAttribute(c)
	--splimit  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetRange(LOCATION_PZONE)  
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)  
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)  
	e1:SetTargetRange(1,0)  
	e1:SetTarget(cm.splimit)  
	c:RegisterEffect(e1)
	--spsummon
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(m,0))  
	e3:SetCategory(CATEGORY_SPSUMMON)  
	e3:SetType(EFFECT_TYPE_IGNITION)  
	e3:SetRange(LOCATION_PZONE)  
	e3:SetCountLimit(1,m)
	e3:SetCost(cm.spcost)
	e3:SetTarget(cm.sptg)  
	e3:SetOperation(cm.spop)  
	c:RegisterEffect(e3)
	--control  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,1))  
	e2:SetCategory(CATEGORY_CONTROL)  
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e2:SetType(EFFECT_TYPE_IGNITION)  
	e2:SetRange(LOCATION_HAND)  
	e2:SetCost(cm.ctcost)  
	e2:SetTarget(cm.cttarget)  
	e2:SetOperation(cm.ctop)  
	c:RegisterEffect(e2)  
end
function cm.splimit(e,c,sump,sumtype,sumpos,targetp)  
	if c:IsRace(RACE_PLANT) then return false end  
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM  
end
function cm.spfilter(c,e,tp)  
	return c:IsSetCard(0x129d) and c:IsFaceup() and c:IsType(TYPE_PENDULUM) and 
	c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(m) 
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end  
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)  
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.GetLocationCountFromEx(tp)>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end   
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)  
end  
function cm.spop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	if c:IsRelateToEffect(e) then  
		if Duel.GetLocationCountFromEx(tp)<1 then return end  
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
		local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)  
		if g:GetCount()>0 then  
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)  
		end  
	end  
end  
function cm.ctcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():IsDiscardable(REASON_COST) end  
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)  
end  
function cm.ctfilter(c)  
	return c:IsFaceup() and c:IsRace(RACE_ZOMBIE) and c:IsControlerCanBeChanged()  
end  
function cm.cttarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and cm.ctfilter(chkc) end  
	if chk==0 then return Duel.IsExistingTarget(cm.ctfilter,tp,0,LOCATION_MZONE,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)  
	local g=Duel.SelectTarget(tp,cm.ctfilter,tp,0,LOCATION_MZONE,1,1,nil)  
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)  
end  
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)  
	local tc=Duel.GetFirstTarget()  
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then  
		if Duel.GetControl(tc,tp)~=0 then
			local e5=Effect.CreateEffect(e:GetHandler())  
			e5:SetType(EFFECT_TYPE_SINGLE)  
			e5:SetCode(EFFECT_CHANGE_RACE)  
			e5:SetValue(RACE_PLANT)  
			e5:SetReset(RESET_EVENT+RESETS_STANDARD)  
			tc:RegisterEffect(e5)
		end
	end  
end  