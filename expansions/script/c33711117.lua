--Lily White ～ 白雪将临的街道
local m=33711117
local cm=_G["c"..m]
local CTR_PETAL = 0x234
function cm.initial_effect(c)
	c:EnableCounterPermit(0x234)
	aux.AddLinkProcedure(c,cm.matfilter,5,5)
--
	--add counter
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m, 0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(function(e) return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) end)
	e1:SetTarget(cm.cttg)
	e1:SetOperation(cm.ctop)
	c:RegisterEffect(e1)
	--reflect battle dam
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetValue(1)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EFFECT_UPDATE_ATTACK)
	e8:SetValue(function () return Duel.GetMatchingGroupCount(Card.IsType,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,TYPE_TOKEN)*500 end)
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetCode(EFFECT_PIERCE)
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_SINGLE)
	e12:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e12:SetValue(aux.ChangeBattleDamage(1,DOUBLE_DAMAGE))
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(LOCATION_MZONE,0)
	e6:SetTarget(cm.eftg)
	e6:SetLabelObject(e4)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetLabelObject(e5)
	c:RegisterEffect(e7)
	local e9=e6:Clone()
	e9:SetLabelObject(e8)
	c:RegisterEffect(e9)
	local e11=e6:Clone()
	e11:SetLabelObject(e10)
	c:RegisterEffect(e11)
	local e13=e6:Clone()
	e13:SetLabelObject(e12)
	c:RegisterEffect(e13)

	local e14=Effect.CreateEffect(c)
	e14:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOEXTRA)
	e14:SetDescription(aux.Stringid(m,4))
	e14:SetType(EFFECT_TYPE_QUICK_O)
	e14:SetCode(EVENT_FREE_CHAIN)
	e14:SetRange(LOCATION_MZONE)
	e14:SetCost(cm.rccost)
	e14:SetTarget(cm.rctg)
	e14:SetOperation(cm.rcop)
	c:RegisterEffect(e14)  
end
function cm.cttg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return true
	end
	Duel.SetOperationInfo(0, CATEGORY_COUNTER, nil, 2, 0, CTR_PETAL)
end
function cm.ctop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	if c:IsRelateToEffect(e) then
		c:AddCounter(CTR_PETAL, 2)
	end
end
function cm.matfilter(c)
	return c:IsType(TYPE_TOKEN)
end
function cm.eftg(e,c)
	return c:IsType(TYPE_TOKEN) and e:GetHandler():GetLinkedGroup() and e:GetHandler():GetLinkedGroup():IsContains(c)
end
function cm.rccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,CTR_PETAL,4,REASON_COST) end
	Duel.RemoveCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,CTR_PETAL,4,REASON_COST)
end
function cm.rctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtra() and Duel.IsExistingMatchingCard(cm.check,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.check(c,e,tp)
	return Duel.GetLocationCountFromEx(tp,tp,e:GetHandler(),c)>0 and c:IsCode(33711115) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function cm.rcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,2,REASON_EFFECT)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.check,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.BreakEffect()
			Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
		end
	end
end