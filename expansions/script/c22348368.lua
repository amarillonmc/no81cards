--绰 影 遗 迹 的 死 灵 法 师
local m=22348368
local cm=_G["c"..m]
function cm.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCondition(c22348368.spcon)
	e1:SetOperation(c22348368.spop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,22348368)
	e2:SetTarget(c22348368.sptgd)
	e2:SetOperation(c22348368.spopd)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e3:SetCountLimit(1,22348368)
	e3:SetCondition(c22348368.atkcon)
	e3:SetTarget(c22348368.sptgd)
	e3:SetOperation(c22348368.spopd)
	c:RegisterEffect(e3)
	--bb att
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCondition(c22348368.batkcon)
	e4:SetValue(aux.imval1)
	c:RegisterEffect(e4)
	--effc
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,22349368)
	e5:SetCost(c22348368.effccost)
	e5:SetTarget(c22348368.effctg)
	e5:SetOperation(c22348368.effcop)
	c:RegisterEffect(e5)
	
end
function c22348368.effccost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c22348368.efffilter(c,e,tp,eg,ep,ev,re,r,rp)
	if not (c:IsSetCard(0xd70a) and c:IsType(TYPE_MONSTER)) then return false end
	local te=c.bfg_effect
	if not te then return false end
	local tg=te:GetTarget()
	local e=te
	return not tg or tg and tg(e,tp,eg,ep,ev,re,r,rp,0)
end
function c22348368.effctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		return  Duel.CheckReleaseGroup(tp,c22348368.efffilter,1,nil,e,tp,eg,ep,ev,re,r,rp)  end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroup(tp,c22348368.efffilter,1,1,nil,e,tp,eg,ep,ev,re,r,rp)
	local tc=g:GetFirst()
	Duel.Release(tc,REASON_COST)
	tc:CreateEffectRelation(e)
	e:SetLabelObject(tc)
	local te=tc.bfg_effect
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
end
function c22348368.effcop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:IsRelateToEffect(e) then
		local te=tc.bfg_effect
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
--  Duel.BreakEffect()
--  Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD,nil)
	end
end


function c22348368.cafilter(c)
	return c:IsSetCard(0xd70a) and c:IsFaceup()
end
function c22348368.batkcon(e,c)
	return Duel.IsExistingMatchingCard(c22348368.cafilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c22348368.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c==Duel.GetAttacker() or c==Duel.GetAttackTarget()
end
function c22348368.spfilter(c,e,tp)
	return c:IsSetCard(0xd70a) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22348368.sptgd(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c22348368.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c22348368.spopd(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c22348368.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c22348368.cfilter(c)
	return c:IsReleasable(REASON_SPSUMMON) and c:IsType(TYPE_MONSTER)
end
function c22348368.gcheck(g,e,tp)
	return Duel.GetMZoneCount(tp,g)>0 and g:IsExists(Card.IsSetCard,1,nil,0x970a)
end
function c22348368.spcon(e,c)
	if c==nil then return true end
	if c:IsHasEffect(EFFECT_NECRO_VALLEY) then return false end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c22348368.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
	if not c:IsAbleToGraveAsCost() or Duel.IsPlayerAffectedByEffect(tp,EFFECT_NECRO_VALLEY) then
		g:RemoveCard(c)
	end
	return g:CheckSubGroup(c22348368.gcheck,3,3,e,tp)
end
function c22348368.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c22348368.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
	if not c:IsAbleToGraveAsCost() or Duel.IsPlayerAffectedByEffect(tp,EFFECT_NECRO_VALLEY) then
		g:RemoveCard(c)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:SelectSubGroup(tp,c22348368.gcheck,false,3,3,e,tp)
	Duel.Release(sg,REASON_SPSUMMON)
end
