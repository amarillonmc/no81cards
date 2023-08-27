--幻想童话动物家族
local m=82209177
local cm=c82209177
function cm.initial_effect(c)
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_BEAST),3,4,cm.ovfilter,aux.Stringid(m,0),4,cm.xyzop)  
	c:EnableReviveLimit()  
	--handes  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,2))  
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)  
	e1:SetProperty(EFFECT_FLAG_DELAY)  
	e1:SetCode(EVENT_TO_HAND)  
	e1:SetRange(LOCATION_MZONE)  
	e1:SetCountLimit(1)  
	e1:SetCondition(cm.hdcon)  
	e1:SetTarget(cm.hdtg)  
	e1:SetOperation(cm.hdop)  
	c:RegisterEffect(e1)  
	--cannot target  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_SINGLE)  
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)  
	e2:SetValue(aux.tgoval)  
	c:RegisterEffect(e2)  
	--special summon
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE)  
	e3:SetType(EFFECT_TYPE_QUICK_O)  
	e3:SetCode(EVENT_CHAINING)  
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)  
	e3:SetRange(LOCATION_MZONE)  
	e3:SetCondition(cm.spcon)  
	e3:SetCost(cm.spcost)  
	e3:SetTarget(cm.sptg)  
	e3:SetOperation(cm.spop)  
	c:RegisterEffect(e3)  
end

--material
function cm.cfilter(c)
	return c:IsFacedown() or not c:IsRace(RACE_BEAST)
end
function cm.ovfilter(c)  
	return c:IsFaceup() and c:IsSetCard(0x146) and c:IsType(TYPE_XYZ) and c:IsRank(2) 
end  
function cm.xyzop(e,tp,chk)  
	if chk==0 then return Duel.GetFlagEffect(tp,m)==0 and not Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil) end  
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)  
end 

--handes
function cm.hdfilter(c,tp)
	return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp
		and c:IsPreviousSetCard(0x146) and c:IsControler(tp)
end
function cm.hdcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.hdfilter,1,nil,tp)
end
function cm.hdtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_HAND,1,nil) end 
end  
function cm.hdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_HAND,nil)  
	if g:GetCount()>0 then  
		local sg=g:RandomSelect(tp,1)  
		local sc=sg:GetFirst()
		if sc:IsForbidden() or (not sc:IsCanOverlay()) then
			Duel.SendtoGrave(sc,REASON_RULE)
		else 
			Duel.Overlay(c,sc) 
		end
	end  
end  

--special summon
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and rp==1-tp
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end  
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)  
end  
function cm.spfilter(c,e,tp)  
	return c:IsSetCard(0x146) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) and (c:GetAttack()>0 or c:GetDefense()>0)
end  
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)  
end  
function cm.spop(e,tp,eg,ep,ev,re,r,rp)  
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)  
	local tc=g:GetFirst()  
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then 
		local atk=tc:GetAttack()
		local def=tc:GetDefense()
		if def>atk then atk=def end
		if atk~=0 then
			Duel.Damage(1-tp,atk,REASON_EFFECT)
		end
	end
end