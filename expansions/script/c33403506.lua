--森罗万象第二十乐章 「因子模仿」
local m=33403506
local cm=_G["c"..m]
Duel.LoadScript("c33400000.lua")
function cm.initial_effect(c)
	XY.REZS(c)
   --token
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCondition(cm.con)
	e2:SetCost(cm.cost)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)	
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local ss=Duel.GetTurnCount()
	return Duel.GetFlagEffect(tp,33413501)<ss and  Duel.GetFlagEffect(tp,m+30000)==0 and Duel.GetFlagEffect(tp,33443500)==0
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)  
e:SetLabel(1)
 if chk==0 then return true end
   local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.splimit)
	Duel.RegisterEffect(e1,tp)
end
function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not se:GetHandler():IsSetCard(0x5349)and  not c:IsCode(33403500)
end
function cm.filter(c,e,tp)
	local n=1
	if c:IsType(TYPE_XYZ) then n=c:GetRank() end 
	if c:IsType(TYPE_LINK) then n=c:GetLink() end 
	if not (c:IsType(TYPE_XYZ) or  c:IsType(TYPE_LINK)) then n=c:GetLevel() end 
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,33403511,0,0x4011,c:GetAttack(),c:GetDefense(),n,c:GetRace(),c:GetAttribute())
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and cm.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.filter,tp,0,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,1,nil,e,tp) end   
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	if e:GetLabel()==1 then 
	Duel.RegisterFlagEffect(tp,m+20000,RESET_PHASE+PHASE_END,0,1) --t1
	Duel.RegisterFlagEffect(tp,33413501,RESET_PHASE+PHASE_END,0,1) --t1+t2
	Duel.RegisterFlagEffect(tp,33403501,0,0,0)  
	e:SetLabel(2)
	end
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not Duel.IsExistingMatchingCard(cm.filter,tp,0,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,1,nil,e,tp)  then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,0,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,1,1,nil,e,tp)  
	local tc=g:GetFirst()
	local n=1
	if tc:IsType(TYPE_XYZ) then n=tc:GetRank() end 
	if tc:IsType(TYPE_LINK) then n=tc:GetLink() end 
	if not (tc:IsType(TYPE_XYZ) or  tc:IsType(TYPE_LINK)) then n=tc:GetLevel() end 
	local token=Duel.CreateToken(tp,33403511)
	Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetValue(tc:GetAttack())
	e1:SetReset(RESET_EVENT+0x1fe0000)
	token:RegisterEffect(e1,true)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	e2:SetValue(tc:GetDefense())
	token:RegisterEffect(e2,true)
	local e4=e1:Clone()
	e4:SetCode(EFFECT_CHANGE_RACE)
	e4:SetValue(tc:GetRace())
	token:RegisterEffect(e4,true)
	local e5=e1:Clone()
	e5:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e5:SetValue(tc:GetAttribute())
	token:RegisterEffect(e5,true)
	local e6=e1:Clone()
	e6:SetCode(EFFECT_CHANGE_LEVEL)
	e6:SetValue(n)
	token:RegisterEffect(e6,true)
	local e7=e1:Clone()
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e7:SetCode(EFFECT_CHANGE_CODE)
	e7:SetValue(tc:GetCode())
	token:RegisterEffect(e7,true)
	token:CopyEffect(tc:GetCode(),RESET_EVENT+0xfe0000,1)
	if tc:IsType(TYPE_EFFECT) then 
		local e8=e1:Clone()
		e8:SetCode(EFFECT_ADD_TYPE)
		e8:SetValue(TYPE_EFFECT)
		token:RegisterEffect(e8,true)
	end
	Duel.SpecialSummonComplete()
end
