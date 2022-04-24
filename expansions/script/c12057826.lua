--离子炮龙-风型
function c12057826.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsLevelAbove,7),aux.NonTuner(nil),1)
	c:EnableReviveLimit() 
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2) 
	--SpecialSummon
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O) 
	e3:SetCode(EVENT_FREE_CHAIN) 
	e3:SetHintTiming(0,TIMING_END_PHASE+TIMINGS_CHECK_MONSTER) 
	e3:SetRange(LOCATION_GRAVE) 
	e3:SetCountLimit(1,12057826) 
	e3:SetTarget(c12057826.sptg) 
	e3:SetOperation(c12057826.spop) 
	c:RegisterEffect(e3) 
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12057826,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_REMOVE)
	e3:SetCountLimit(1,22057826)
	e3:SetTarget(c12057826.regtg)
	e3:SetOperation(c12057826.regop)
	c:RegisterEffect(e3)
	--cannot release
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE) 
	e4:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e4:SetRange(0xff) 
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e5:SetValue(c12057826.fuslimit)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e6)
	local e7=e4:Clone()
	e7:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e7) 
	--pierce
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_PIERCE)
	e8:SetValue(DOUBLE_DAMAGE)
	c:RegisterEffect(e8)
end 
function c12057826.fuslimit(e,c,sumtype)
	return sumtype==SUMMON_TYPE_FUSION
end
function c12057826.filter(c)
	return c:IsPosition(POS_FACEUP_ATTACK) and c:IsCanChangePosition()
end
function c12057826.sptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0,nil)<Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE,nil) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	local g=Duel.GetMatchingGroup(c12057826.filter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)  
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
	Duel.SetChainLimit(c12057826.chlimit)
end
function c12057826.chlimit(e,ep,tp)
	return tp==ep
end
function c12057826.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local g=Duel.GetMatchingGroup(c12057826.filter,tp,0,LOCATION_MZONE,nil)
		Duel.ChangePosition(g,POS_FACEUP_DEFENSE)
	end 
end
function c12057826.regtg(e,tp,eg,ep,ev,re,r,rp,chk)   
	if chk==0 then return true end 
	Duel.SetChainLimit(c12057826.chlimit)
end 
function c12057826.regop(e,tp,eg,ep,ev,re,r,rp)   
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_BATTLE_START) 
	e1:SetRange(LOCATION_REMOVED)
	e1:SetCountLimit(1)
	e1:SetCondition(c12057826.xspcon)
	e1:SetOperation(c12057826.xspop) 
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN) 
	c:RegisterEffect(e1)
end
function c12057826.xspcon(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()  
	return Duel.GetTurnPlayer()~=tp and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) 
end
function c12057826.xspop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	Duel.Hint(HINT_CARD,0,12057826)
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) 
	local g=Duel.GetMatchingGroup(c12057826.filter,tp,0,LOCATION_MZONE,nil)   
	if g:GetCount()>0 then 
	Duel.ChangePosition(g,POS_FACEUP_DEFENSE) 
	end 
end






