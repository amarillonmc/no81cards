--方舟骑士·寻理者之壁 塞雷娅
function c82567817.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,c82567817.synfilter,1)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--plimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetTargetRange(1,0)
	e2:SetCondition(c82567817.pcon)
	e2:SetTarget(c82567817.splimit)
	c:RegisterEffect(e2)
	--SynchroSummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c82567817.syncost)
	e3:SetTarget(c82567817.syntarget)
	e3:SetOperation(c82567817.synactivate)
	c:RegisterEffect(e3)
	--battle target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e4:SetValue(c82567817.atlimit)
	c:RegisterEffect(e4)
   --special summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(82567817,2))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCost(c82567817.spcost)
	e5:SetTarget(c82567817.sptg)
	e5:SetOperation(c82567817.spop)
	c:RegisterEffect(e5)
	--pendulum
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(82567817,2))
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_DESTROYED)
	e7:SetProperty(EFFECT_FLAG_DELAY)
	e7:SetCondition(c82567817.pencon)
	e7:SetTarget(c82567817.pentg)
	e7:SetOperation(c82567817.penop)
	c:RegisterEffect(e7) 
	--disable search
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_CANNOT_TO_HAND)
	e6:SetRange(LOCATION_MZONE)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetTargetRange(0,1)
	e6:SetTarget(aux.TargetBoolFunction(Card.IsLocation,LOCATION_DECK))
	c:RegisterEffect(e6)
end
function c82567817.synfilter(c)
	return not c:IsType(TYPE_TUNER) 
		and (c:IsType(TYPE_FUSION) or c:IsType(TYPE_RITUAL) or c:IsType(TYPE_SYNCHRO)) and c:IsSetCard(0x825)
end
function c82567817.splimit(e,c,tp,sumtp,sumpos)
	return bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c82567817.pcon(e,c,tp,sumtp,sumpos)
	return Duel.GetCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0x5825)==0
end
function c82567817.cfilter1(c,e,tp)
	return c:IsType(TYPE_TUNER) and c:IsAbleToGraveAsCost()
		and Duel.IsExistingMatchingCard(c82567817.cfilter2,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,e,tp,c)
end
function c82567817.cfilter2(c,e,tp,tc)
	return c:IsAbleToGraveAsCost()
		and Duel.IsExistingMatchingCard(c82567817.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetLevel()+tc:GetLevel(),Group.FromCards(c,tc))
end
function c82567817.spfilter(c,e,tp,lv,mg)
	return  c:IsLevel(lv) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
		and Duel.GetLocationCountFromEx(tp,tp,mg,c)>0 and c:IsLevelBelow(8)
end   
function c82567817.syncost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return Duel.IsExistingMatchingCard(c82567817.cfilter1,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
	local g1=Duel.SelectMatchingCard(tp,c82567817.cfilter1,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
	local g2=Duel.SelectMatchingCard(tp,c82567817.cfilter2,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,e,tp,g1:GetFirst())
	e:SetLabel(g1:GetFirst():GetLevel()+g2:GetFirst():GetLevel())
	g1:Merge(g2)
	Duel.SendtoGrave(g1,nil,0,REASON_COST)
end
function c82567817.syntarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c82567817.synactivate(e,tp,eg,ep,ev,re,r,rp)
	local lv=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c82567817.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lv,nil)
	if g:GetCount()>0 then
	local tc=g:GetFirst()
	 if tc:IsType(TYPE_SYNCHRO) then
		Duel.SpecialSummon(g,SUMMON_TYPE_SYNCHRO,tp,tp,true,true,POS_FACEUP)
		  tc:CompleteProcedure()  
	 else if tc then
		Duel.SpecialSummon(g,SUMMON_TYPE_SYNCHRO,tp,tp,true,true,POS_FACEUP)
	 end
	 end
	end
end
function c82567817.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c82567817.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c82567817.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function c82567817.rhinelab(c)
	return c:IsSetCard(0x3825) and (c:IsLocation(LOCATION_MZONE) or c:IsLocation(LOCATION_GRAVE) or c:IsLocation(LOCATION_PZONE))
end
function c82567817.rlatkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(c82567817.rhinelab,c:GetControler(),LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil)
end
function c82567817.rlatkval(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rl=Duel.GetMatchingGroupCount(c82567817.rhinelab,c:GetControler(),LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
	return rl*200
end
function c82567817.atlimit(e,c)
	return c:IsFaceup() and not (c:GetBaseAttack() <= c:GetBaseDefense()) and c:IsSetCard(0x825)
end
function c82567817.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x5825,1,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x5825,1,REASON_COST)
end
function c82567817.filter(c,e,tp)
	local sa=e:GetHandler()
	local atk=sa:GetAttack()
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsDefenseBelow(atk)
end
function c82567817.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and chkc:IsCanBeSpecialSummoned(e,0,tp,false,false) and chkc:IsDefenseBelow(e:GetHandler():GetAttack()) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and 
	 Duel.IsExistingTarget(c82567817.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectTarget(tp,c82567817.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp) 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,LOCATION_GRAVE)
end
function c82567817.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c82567817.limittg(e,c,tp)
	local t1=Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)
	return t1>=2
end
function c82567817.countval(e,re,tp)
	local t1=Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)
	if t1>=2 then return 0 else return 2-t1 end
end

