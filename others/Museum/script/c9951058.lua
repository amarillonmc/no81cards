--光之国敌役-保镖怪兽布莱克王
function c9951058.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x9bd1),2,2)
 --atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c9951058.atkval)
	c:RegisterEffect(e1)
 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c9951058.target)
	e1:SetOperation(c9951058.activate)
	c:RegisterEffect(e1)
--Extra Attack
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9951058,0))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLE_DESTROYING)
	e4:SetCondition(c9951058.atkcon)
	e4:SetTarget(c9951058.atktg)
	e4:SetOperation(c9951058.atkop)
	c:RegisterEffect(e4)
--spsummon bgm
	 local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9951058.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9951058.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951058,0))
end
function c9951058.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x9bd1) and c:GetBaseAttack()>=0
end
function c9951058.atkval(e,c)
	local lg=c:GetLinkedGroup():Filter(c9951058.atkfilter,nil)
	return lg:GetSum(Card.GetBaseAttack)
end
function c9951058.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x9bd1)
end
function c9951058.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c9951058.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9951058.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c9951058.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c9951058.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e2:SetValue(1)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		local fid=tc:GetRealFieldID()
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_FIELD)
		e4:SetCode(EFFECT_MUST_ATTACK_MONSTER)
		e4:SetTargetRange(0,LOCATION_MZONE)
		e4:SetValue(c9951058.atklimit)
		e4:SetLabel(fid)
		e4:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e4,tp)
	end
Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951058,0))
end
function c9951058.atklimit(e,c)
	return c:GetRealFieldID()==e:GetLabel()
end
function c9951058.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker()==e:GetHandler() and aux.bdcon(e,tp,eg,ep,ev,re,r,rp)
end
function c9951058.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToBattle() and not e:GetHandler():IsHasEffect(EFFECT_EXTRA_ATTACK) end
end
function c9951058.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToBattle() then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
	c:RegisterEffect(e1)
Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951058,0))
end