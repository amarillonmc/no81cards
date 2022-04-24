--基因窃取兽
function c12057824.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit() 
	--race and lv 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12057824,0)) 
	e1:SetType(EFFECT_TYPE_QUICK_O) 
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e1:SetCountLimit(1,12057824) 
	e1:SetTarget(c12057824.ratg) 
	e1:SetOperation(c12057824.raop) 
	c:RegisterEffect(e1) 
	--code 
	local e2=Effect.CreateEffect(c)   
	e2:SetDescription(aux.Stringid(12057824,1)) 
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_FREE_CHAIN) 
	e2:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e2:SetCountLimit(1,22057824) 
	e2:SetTarget(c12057824.cdtg) 
	e2:SetOperation(c12057824.cdop) 
	c:RegisterEffect(e2) 
	Duel.AddCustomActivityCounter(12057824,ACTIVITY_SPSUMMON,c12057824.counterfilter)
end
function c12057824.counterfilter(c)
	return not c:IsLocation(LOCATION_EXTRA) 
end
function c12057824.ratg(e,tp,eg,ep,ev,re,r,rp,chk,ckhc)  
	if chk==0 then return true end 
	local lv=Duel.AnnounceLevel(tp) 
	local rc=Duel.AnnounceRace(tp,1,RACE_ALL)  
	e:SetLabel(lv,rc) 
end 
function c12057824.raop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local lv,rc=e:GetLabel() 
	if c:IsRelateToEffect(e) then 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE) 
	e1:SetCode(EFFECT_CHANGE_LEVEL) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetValue(lv) 
	e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
	c:RegisterEffect(e1) 
	local e2=e1:Clone() 
	e2:SetCode(EFFECT_CHANGE_RACE) 
	e2:SetValue(rc) 
	c:RegisterEffect(e2)	  
	end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetTargetRange(1,0)
	e2:SetLabel(c12057824.getsummoncount(tp))
	e2:SetTarget(c12057824.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end   
function c12057824.getsummoncount(tp)
	return Duel.GetCustomActivityCount(12057824,tp,ACTIVITY_SPSUMMON) 
end
function c12057824.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c12057824.getsummoncount(sump)>e:GetLabel() and c:IsLocation(LOCATION_EXTRA) 
end
function c12057824.cdtg(e,tp,eg,ep,ev,re,r,rp,chk,ckhc)  
	if chk==0 then return true end 
	local code=Duel.AnnounceCard(tp)
	e:SetLabel(code) 
end 
function c12057824.cdop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local code=e:GetLabel() 
	if c:IsRelateToEffect(e) then 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE) 
	e1:SetCode(EFFECT_CHANGE_CODE) 
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE) 
	e1:SetValue(code) 
	e1:SetReset(RESET_PHASE+PHASE_END) 
	c:RegisterEffect(e1) 
	end 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c12057824.xsplimit1)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c12057824.xsplimit2)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetTargetRange(1,0)
	e2:SetLabel(c12057824.getsummoncount(tp))
	e2:SetTarget(c12057824.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetTargetRange(1,0)
	e4:SetValue(c12057824.actlimit)
	e4:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e4,tp)
end 
function c12057824.xsplimit1(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_GRAVE+LOCATION_DECK)
end
function c12057824.xsplimit2(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsType(TYPE_FUSION) and not c:IsType(TYPE_SYNCHRO) 
end
function c12057824.actlimit(e,re,tp)
	return re:GetHandler():IsLocation(LOCATION_GRAVE)
end











