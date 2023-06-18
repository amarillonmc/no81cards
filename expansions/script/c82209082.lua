--树植怪
local m=82209082
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,m)  
	--Activate  
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
	e1:SetTarget(aux.TRUE)
	e1:SetCondition(cm.con)
	e1:SetValue(2000)  
	c:RegisterEffect(e1)  
	local e2=e1:Clone()  
	e2:SetCode(EFFECT_UPDATE_DEFENSE)  
	c:RegisterEffect(e2)  
	--atk&def  
	local e3=e1:Clone()
	e3:SetTargetRange(0,LOCATION_MZONE)  
	e3:SetValue(-2000)  
	c:RegisterEffect(e3)  
	local e4=e3:Clone()  
	e4:SetCode(EFFECT_UPDATE_DEFENSE)  
	c:RegisterEffect(e4)  
	--spsummon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,0))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_BATTLE_DESTROYED)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(cm.spcon)
	e5:SetTarget(cm.sptg)
	e5:SetOperation(cm.spop)
	c:RegisterEffect(e5)
end
function cm.con(e)
	local ph=Duel.GetCurrentPhase()
	--Debug.Message(ph)
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE 
end
function cm.spfilter(c,tp)  
	return c:IsReason(REASON_BATTLE) and c:IsLocation(LOCATION_GRAVE) and c:GetPreviousControler()==tp
end  
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)  
	return eg:IsExists(cm.spfilter,1,nil,tp) and Duel.GetAttacker():IsControler(1-tp)  
end  
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  
		and Duel.IsPlayerCanSpecialSummonMonster(tp,m,nil,0x11,16000,16000,12,RACE_PLANT,ATTRIBUTE_LIGHT) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)  
end  
function cm.spop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not c:IsRelateToEffect(e) then return end   
	if Duel.IsPlayerCanSpecialSummonMonster(tp,m,nil,0x11,16000,16000,12,RACE_PLANT,ATTRIBUTE_LIGHT) then  
		c:AddMonsterAttribute(TYPE_NORMAL)  
		Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)  
	end
end