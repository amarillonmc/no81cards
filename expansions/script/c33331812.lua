--虚景降世 可视化创造
function c33331812.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_WYRM),10,2)
	c:EnableReviveLimit()   
	--token 
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(33331812,1))
	e1:SetType(EFFECT_TYPE_QUICK_O) 
	e1:SetCode(EVENT_FREE_CHAIN)   
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetRange(LOCATION_MZONE)  
	e1:SetCountLimit(1,33331812)
	e1:SetCost(c33331812.tkcost1) 
	e1:SetTarget(c33331812.tktg) 
	e1:SetOperation(c33331812.tkop) 
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(33331812,2))
	e1:SetType(EFFECT_TYPE_QUICK_O) 
	e1:SetCode(EVENT_FREE_CHAIN)   
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetRange(LOCATION_MZONE)  
	e1:SetCountLimit(1,33331812)
	e1:SetCost(c33331812.tkcost2) 
	e1:SetTarget(c33331812.tktg) 
	e1:SetOperation(c33331812.tkop) 
	c:RegisterEffect(e1)
	--SpecialSummon 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_LEAVE_FIELD) 
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP) 
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,13331812)
	e2:SetCondition(c33331812.spcon) 
	e2:SetTarget(c33331812.sptg) 
	e2:SetOperation(c33331812.spop) 
	c:RegisterEffect(e2) 
end 
function c33331812.tkcost1(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	local x=e:GetHandler():RemoveOverlayCard(tp,1,2,REASON_COST) 
	e:SetLabel(x) 
end  
function c33331812.rlfil(c) 
	return c:IsReleasable() and c:IsRace(RACE_WYRM)   
end 
function c33331812.rlgck(g,tp) 
	return Duel.GetMZoneCount(tp,g)>0  
end 
function c33331812.tkcost2(e,tp,eg,ep,ev,re,r,rp,chk)   
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE) 
	local g=Duel.GetMatchingGroup(c33331812.rlfil,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
	if chk==0 then return g:CheckSubGroup(c33331812.rlgck,1,2,tp) end 
	local sg=g:SelectSubGroup(tp,c33331812.rlgck,false,1,2,tp)
	e:SetLabel(Duel.Release(sg,REASON_COST)) 
end 
function c33331812.tktg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsPlayerCanSpecialSummonMonster(tp,33331808,0,TYPES_TOKEN_MONSTER,2000,2000,10,RACE_WYRM,ATTRIBUTE_LIGHT) end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,e:GetLabel(),tp,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,e:GetLabel(),tp,0)
end 
function c33331812.tkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local x=e:GetLabel() 
	if x>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>=x and Duel.IsPlayerCanSpecialSummonMonster(tp,33331808,0,TYPES_TOKEN_MONSTER,2000,2000,10,RACE_WYRM,ATTRIBUTE_LIGHT) then 
		for i=1,x do   
		local token=Duel.CreateToken(tp,33331808)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP) 
		end 
	end
end
function c33331812.sckfil(c,tp) 
	return c:IsType(TYPE_TOKEN) and c:IsPreviousControler(tp) and c:GetReasonPlayer()==1-tp  
end 
function c33331812.spcon(e,tp,eg,ep,ev,re,r,rp) 
	return eg:IsExists(c33331812.sckfil,1,nil,tp) 
end 
function c33331812.sptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0) 
end 
function c33331812.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.IsExistingMatchingCard(Card.IsCanOverlay,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) and Duel.SelectYesNo(tp,aux.Stringid(33331812,3)) then
		local og=Duel.SelectMatchingCard(tp,Card.IsCanOverlay,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c)  
		Duel.Overlay(c,og)   
	end 
end 























