--黄 皓 剑 圣
local m=22348340
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Remove
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c22348340.rspcon)
	e1:SetTarget(c22348340.rsptg)
	e1:SetOperation(c22348340.rspop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--Destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c22348340.desreptg)
	e3:SetOperation(c22348340.desrepop)
	c:RegisterEffect(e3)
	--damage
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
--	e4:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e4:SetCode(EVENT_BATTLE_DAMAGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e4:SetCondition(c22348340.damcon)
	e4:SetOperation(c22348340.damop)
	c:RegisterEffect(e4)
	
end
function c22348340.damcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and (e:GetHandler()==Duel.GetAttacker() or e:GetHandler()==Duel.GetAttackTarget())
end
function c22348340.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cg=c:GetColumnGroup()
	if #cg==0 then return end
	Duel.Destroy(cg,REASON_EFFECT)
end
function c22348340.rscfilter(c,tp)
	return c:IsSummonPlayer(tp)
end
function c22348340.rspcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22348340.rscfilter,1,nil,1-tp)
end
function c22348340.spfilter(c,e,tp)
	return c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22348340.rsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMZoneCount(tp,c)>0 and c:IsAbleToRemove() and Duel.IsExistingMatchingCard(c22348340.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c22348340.rspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.Remove(c,0,REASON_EFFECT+REASON_TEMPORARY)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
		e1:SetLabelObject(c)
		e1:SetCountLimit(1)
		e1:SetReset(RESET_PHASE+PHASE_BATTLE_START)
		e1:SetOperation(c22348340.retop1)
		Duel.RegisterEffect(e1,tp)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c22348340.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c22348340.retop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local tp=tc:GetControler()
	if Duel.ReturnToField(tc) then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c22348340.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE) and c:IsOnField() and c:IsFaceup() and c:IsAbleToRemove() end
		c:SetStatus(STATUS_DESTROY_CONFIRMED,true)
	return true
end
function c22348340.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.Remove(c,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetReset(RESET_PHASE+PHASE_STANDBY)
		e1:SetLabelObject(c)
		e1:SetCountLimit(1)
		e1:SetOperation(c22348340.retop2)
		Duel.RegisterEffect(e1,tp)
	end
	Duel.Hint(HINT_CARD,0,22348340)
end
function c22348340.retop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end