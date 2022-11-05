local m=15004322
local cm=_G["c"..m]
cm.name="零场实体-A03"
function cm.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--SearchCard
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,5))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,15004322)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,3))
	e2:SetCategory(CATEGORY_HANDES+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,15004322)
	e2:SetTarget(cm.tptg)
	e2:SetOperation(cm.tpop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,4))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,15004323)
	e3:SetCondition(cm.spcon)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
	--Damage
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1,15004324)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(cm.ztg)
	e4:SetOperation(cm.zop)
	c:RegisterEffect(e4)
end
function cm.thfilter(c)
	return c:IsCode(15000382,15000384) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.tptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 and Duel.GetMZoneCount(tp)~=0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function cm.tpop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)==0 then return end
	if Duel.GetMZoneCount(tp)~=0 and e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.cfilter(c)
	return c:IsFaceup() and c:GetLeftScale()==0
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_PZONE,0,1,nil)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.ztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(400)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,400)
	if Duel.IsPlayerAffectedByEffect(tp,15000385) then
		e:SetCategory(CATEGORY_DAMAGE+CATEGORY_SPECIAL_SUMMON)
	else
		e:GetCategory(CATEGORY_DAMAGE)
	end
end
function cm.sp2filter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0xaf30) and c:IsType(TYPE_PENDULUM) and c:IsLevelBelow(6) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)
end
function cm.zop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
	local b1=(Duel.IsPlayerAffectedByEffect(tp,15000385) and Duel.IsExistingMatchingCard(cm.sp2filter,tp,LOCATION_EXTRA,0,1,nil,e,tp))
	local b2=(Duel.IsPlayerAffectedByEffect(tp,15000383) and Duel.IsExistingMatchingCard(aux.NegateEffectMonsterFilter,tp,0,LOCATION_MZONE,1,nil))
	local op=0
	local op2=7
	if b1 and b2 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,7))
		op=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1),aux.Stringid(m,2))
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,9))
		if op==0 then
			op2=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))+1
		end
		if op==1 then
			op2=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,2))
			if op2==1 then op2=2 end
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,8))
	if b1 and not b2 then
		op=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,2))
		if op==1 then op=2 end
	end
	if b2 and not b1 then
		op=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))+1
	end
	if not b1 and not b2 then
		op=Duel.SelectOption(tp,aux.Stringid(m,2))+2
	end
	if op~=2 then
		Duel.BreakEffect()
		if op==0 then
			cm.z1op(e,tp,eg,ep,ev,re,r,rp)
		end
		if op==1 then
			cm.z2op(e,tp,eg,ep,ev,re,r,rp)
		end
		if op2==0 then
			cm.z1op(e,tp,eg,ep,ev,re,r,rp)
		end
		if op2==1 then
			cm.z2op(e,tp,eg,ep,ev,re,r,rp)
		end
	end
end
function cm.z1op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.sp2filter,tp,LOCATION_EXTRA,0,nil,e,tp)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.z2op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	local dg=Duel.SelectMatchingCard(tp,aux.NegateEffectMonsterFilter,tp,0,LOCATION_MZONE,1,1,nil)
	if dg:GetCount()~=0 then
		local tc=dg:GetFirst()
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end