--金色奇迹 究极骑士玛格纳兽
function c16349003.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddMaterialCodeList(c,16348001)
	aux.AddXyzProcedure(c,nil,7,3,c16349003.ovfilter,aux.Stringid(16349003,0),3,c16349003.xyzop)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(16349003,1))
	e1:SetCategory(CATEGORY_LEAVE_GRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c16349003.target)
	e1:SetOperation(c16349003.operation)
	c:RegisterEffect(e1)
	--change battle target
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(16349003,2))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,16349003)
	e2:SetCondition(c16349003.cbcon)
	e2:SetTarget(c16349003.cbtg)
	e2:SetOperation(c16349003.cbop)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCountLimit(1,16349003+1)
	e3:SetCondition(c16349003.drcon)
	e3:SetTarget(c16349003.drtg)
	e3:SetOperation(c16349003.drop)
	c:RegisterEffect(e3)
end
function c16349003.cfilter(c)
	return c:IsCode(16348055) and c:IsDiscardable()
end
function c16349003.ovfilter(c)
	return c:IsFaceup() and c:IsCode(16348001)
end
function c16349003.xyzop(e,tp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c16349003.cfilter,tp,LOCATION_HAND,0,1,nil)
		and Duel.GetFlagEffect(tp,16349003)==0 end
	Duel.DiscardHand(tp,c16349003.cfilter,1,1,REASON_COST+REASON_DISCARD,nil)
	Duel.RegisterFlagEffect(tp,16349003,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c16349003.pfilter(c,tp)
	return c:IsCode(16349051) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c16349003.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c16349003.pfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) end
end
function c16349003.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c16349003.pfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
	if tc then Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) end
end
function c16349003.cbcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and Duel.GetAttackTarget()~=e:GetHandler()
		and e:GetHandler():IsPosition(POS_FACEUP_ATTACK)
end
function c16349003.cbtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,e:GetHandler(),1,0,0)
end
function c16349003.cbop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.NegateAttack() and c:IsRelateToEffect(e) and c:IsPosition(POS_FACEUP_ATTACK) then
		if Duel.ChangePosition(c,POS_FACEUP_DEFENSE)>0 then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetRange(LOCATION_MZONE)
		e2:SetTargetRange(0,LOCATION_MZONE)
		e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e2:SetValue(c16349003.atlimit)
		c:RegisterEffect(e2)
		end		
	end
end
function c16349003.atlimit(e,c)
	return c~=e:GetHandler()
end
function c16349003.drcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousControler(tp) and c:GetReasonPlayer()==1-tp
end
function c16349003.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c16349003.spfilter(c,e,tp)
	return c:IsCode(16348001) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c16349003.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)>0 then
		local g=Duel.GetMatchingGroup(c16349003.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and #g>0 and Duel.SelectYesNo(tp,aux.Stringid(16349003,4)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,c16349003.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
			if #g>0 then
				Duel.HintSelection(g)
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end