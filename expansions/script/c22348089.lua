--墓 园 浅 层
local m=22348089
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c22348089.spop)
	c:RegisterEffect(e1)
	--SpecialSummon
	--local e2=Effect.CreateEffect(c)
	--e2:SetDescription(aux.Stringid(22348089,0))
	--e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	--e2:SetType(EFFECT_TYPE_QUICK_O)
	--:SetCode(EVENT_FREE_CHAIN)
	--e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	--e2:SetRange(LOCATION_FZONE)
	--e2:SetCountLimit(1,22348089)
	--e2:SetCost(c22348089.spcost)
	--e2:SetTarget(c22348089.sptg)
	--e2:SetOperation(c22348089.spop)
	--c:RegisterEffect(e2)
	--changename
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22348089,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_BATTLED)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTarget(c22348089.cntg)
	e3:SetOperation(c22348089.cnop)
	c:RegisterEffect(e3)
	--Activate2
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(22348089,0))
	e4:SetCategory(CATEGORY_LEAVE_GRAVE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,22348089)
	e4:SetCondition(c22348089.accon)
	e4:SetCost(c22348089.accost)
	e4:SetTarget(c22348089.actg)
	e4:SetOperation(c22348089.acop)
	c:RegisterEffect(e4)
end
function c22348089.cfilter(c)
	return c:IsSetCard(0x703) and c:IsAbleToGraveAsCost() and Duel.GetMZoneCount(tp,c)>0
end
function c22348089.spfilter(c,e,tp)
	return c:IsSetCard(0x703) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22348089.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348089.cfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c22348089.cfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c22348089.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348089.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c22348089.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c22348089.spfilter),tp,LOCATION_GRAVE,0,nil,e,tp)
	if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(22348089,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		if sg:GetCount()>0 then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c22348089.cntg(e,tp,eg,ep,ev,re,r,rp,chk)
	local a,d=Duel.GetBattleMonster(tp)
	if chk==0 then return a and d and a:IsSetCard(0x703) end
end
function c22348089.cnop(e,tp,eg,ep,ev,re,r,rp)
	local a,d=Duel.GetBattleMonster(tp)
	if a and d and a:IsRelateToBattle() and d:IsRelateToBattle() and a:IsSetCard(0x703) then
			local e0=Effect.CreateEffect(e:GetHandler())
			e0:SetType(EFFECT_TYPE_SINGLE)
			e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e0:SetReset(RESET_EVENT+RESETS_STANDARD)
			e0:SetCode(EFFECT_CHANGE_CODE)
			e0:SetValue(22348080)
			d:RegisterEffect(e0)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_RACE)
			e1:SetValue(RACE_ZOMBIE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			d:RegisterEffect(e1)
	end
end
function c22348089.acfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE)
end
function c22348089.accon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22348089.acfilter,1,nil,tp)
end
function c22348089.acccfilter(c)
	return c:IsSetCard(0x703) and c:IsAbleToGraveAsCost()
end
function c22348089.accost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348089.acccfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c22348089.acccfilter,1,1,REASON_COST)
end
function c22348089.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c22348089.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
			Duel.MoveToField(c,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
			local te=c:GetActivateEffect()
			local tep=c:GetControler()
	end
end






