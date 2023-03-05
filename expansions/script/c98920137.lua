--于贝尔-陷入绝望的恶魔
function c98920137.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c98920137.hspcon)
	e2:SetOperation(c98920137.hspop)
	c:RegisterEffect(e2)
--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e8:SetValue(1)
	c:RegisterEffect(e8)
--damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920137,0))
	e1:SetCategory(CATEGORY_DAMAGE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLE_CONFIRM)
	e1:SetCondition(c98920137.damcon)
	e1:SetTarget(c98920137.damtg)
	e1:SetOperation(c98920137.damop)
	c:RegisterEffect(e1)
--negate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(98920137,0))
	e4:SetCategory(CATEGORY_DISABLE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c98920137.discon)
	e4:SetOperation(c98920137.disop)
	c:RegisterEffect(e4)
end
function c98920137.rfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_FIEND) and c:IsLevelAbove(10) and c:IsReleasable()
end
function c98920137.hspcon(e,c)
	if c==nil then return true end
	if c:IsHasEffect(EFFECT_NECRO_VALLEY) then return false end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local m=0
	if ft>0 then m=LOCATION_MZONE end
	return ft>-1 and Duel.IsExistingMatchingCard(c98920137.rfilter,tp,LOCATION_MZONE,m,1,nil)
end
function c98920137.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local m=0
	if ft>0 then m=LOCATION_MZONE end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c98920137.rfilter,tp,LOCATION_MZONE,m,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c98920137.damcon(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	return bc and bc:IsControler(1-tp)
end
function c98920137.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,e:GetHandler():GetBattleTarget():GetAttack())
end
function c98920137.damop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetBattleTarget()
	if tc and tc:IsFaceup() and tc:IsControler(1-tp) and tc:IsRelateToBattle() then
		local atk=tc:GetAttack()
		if Duel.Damage(1-tp,atk,REASON_EFFECT) then
			 local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
			 if g:GetCount()==0 then return end
			 Duel.BreakEffect()
			 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			 local sg=g:Select(tp,1,1,nil)
			  Duel.Destroy(sg,REASON_EFFECT)
		end
	end
end
function c98920137.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	local loc,tg=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TARGET_CARDS)
	if not tg or not tg:IsContains(c) then return false end
	return Duel.IsChainDisablable(ev) and loc~=LOCATION_DECK
end
function c98920137.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_MZONE) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetValue(c98920137.efilter)
		e1:SetLabelObject(re)
		e1:SetReset(RESET_EVENT+RESET_CHAIN)
		c:RegisterEffect(e1)
		local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
		if g:GetCount()==0 then return end
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=g:Select(tp,1,1,nil)
		Duel.Destroy(sg,REASON_EFFECT)
	end
end
function c98920137.efilter(e,re)
	return re==e:GetLabelObject()
end