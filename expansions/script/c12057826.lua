--离子炮龙-风型
function c12057826.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit() 
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
	if not c12057826.global_check then
		c12057826.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c12057826.checkop)
		Duel.RegisterEffect(ge1,0)
	end 
end  
function c12057826.gckfil(c) 
	return c:IsSummonLocation(LOCATION_EXTRA) 
end 
function c12057826.checkop(e,tp,eg,ep,ev,re,r,rp) 
	local dg=eg:Filter(c12057826.gckfil,nil) 
	local tc=dg:GetFirst()
	while tc do 
		Duel.RegisterFlagEffect(tc:GetSummonPlayer(),12057826,RESET_PHASE+PHASE_END,0,1)
		tc=dg:GetNext()
	end
end
function c12057826.fuslimit(e,c,sumtype)
	return sumtype==SUMMON_TYPE_FUSION
end
function c12057826.filter(c)
	return c:IsPosition(POS_FACEUP_ATTACK) and c:IsCanChangePosition()
end
function c12057826.sptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	local c=e:GetHandler()
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0,nil)<Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE,nil) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetFlagEffect(tp,12057826)<=1 end 
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CHANGE_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(0,1)
	e3:SetValue(0)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e4:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e4,tp)
	local g=Duel.GetMatchingGroup(c12057826.filter,tp,0,LOCATION_MZONE,nil) 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)  
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetTargetRange(1,0)
	e2:SetLabel(c12057826.getsummoncount(tp))
	e2:SetTarget(c12057826.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
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
	local c=e:GetHandler()
	if chk==0 then return Duel.GetFlagEffect(tp,12057826)<=1 end 
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CHANGE_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(0,1)
	e3:SetValue(0)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e4:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e4,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetTargetRange(1,0)
	e2:SetLabel(c12057826.getsummoncount(tp))
	e2:SetTarget(c12057826.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end 
function c12057826.getsummoncount(tp)
	return Duel.GetCustomActivityCount(12057826,tp,ACTIVITY_SPSUMMON) 
end
function c12057826.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c12057826.getsummoncount(sump)>e:GetLabel() and c:IsLocation(LOCATION_EXTRA) 
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






