--Snow de Lapin
function c500007.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c500007.tg)
	e1:SetOperation(c500007.activate)
	c:RegisterEffect(e1)   
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(500007,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,500007)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCost(c500007.scost)
	e2:SetTarget(c500007.stg)
	e2:SetOperation(c500007.sop)
	c:RegisterEffect(e2) 
	--sssss
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(500007,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,500107)
	e3:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e3:SetCost(c500007.scost2)
	e3:SetTarget(c500007.stg2)
	e3:SetOperation(c500007.sop2)
	c:RegisterEffect(e3) 
	Duel.AddCustomActivityCounter(500007,ACTIVITY_CHAIN,c500007.chainfilter)
end
function c500007.chainfilter(re,tp,cid)
	return re:GetActivateLocation()~=LOCATION_MZONE 
end
function c500007.efilterx(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsFaceup()
end
function c500007.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
	   if e:GetLabel()==100 then return 
		 Duel.IsExistingMatchingCard(c500007.efilterx,tp,LOCATION_MZONE,0,1,nil)
	   else
		  return true
	   end
	end
end
function c500007.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c500007.efilterx,tp,LOCATION_MZONE,0,nil)
	if g:GetCount()>0 and Duel.GetCustomActivityCount(500007,tp,ACTIVITY_CHAIN)==0 and (e:GetLabel()==100 or (Duel.GetFlagEffect(tp,500007)==0 and Duel.SelectYesNo(tp,aux.Stringid(500007,0)))) then
		if e:GetLabel()~=100 then
		   Duel.RegisterFlagEffect(tp,500007,RESET_PHASE+PHASE_END,0,1)
		end
		if Duel.GetTurnPlayer()~=tp then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
			e1:SetCode(EFFECT_CANNOT_ACTIVATE)
			e1:SetTargetRange(1,0)
			e1:SetValue(c500007.aclimit)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
		local tc=Duel.SelectMatchingCard(tp,c500007.efilterx,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
		Duel.HintSelection(Group.FromCards(tc))
		local e2=Effect.CreateEffect(c)
		e2:SetCategory(CATEGORY_ATKCHANGE)
		e2:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
		e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		e2:SetCondition(c500007.atkcon)
		e2:SetOperation(c500007.atkop)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCode(EFFECT_IMMUNE_EFFECT)
		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e3:SetValue(c500007.efilter)
		e3:SetOwnerPlayer(tp)
		tc:RegisterEffect(e3)
	end
end
function c500007.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsControler(1-tp)
end
function c500007.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if c:IsRelateToBattle() and c:IsFaceup() and bc:IsRelateToBattle() and bc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
		e1:SetValue(bc:GetAttack())
		c:RegisterEffect(e1)
	end
end
function c500007.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function c500007.aclimit(e,re,tp)
	return re:GetActivateLocation()==LOCATION_MZONE 
end
function c500007.cfilter(c,tp,rc)
	return c:IsType(TYPE_TRAP+TYPE_SPELL) and (c:IsSetCard(0xffac) or c:IsSetCard(0xffad)) and c:IsAbleToDeckAsCost() and c:IsFaceup() and Duel.IsExistingMatchingCard(c500007.setfilter2,tp,LOCATION_GRAVE,0,1,c,rc,tp)
end
function c500007.setfilter2(c)
	return c:IsType(TYPE_TRAP+TYPE_SPELL) and c:IsSSetable() and (c:IsSetCard(0xffac) or c:IsSetCard(0xffad)) and not c:IsCode(500008)
end
function c500007.scost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() and Duel.IsExistingMatchingCard(c500007.cfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,e:GetHandler(),tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c500007.cfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,e:GetHandler(),tp)
	g:AddCard(e:GetHandler())
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c500007.setfilter2(c)
	return c:IsType(TYPE_TRAP+TYPE_SPELL) and c:IsSSetable() and (c:IsSetCard(0xffac) or c:IsSetCard(0xffad))
end
function c500007.stg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c500007.setfilter2,tp,LOCATION_GRAVE,0,1,nil) end
end
function c500007.sop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c500007.setfilter3,tp,LOCATION_GRAVE,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c500007.sop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c500007.setfilter3,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c500007.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c500007.setfilter3,tp,LOCATION_DECK,0,1,nil,tp) and Duel.GetFlagEffect(tp,500007)==0 end
end
function c500007.scost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end