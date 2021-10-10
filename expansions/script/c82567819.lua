--方舟骑士·王棋骑士 阿米娅
function c82567819.initial_effect(c)
	c:SetSPSummonOnce(82567819)
	--xyz summon
	aux.AddXyzProcedure(c,nil,5,3,c82567819.ovfilter,aux.Stringid(82567819,0))
	c:EnableReviveLimit()
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c82567819.atkupcon)
	e1:SetValue(c82567819.atkval)
	c:RegisterEffect(e1)
	--attack all
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(82567819,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,82567819+EFFECT_COUNT_CODE_DUEL)
	e2:SetCondition(c82567819.condition)
	e2:SetCost(c82567819.cost)
	e2:SetOperation(c82567819.operation)
	c:RegisterEffect(e2)
	--add to XYZmaterial
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_BATTLE_DESTROYING)
	e4:SetCondition(c82567819.xyzmcon)
	e4:SetOperation(c82567819.xyzmop)
	c:RegisterEffect(e4)
	--Amiya change
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(82567819,2))
	e7:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCost(c82567819.spcost)
	e7:SetTarget(c82567819.sptg)
	e7:SetOperation(c82567819.spop)
	c:RegisterEffect(e7)
end
function c82567819.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsAbleToEnterBP() and not e:GetHandler():IsHasEffect(EFFECT_ATTACK_ALL)
end
function c82567819.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x5825,1,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x5825,1,REASON_COST) 
end
function c82567819.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ATTACK_ALL)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_IMMUNE_EFFECT)
		e4:SetValue(c82567819.efilter)
		e4:SetOwnerPlayer(tp)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e4)
	end
end
function c82567819.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer() and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) 
end
function c82567819.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa826) 
end
function c82567819.atkupcon(e)
	return Duel.GetTurnPlayer()==e:GetHandlerPlayer()
end
function c82567819.atkval(e,c)
	return c:GetOverlayCount()*500
end
function c82567819.olfilter(c)
	return  c:IsSetCard(0x825) 
end
function c82567819.oltg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(c82567819.olfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local g=Duel.SelectTarget(tp,c82567819.olfilter,tp,LOCATION_REMOVED,0,1,1,nil)
end
function c82567819.olop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
		if g:GetCount()>0 then
			Duel.Overlay(c,g)
		end
	end
end
function c82567819.atktval(e,c,tp)
	local tp=e:GetHandlerPlayer()
	return Duel.GetCounter(tp,LOCATION_ONFIELD,0,0x5825)-1
end
function c82567819.xyzmcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and bc:IsLocation(LOCATION_GRAVE) and bc:IsType(TYPE_MONSTER)
end
function c82567819.xyzmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	local atk=bc:GetAttack()/2
	if c:IsRelateToEffect(e) then
	local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		bc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetValue(RESET_TURN_SET)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		bc:RegisterEffect(e3)
			Duel.Overlay(c,bc)
	Duel.Damage(tp,500,REASON_EFFECT)
	end
end

function c82567819.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and rp==1-tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function c82567819.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c82567819.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if  re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	end
end
function c82567819.disop(e,tp,eg,ep,ev,re,r,rp)
	 Duel.NegateActivation(ev) 
end
function c82567819.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c82567819.spfilter(c,e,tp,mc)
	return  c:IsSetCard(0xa826)  and not c:IsType(TYPE_XYZ)  and 
			   c:IsCanBeSpecialSummoned(e,0,tp,true,true) 
	  and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c82567819.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return 
		 Duel.IsExistingMatchingCard(c82567819.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA) 
end
function c82567819.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c82567819.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,e:GetHandler())
	local tc=g:GetFirst()
	if Duel.GetLocationCountFromEx(tp,tp,nil,c)==0 then return end
	if 
		Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)~=0 then
	Duel.BreakEffect()
	 local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c82567819.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	end
   end
end
function c82567819.splimit(e,c)
	return c:IsSetCard(0xa826)
end
