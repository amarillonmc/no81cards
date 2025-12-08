--真实之龙·红莲魔·翼
local m=11513089
local cm=_G["c"..m]
function cm.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x57),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--change name
	aux.EnableChangeCode(c,70902743,LOCATION_MZONE+LOCATION_GRAVE)
	--destrroy & damage
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c11513089.ddtg)
	e1:SetOperation(c11513089.ddop)
	c:RegisterEffect(e1)
	
end
function c11513089.filter(c,tc)
	return c:IsAttackBelow(tc:GetAttack())
end
function c11513089.ddtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c11513089.filter,tp,0,LOCATION_MZONE,c,c)
	local atk=g:GetMaxGroup(Card.GetAttack):GetFirst():GetAttack()
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,atk)
end
function c11513089.ddop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c11513089.filter,tp,0,LOCATION_MZONE,c,c)
	local atk=g:GetMaxGroup(Card.GetAttack):GetFirst():GetAttack()
	if Duel.Destroy(g,REASON_EFFECT)~=0 then
			Duel.Damage(1-tp,atk,REASON_EFFECT)
	end
end