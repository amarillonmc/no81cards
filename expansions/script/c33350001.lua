--传说之魂 决心
local m=33350001
local cm=_G["c"..m]
function c33350001.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_DRAW+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetCountLimit(1)
	e1:SetTarget(cm.tdtg)
	e1:SetOperation(cm.tdop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(cm.atkval)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(cm.tgcon)
	e3:SetCost(cm.cost)
	e3:SetTarget(cm.tgtg)
	e3:SetOperation(cm.tgop)
	c:RegisterEffect(e3)
end
cm.setname="TaleSouls"
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if chk==0 then return bc and bc:IsRelateToBattle() and bc:IsAbleToDeck() end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,bc,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,bc,1,0,0)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if not bc:IsRelateToBattle() then return false end
	local off=1
		local ops={}
		local opval={}
		if bc and Duel.IsPlayerCanDraw(tp,1) then
			ops[off]=aux.Stringid(m,0)
			opval[off-1]=1
			off=off+1
		end
		if bc then
			ops[off]=aux.Stringid(m,1)
			opval[off-1]=2
			off=off+1
		end
		local op=Duel.SelectOption(tp,table.unpack(ops))
		if opval[op]==1 then
		Duel.SendtoHand(bc,nil,REASON_EFFECT)
		Duel.Draw(tp,1,REASON_EFFECT)
		elseif opval[op]==2 and c:IsRelateToEffect(e) and c:IsFaceup() then
			Duel.Remove(bc,POS_FACEUP,REASON_EFFECT)
			local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_UPDATE_LEVEL)
		e4:SetValue(1)
		e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e4:SetRange(LOCATION_MZONE)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e4)
		end
end
--效果1
function cm.atkval(e,c)
	return c:GetLevel()*500
end
--效果2
function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLevel(1) and Duel.GetCurrentPhase()~=PHASE_END
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	if Duel.Remove(c,0,REASON_COST+REASON_TEMPORARY)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(c)
		e1:SetCountLimit(1)
		e1:SetOperation(cm.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function cm.spfilter(c,e,tp)
	return c.setname=="TaleSouls" and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLevel(1) and not c:IsCode(m)
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp,e:GetHandler())>0
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp,e:GetHandler())>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
