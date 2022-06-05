--冰晶光芒 艾琳
function c72413170.initial_effect(c)
		--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_NO_TURN_RESET)
	e1:SetCountLimit(1,72413170)
	e1:SetCondition(c72413170.condition)
	e1:SetTarget(c72413170.target)
	e1:SetOperation(c72413170.activate)
	c:RegisterEffect(e1)
		--SpecialSummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(72413170,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,72413171)
	e3:SetCondition(c72413170.spcon)
	e3:SetTarget(c72413170.sptg)
	e3:SetOperation(c72413170.spop)
	c:RegisterEffect(e3)
	if not c72413170.global_check then
		c72413170.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_BATTLED)
		ge1:SetOperation(c72413170.regop)
		Duel.RegisterEffect(ge1,0)
	end
end
--
function c72413170.check(c,e)
	return c and c:GetControler()~=e:GetHandler():GetControler()
end
function c72413170.regop(e,tp,eg,ep,ev,re,r,rp)
	if c72413170.check(Duel.GetAttacker(),e) or c72413170.check(Duel.GetAttackTarget(),e) then
		Duel.RegisterFlagEffect(tp,72413170,RESET_PHASE+PHASE_END,0,1)
	end
end
--
function c72413170.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c72413170.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tg=Duel.GetAttacker()
	if chkc then return chkc==tg end
	if chk==0 then return tg:IsOnField() and tg:IsCanBeEffectTarget(e) end
	Duel.SetTargetCard(tg)
	local rec=tg:GetAttack()
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,rec)
end
function c72413170.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsAttackable() then
		if Duel.NegateAttack(tc) then
			Duel.Recover(tp,tc:GetAttack(),REASON_EFFECT)
		end
	end
end
--
function c72413170.scfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsSynchroSummonable(nil)
end
function c72413170.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(e:GetHandler():GetControler(),72413170)==0
end
function c72413170.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_GRAVE)
end
function c72413170.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then 
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0  and Duel.IsExistingMatchingCard(c72413170.scfilter,tp,LOCATION_EXTRA,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(72413170,0)) then
			local g2=Duel.GetMatchingGroup(c72413170.scfilter,tp,LOCATION_EXTRA,0,nil)
			if g2:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g2:Select(tp,1,1,nil)
			Duel.SynchroSummon(tp,sg:GetFirst(),nil)
			end
		end
	end
end