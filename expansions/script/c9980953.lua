--幽灵骑士Specter·深渊魂/激昂模式
function c9980953.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_SPIRIT),aux.NonTuner(Card.IsSetCard,0xcbc2),1)
	c:EnableReviveLimit()
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e4)
	--damage val
	local e5=e3:Clone()
	e5:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	c:RegisterEffect(e5)
	--damage&recover
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9980953,1))
	e3:SetCategory(CATEGORY_DAMAGE+CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_DAMAGE_STEP_END)
	e3:SetTarget(c9980953.damtg)
	e3:SetOperation(c9980953.damop)
	c:RegisterEffect(e3)
	--return
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9980953,2))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c9980953.retcon1)
	e3:SetTarget(c9980953.rettg)
	e3:SetOperation(c9980953.retop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(0)
	e4:SetCondition(c9980953.retcon2)
	c:RegisterEffect(e4)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9980953.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9980953.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980953,2))
end
function c9980953.retcon1(e,tp,eg,ep,ev,re,r,rp)
	local f1=Duel.GetFieldCard(0,LOCATION_SZONE,5)
	local f2=Duel.GetFieldCard(1,LOCATION_SZONE,5)
	return not ((f1==nil or f1:IsFacedown()) and (f2==nil or f2:IsFacedown()))
end
function c9980953.retcon2(e,tp,eg,ep,ev,re,r,rp)
	local f1=Duel.GetFieldCard(0,LOCATION_SZONE,5)
	local f2=Duel.GetFieldCard(1,LOCATION_SZONE,5)
	return (f1==nil or f1:IsFacedown()) and (f2==nil or f2:IsFacedown())
end
function c9980953.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c9980953.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
	if c:IsLocation(LOCATION_EXTRA) then
		local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
		Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980953,3))
	end
end
function c9980953.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetAttackTarget()~=nil end
	local bc=e:GetHandler():GetBattleTarget()
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,bc:GetAttack()+bc:GetDefense())
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,bc:GetAttack()+bc:GetDefense())
end
function c9980953.damop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	local atk=bc:GetAttack()
	local def=bc:GetDefense()
	if atk<0 then atk=0 end
	if def<0 then def=0 end
	Duel.Damage(1-tp,atk+def,REASON_EFFECT,true)
	Duel.Recover(tp,atk+def,REASON_EFFECT,true)
	Duel.RDComplete()
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980953,3))
end