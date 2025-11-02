--终焉失控磁盘 死亡清道夫
function c95101248.initial_effect(c)
	--fusion material
	aux.AddFusionProcFunFun(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x6bb0),aux.FilterBoolFunction(Card.IsFusionType,TYPE_FUSION),1,true)
	c:EnableReviveLimit()
	--position
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(95101248,0))
	e1:SetCategory(CATEGORY_COIN+CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c95101248.postg)
	e1:SetOperation(c95101248.posop)
	c:RegisterEffect(e1)
	--position
	local e2=Effect.CreateEffect(c)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetDescription(aux.Stringid(95101248,0))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c95101248.poscon)
	e2:SetTarget(c95101248.postg2)
	e2:SetOperation(c95101248.posop2)
	c:RegisterEffect(e2)
	--attack effect:attack
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(95101248,2))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c95101248.atkcon)
	e3:SetCost(c95101248.atkcost)
	e3:SetOperation(c95101248.atkop)
	c:RegisterEffect(e3)
	--defense effect:pierce
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_PIERCE)
	e4:SetCondition(c95101248.defcon)
	e4:SetValue(DOUBLE_DAMAGE)
	c:RegisterEffect(e4)
end
function c95101248.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function c95101248.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local res=Duel.TossCoin(tp,1)
	if res==1 then Duel.ChangePosition(c,POS_FACEUP_ATTACK)
	else Duel.ChangePosition(c,POS_FACEUP_DEFENSE) end
end
function c95101248.poscon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2--Duel.IsMainPhase()
end
function c95101248.postg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsCanChangePosition,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c95101248.posop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local tc=Duel.SelectMatchingCard(tp,Card.IsCanChangePosition,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil):GetFirst()
	if tc then
		Duel.HintSelection(Group.FromCards(tc))
		Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
	end
end
function c95101248.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and aux.nzatk(bc) and bc:IsControler(1-tp) and c:IsAttackPos()
end
function c95101248.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(95101248)==0 end
	e:GetHandler():RegisterFlagEffect(95101248,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL,0,1)
end
function c95101248.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if c:IsFaceup() and c:IsRelateToBattle() and bc and bc:IsFaceup() and bc:IsRelateToBattle() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(bc:GetAttack()*2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL)
		c:RegisterEffect(e1)
	end
end
function c95101248.defcon(e)
	return e:GetHandler():IsDefensePos()
end
