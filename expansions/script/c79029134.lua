--维多利亚·医疗干员-微风
function c79029134.initial_effect(c)
	 aux.EnablePendulumAttribute(c)
	 --synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()  
	--Recover
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetCondition(c79029134.atkcon)
	e1:SetTarget(c79029134.atktg)
	e1:SetOperation(c79029134.atkop)
	c:RegisterEffect(e1)   
	--heal
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,79029134)
	e2:SetCost(c79029134.cost)
	e2:SetTarget(c79029134.destg)
	e2:SetOperation(c79029134.desop)
	c:RegisterEffect(e2)
	--pendulum
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(90036274,2))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCondition(c79029134.pencon)
	e3:SetTarget(c79029134.pentg)
	e3:SetOperation(c79029134.penop)
	c:RegisterEffect(e3)
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c79029134.thtg)
	e4:SetOperation(c79029134.thop)
	c:RegisterEffect(e4)
	--splimit
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_PZONE)
	e5:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e5:SetTargetRange(1,0)
	e5:SetTarget(c79029134.splimit)
	c:RegisterEffect(e5)   
	--special summon
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_PZONE)
	e6:SetCost(c79029134.spcost)
	e6:SetTarget(c79029134.sptg)
	e6:SetOperation(c79029134.spop)
	c:RegisterEffect(e6) 
end
function c79029134.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function c79029134.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,0)
end
function c79029134.atkop(e,tp,eg,ep,ev,re,r,rp)
	local rt=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)*800
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Recover(p,rt,REASON_EFFECT)
end
function c79029134.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0xa900) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c79029134.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x1099,5,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x1099,5,REASON_COST)
end
function c79029134.desfilter2(c,s,tp)
	local seq=c:GetSequence()
	return seq<5 and  math.abs(seq-s)==1 and c:IsControler(tp)
end
function c79029134.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return c:IsDestructable() and g:GetCount()>0 end
	local tc=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
end
function c79029134.desop(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetFirstTarget()
	local seq=a:GetSequence()
		local dg=Group.CreateGroup()
		if seq<5 then dg=Duel.GetMatchingGroup(c79029134.desfilter2,tp,LOCATION_MZONE,0,nil,seq,a:GetControler()) end
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_UPDATE_ATTACK)
		e4:SetValue(1000)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
		a:RegisterEffect(e4)
		local e5=e4:Clone()
		e5:SetCode(EFFECT_UPDATE_DEFENSE)
		a:RegisterEffect(e5)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
		e3:SetRange(LOCATION_MZONE)
		e3:SetValue(1)
		a:RegisterEffect(e3)
		local e4=e3:Clone()
		e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		a:RegisterEffect(e4)
		local tc=dg:GetFirst()
		while tc do
		local e6=Effect.CreateEffect(e:GetHandler())
		e6:SetType(EFFECT_TYPE_SINGLE)
		e6:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e6:SetRange(LOCATION_MZONE)
		e6:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
		e6:SetValue(1)
		tc:RegisterEffect(e6)
		local e7=e6:Clone()
		e7:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		tc:RegisterEffect(e7)
		tc=dg:GetNext()
end 
end 
function c79029134.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c79029134.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c79029134.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function c79029134.thfilter(c)
	return c:IsSetCard(0xa900) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end 
function c79029134.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029134.thfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
end
function c79029134.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c79029134.thfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c79029134.cfilter1(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xa900) and c:IsType(TYPE_TUNER) and c:IsAbleToGraveAsCost() and c:IsLevelBelow(7)
		and Duel.IsExistingMatchingCard(c79029134.cfilter2,tp,LOCATION_MZONE,0,1,c,c:GetLevel())
end
function c79029134.cfilter2(c,lv)
	return c:IsFaceup() and not c:IsType(TYPE_TUNER) and c:IsLevel(7-lv) and c:IsAbleToGraveAsCost()
end
function c79029134.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029134.cfilter1,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c79029134.cfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingCard(tp,c79029134.cfilter2,tp,LOCATION_MZONE,0,1,1,g1:GetFirst(),g1:GetFirst():GetLevel())
	g1:Merge(g2)
	Duel.SendtoGrave(g1,REASON_COST)
end
function c79029134.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c79029134.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end






