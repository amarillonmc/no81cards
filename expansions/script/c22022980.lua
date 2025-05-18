--人理之灵 间桐脏砚
function c22022980.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22022980,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c22022980.spcon)
	e1:SetTarget(c22022980.sptg1)
	e1:SetOperation(c22022980.spop1)
	c:RegisterEffect(e1)
	--summon success
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetOperation(c22022980.sumsuc)
	c:RegisterEffect(e2)
	--token
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e3:SetDescription(aux.Stringid(22022980,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c22022980.spcost)
	e3:SetTarget(c22022980.sptg)
	e3:SetOperation(c22022980.spop)
	c:RegisterEffect(e3)
end
function c22022980.spfilter(c)
	return c:IsSetCard(0xff1) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c22022980.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c22022980.spfilter,tp,LOCATION_GRAVE,0,1,nil)
end
function c22022980.sptg1(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c22022980.spfilter,tp,LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc then
		e:SetLabelObject(tc)
		return true
	else return false end
end
function c22022980.spop1(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Remove(g,POS_FACEUP,REASON_SPSUMMON)
end
function c22022980.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c22022980.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c22022980.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsType(TYPE_TOKEN)
end
function c22022980.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return e:GetHandler():IsAbleToHandAsCost() and Duel.GetMZoneCount(tp,c)>1 end
	Duel.SendtoHand(e:GetHandler(),nil,REASON_COST)
end
function c22022980.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,22022981,0,TYPES_TOKEN_MONSTER,0,0,1,RACE_INSECT,ATTRIBUTE_DARK) end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,ft,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,ft,0,0)
end
function c22022980.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,22022981,0,TYPES_TOKEN_MONSTER,0,0,1,RACE_INSECT,ATTRIBUTE_DARK) then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local fid=e:GetHandler():GetFieldID()
	local g=Group.CreateGroup()
	for i=1,ft do
		local token=Duel.CreateToken(tp,22022981)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		g:AddCard(token)
	end
	Duel.SpecialSummonComplete()
end