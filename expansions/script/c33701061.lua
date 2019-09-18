--地球意识 篝
function c33701061.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33701061,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c33701061.spcost)
	e2:SetTarget(c33701061.sptg)
	e2:SetOperation(c33701061.spop)
	c:RegisterEffect(e2)
	--Remove
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c33701061.thcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c33701061.thtg)
	e2:SetOperation(c33701061.thop)
	c:RegisterEffect(e2)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c33701061.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c33701061.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(33701061,2))
end
function c33701061.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c33701061.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,33701059,0,0x4011,0,3000,10,RACE_PLANT,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c33701061.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,33701059,0,0x4011,0,3000,10,RACE_PLANT,ATTRIBUTE_EARTH) then
		local token=Duel.CreateToken(tp,33701059)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP_ATTACK)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		token:RegisterEffect(e1)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_EQUIP)
		e3:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		token:RegisterEffect(e3)
	end
end
function c33701061.cfilter2(c,tp)
	return c:IsType(TYPE_TOKEN) and c:IsReason(REASON_BATTLE) and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp 
end
function c33701061.thcon(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsContains(e:GetHandler()) then return false end
	return eg:IsExists(c33701061.cfilter2,1,nil,tp)
end
function c33701061.rmfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c33701061.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>3 and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>3 and Duel.IsPlayerCanRemove(tp)
		and Duel.IsPlayerCanRemove(1-tp) end
end
function c33701061.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,0,LOCATION_HAND+LOCATION_ONFIELD)>1 and Duel.IsChainDisablable(0)
		and Duel.SelectYesNo(1-tp,aux.Stringid(33701061,1)) then
		Duel.Remove(1-tp,aux.TRUE,2,2,POS_FACEUP,REASON_EFFECT)
		Duel.NegateEffect(0)
		return
	end
	if not Duel.IsPlayerCanRemove(1-tp) then return end
	if not Duel.IsPlayerCanRemove(tp) then return end
	local g1=Duel.GetMatchingGroup(c33701061.rmfilter,1-tp,LOCATION_DECK,0,nil)
	local g2=Duel.GetMatchingGroup(c33701061.rmfilter,tp,LOCATION_DECK,0,nil)
	if g1:GetCount()>3 and g2:GetCount()>3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
		local sg1=g2:Select(tp,4,4,nil)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_CONFIRM)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg2=g1:Select(1-tp,4,4,nil)
		sg1:Merge(sg2)
		Duel.Remove(sg1,POS_FACEUP,REASON_EFFECT)
	end
end
