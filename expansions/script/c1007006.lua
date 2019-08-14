--纯粹的魔女·久远寺有珠
function c1007006.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(1,0)
	e1:SetCondition(c1007006.sccon)
	e1:SetTarget(c1007006.splimit)
	c:RegisterEffect(e1)
	--tohand1
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c1007006.decon)
	e2:SetTarget(c1007006.detg)
	e2:SetOperation(c1007006.deop)
	c:RegisterEffect(e2)
	--act
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c1007006.sscost)
	e3:SetTarget(c1007006.detg)
	e3:SetOperation(c1007006.deop)
	c:RegisterEffect(e3)
	--ritual material
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_EXTRA_RITUAL_MATERIAL)
	e4:SetValue(c1007006.mtval)
	c:RegisterEffect(e3)
	--spsummon
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetRange(LOCATION_GRAVE+LOCATION_EXTRA)
	e5:SetCountLimit(1,17006)
	e5:SetCondition(c1007006.spcon1)
	e5:SetTarget(c1007006.sptg1)
	e5:SetOperation(c1007006.spop1)
	c:RegisterEffect(e5)
	--atk down
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCategory(CATEGORY_TOKEN)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e6:SetCode(EVENT_TO_GRAVE)
	e6:SetCondition(c1007006.tkcon)
	e6:SetTarget(c1007006.tktg)
	e6:SetOperation(c1007006.tkop)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e7) 
end
function c1007006.mtval(e,c)
	return c:IsSetCard(0x20f)
end
function c1007006.sccon(e)
	return not Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_PZONE,0,1,e:GetHandler(),0x20f)
end
function c1007006.splimit(e,c)
	return not c:IsSetCard(0x20f)
end
function c1007006.pxfilter(c)
	return c:IsSetCard(0xa20f) and not c:IsCode(1007006)
end
function c1007006.decon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c1007006.pxfilter,tp,LOCATION_PZONE,0,1,e:GetHandler())
end
function c1007006.filter11(c,tp)
	return c:IsSetCard(0x320f) and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and c:GetActivateEffect():IsActivatable(tp)
end
function c1007006.detg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1007006.filter11,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) end
end
function c1007006.deop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1007006,3))
	local tc=Duel.SelectMatchingCard(tp,c1007006.filter11,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
	if tc and (tc:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0) then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local te=tc:GetActivateEffect()
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		Duel.RaiseEvent(tc,EVENT_CHAIN_SOLVED,te,0,tp,tp,Duel.GetCurrentChain())
	end
end
function c1007006.cfilter(c,tp)
	return c:IsSetCard(0xa20f) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:GetPreviousControler()==tp
end
function c1007006.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c1007006.cfilter,1,nil,tp)
end
function c1007006.thcon(e,tp,eg,ep,ev,re,r,rp)
	local st=e:GetHandler():GetSummonType()
	return (st>=(SUMMON_TYPE_SPECIAL+350) and st<(SUMMON_TYPE_SPECIAL+360)) or st==SUMMON_TYPE_PENDULUM 
end
function c1007006.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c1007006.spop1(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),357,tp,tp,false,false,POS_FACEUP)
	end
end
function c1007006.sscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c1007006.tkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_COST) and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_MONSTER)
	and re:GetHandler():IsSetCard(0x20f)
		and c:IsPreviousLocation(LOCATION_OVERLAY)
end
function c1007006.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,1007022,0,0x4011,300,300,1,RACE_WINDBEAST,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c1007006.tkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=1 then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,1007022,0,0x4011,300,300,1,RACE_WINDBEAST,ATTRIBUTE_DARK) then
		local token=Duel.CreateToken(tp,1007022)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_IGNITION)
		e1:SetRange(LOCATION_MZONE)
		e1:SetTarget(c1007006.setg)
		e1:SetOperation(c1007006.seop)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		token:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetDescription(aux.Stringid(1007016,0))
		e2:SetCategory(CATEGORY_RECOVER)
		e2:SetType(EFFECT_TYPE_IGNITION)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCost(c1007006.recost)
		e2:SetTarget(c1007006.rectg)
		e2:SetOperation(c1007006.recop)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		token:RegisterEffect(e2)
	end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,1007022,0,0x4011,300,300,1,RACE_SPELLCASTER,ATTRIBUTE_FIRE) then
		local token=Duel.CreateToken(tp,1007022)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		e1:SetType(EFFECT_TYPE_IGNITION)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCountLimit(1)
		e1:SetTarget(c1007006.setg)
		e1:SetOperation(c1007006.seop)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		token:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetDescription(aux.Stringid(1007016,0))
		e2:SetCategory(CATEGORY_RECOVER)
		e2:SetType(EFFECT_TYPE_IGNITION)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCost(c1007006.recost)
		e2:SetTarget(c1007006.rectg)
		e2:SetOperation(c1007006.recop)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		token:RegisterEffect(e2)
	end
	Duel.SpecialSummonComplete()
end
function c1007006.filter(c)
	return c:IsFacedown() and c:GetSequence()~=5
end
function c1007006.setg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1007006.filter,tp,0,LOCATION_SZONE,1,nil) end
end
function c1007006.seop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c1007006.filter,tp,0,LOCATION_SZONE,nil)
	Duel.ConfirmCards(tp,g)
end
function c1007006.recost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c1007006.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function c1007006.recop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
