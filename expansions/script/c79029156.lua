--罗德岛·近卫干员-月见夜
function c79029156.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c79029156.ffilter,c79029156.ffilter1,true) 
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)  
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c79029156.val)
	c:RegisterEffect(e1)
	local e2=e1:Clone(c)
	e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
	e2:SetValue(c79029156.val1)
	c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c79029156.reptg)
	e3:SetOperation(c79029156.repop)
	c:RegisterEffect(e3)
	--control
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(31833038,1))
	e4:SetCategory(CATEGORY_CONTROL)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLE_START)
	e4:SetTarget(c79029156.cttg)
	e4:SetOperation(c79029156.ctop)
	c:RegisterEffect(e4)
end
function c79029156.ffilter(c)
	 return c:IsSetCard(0xa900) and c:IsLevelBelow(4)
end
function c79029156.ffilter1(c)
	 return c:IsSetCard(0xa900) and c:IsType(TYPE_PENDULUM)
end
function c79029156.val(e,c)
	 return e:GetHandler():GetMaterial():GetSum(Card.GetBaseAttack)
end
function c79029156.val1(e,c)
	 return e:GetHandler():GetMaterial():GetSum(Card.GetBaseDefense)
end
function c79029156.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=Duel.GetAttackTarget()
	if chk==0 then
		return tc and tc:IsControlerCanBeChanged(false)
	end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,tc,1,0,0)
end
function c79029156.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=c:GetBattleTarget()
	if Duel.GetControl(tc,tp)~=0 then
	tc:RegisterFlagEffect(79029156,RESET_EVENT+RESETS_STANDARD,0,1)
   end
end
function c79029156.filter(c,tp)
	return c:GetFlagEffect(79029156)~=0
end
function c79029156.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029156.filter,tp,LOCATION_MZONE,0,1,nil) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),79029096)
end
function c79029156.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c79029156.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	Duel.SendtoGrave(tc,REASON_EFFECT+REASON_REPLACE)
end

