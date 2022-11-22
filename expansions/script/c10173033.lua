--辣鸡嘿白
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
function c10173033.initial_effect(c)
	c:EnableReviveLimit()
	rssf.AddSynchroProcedureSpecial(c,c10173033.matfilter1,nil,nil,aux.NonTuner(nil),1,99)
	--cannot release
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_RELEASE)
	e3:SetTargetRange(0,1)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_TOKEN))
	c:RegisterEffect(e3)
	--cannot attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	c:RegisterEffect(e4)
	--directattack
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_DIRECT_ATTACK)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetCondition(c10173033.rcon)
	c:RegisterEffect(e5)
	--toekn
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(10173033,2))
	e6:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetCondition(c10173033.spcon)
	e6:SetTarget(c10173033.sptg)
	e6:SetOperation(c10173033.spop)
	c:RegisterEffect(e6)
end
function c10173033.rs_synchro_ladian(c, sc, tp)
	return c:IsSynchroType(TYPE_TOKEN), 1
end
function c10173033.lvval(e,c)
	return (1<<16)+lv 
end
function c10173033.matfilter1(c)
	return c:IsSynchroType(TYPE_TUNER) or c:IsSynchroType(TYPE_TOKEN)
end
function c10173033.rcon(e)
	local f=function(c)
		return not c:IsType(TYPE_TOKEN)
	end
	return not Duel.IsExistingMatchingCard(f,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil)
end
function c10173033.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1
end
function c10173033.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,73915052,0,0x4011,0,0,1,RACE_BEAST,ATTRIBUTE_EARTH,POS_FACEUP_DEFENSE)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,73915052,0,0x4011,0,0,1,RACE_BEAST,ATTRIBUTE_EARTH,POS_FACEUP_DEFENSE,1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c10173033.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	local ft1,ft2,tf1,tf2=Duel.GetLocationCount(tp,LOCATION_MZONE),Duel.GetLocationCount(1-tp,LOCATION_MZONE),Duel.IsPlayerCanSpecialSummonMonster(tp,73915052,0,0x4011,0,0,1,RACE_BEAST,ATTRIBUTE_EARTH,POS_FACEUP_DEFENSE),Duel.IsPlayerCanSpecialSummonMonster(tp,73915052,0,0x4011,0,0,1,RACE_BEAST,ATTRIBUTE_EARTH,POS_FACEUP_DEFENSE,1-tp)
	if ft1<=0 or ft2<=0 or not tf1 or not tf2 then return end
	local ct,t,i,p,y,token=math.min(ft1,ft2),{},1,1,1
	for i=1,ct do 
		t[p]=i p=p+1
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(10173033,3))
	local ct2,ct3=Duel.AnnounceNumber(tp,table.unpack(t))
	for i=1,ct2 do
		y=i
		if i==5 then y=math.random(1,4) end
		token=Duel.CreateToken(tp,73915051+y)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		token=Duel.CreateToken(tp,73915051+y)
		Duel.SpecialSummonStep(token,0,tp,1-tp,false,false,POS_FACEUP_DEFENSE)
	end
	Duel.SpecialSummonComplete()
end
