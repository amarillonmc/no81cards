--手掌倍化魔术
function c9980856.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetTarget(c9980856.target)
	e1:SetOperation(c9980856.activate)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetCost(aux.bfgcost)
	e2:SetCondition(aux.exccon)
	e2:SetCondition(c9980856.damcon)
	e2:SetTarget(c9980856.damtg)
	e2:SetOperation(c9980856.damop)
	c:RegisterEffect(e2)
end
function c9980856.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x5bc2)
end
function c9980856.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c9980856.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9980856.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c9980856.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c9980856.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(tc:GetAttack()*2)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e2:SetValue(tc:GetDefense()*2)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
		e3:SetCode(EVENT_PRE_BATTLE_DAMAGE)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e3:SetCondition(c9980856.rdcon)
		e3:SetOperation(c9980856.rdop)
		tc:RegisterEffect(e3)
	end
   Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980856,0))
end
function c9980856.rdcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c9980856.rdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev*2)
end
function c9980856.damcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=a:GetBattleTarget()
	e:SetLabelObject(d)
	return a:IsControler(1-tp) and d and d:IsControler(tp)
end
function c9980856.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,9980856)==0 end
end
function c9980856.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	if not tc:IsRelateToBattle() then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetCondition(c9980856.damcon)
	e2:SetOperation(c9980856.damop)
	e2:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e2,tp)
	Duel.RegisterFlagEffect(tp,9980856,RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980856,0))
end
function c9980856.damcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c9980856.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(1-tp,ev*2,REASON_EFFECT)
end
