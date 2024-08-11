--流风回雪 响心艾比
local m=75000016
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,75000001)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,75000016+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c75000016.hspcon)
	e1:SetValue(c75000016.hspval)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,75010016)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c75000016.sptg)
	e2:SetOperation(c75000016.spop)
	c:RegisterEffect(e2)
	--effect gain
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e3:SetCondition(c75000016.efcon)
	e3:SetOperation(c75000016.efop)
	c:RegisterEffect(e3)
	
end
function c75000016.efcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(r,REASON_FUSION)~=0 and c:GetReasonCard():IsRace(RACE_DRAGON)
end
function c75000016.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	--negate
	local e1=Effect.CreateEffect(rc)
	e1:SetDescription(aux.Stringid(75000016,2))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c75000016.reccon)
	e1:SetOperation(c75000016.recop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_ADD_TYPE)
		e3:SetValue(TYPE_EFFECT)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e3,true)
	end
end
function c75000016.reccon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsRelateToBattle()
end
function c75000016.recop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetBattleTarget()
	if tc and tc:IsFaceup() then
		Duel.Damage(1-tp,math.floor(tc:GetBaseAttack()/4),REASON_EFFECT)
	end
end
function c75000016.cfilter(c)
	return (aux.IsCodeListed(c,75000001) or c:IsCode(75000001)) and c:IsFaceup()
end
function c75000016.getzone(tp)
	local zone=0
	local g=Duel.GetMatchingGroup(c75000016.cfilter,tp,LOCATION_MZONE,0,nil)
	for tc in aux.Next(g) do
		local seq=tc:GetSequence()
		if seq==5 or seq==6 then
			zone=zone|(1<<aux.MZoneSequence(seq))
		else
			if seq>0 then zone=zone|(1<<(seq-1)) end
			if seq<4 then zone=zone|(1<<(seq+1)) end
		end
	end
	return zone
end
function c75000016.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local zone=c75000016.getzone(tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0
end
function c75000016.hspval(e,c)
	local tp=c:GetControler()
	return 0,c75000016.getzone(tp)
end
function c75000016.spfilter(c,e,tp,zone)
	return (aux.IsCodeListed(c,75000001) or c:IsCode(75000001)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c75000016.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local zone=0
	local seq=e:GetHandler():GetSequence()
	if seq==5 or seq==6 then
		zone=zone|(1<<aux.MZoneSequence(seq))
	else
		if seq>0 then zone=zone|(1<<(seq-1)) end
		if seq<4 then zone=zone|(1<<(seq+1)) end
	end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c75000016.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp,zone) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c75000016.spop(e,tp,eg,ep,ev,re,r,rp)
	local zone=0
	local seq=e:GetHandler():GetSequence()
	if seq==5 or seq==6 then
		zone=zone|(1<<aux.MZoneSequence(seq))
	else
		if seq>0 then zone=zone|(1<<(seq-1)) end
		if seq<4 then zone=zone|(1<<(seq+1)) end
	end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c75000016.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,zone)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,zone)
	end
end


