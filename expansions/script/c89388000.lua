--蛇龙姬 阿吉·达哈卡
local m=89388000
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.rtg)
	e1:SetOperation(cm.rop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(cm.sumcon)
	e2:SetOperation(cm.sumsuc)
	c:RegisterEffect(e2)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetValue(cm.indvalue)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_CONTROL)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCost(cm.ctcost)
	e5:SetTarget(cm.cttg)
	e5:SetOperation(cm.ctop)
	c:RegisterEffect(e5)
end
function cm.rfilter1(c)
	return c:IsCode(89388001) and c:IsFaceup() and c:IsAbleToDeck()
end
function cm.rfilter2(c)
	return c:GetLevel()>0 and c:IsFaceup() and c:IsAbleToDeck()
end
function cm.rtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		if Duel.GetMZoneCount(tp)<=0 or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) or not Duel.IsExistingMatchingCard(cm.rfilter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) then return false end
		local mg=Duel.GetMatchingGroup(cm.rfilter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
		return mg:CheckWithSumEqual(Card.GetRitualLevel,c:GetOriginalLevel(),1,99,c)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function cm.rop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetMZoneCount(tp)<=0 or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) or not Duel.IsExistingMatchingCard(cm.rfilter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) then return false end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.rfilter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if not g or g:GetCount()==0 then return end
	local mg=Duel.GetMatchingGroup(cm.rfilter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local mat=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,c:GetOriginalLevel(),1,99,c)
	if not mat or mat:GetCount()==0 then return end
	g:Merge(mat)
	c:SetMaterial(g)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
	Duel.BreakEffect()
	Duel.SpecialSummon(c,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
	c:CompleteProcedure()
end
function cm.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function cm.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.ResetFlagEffect(tp,m)
	Duel.ResetFlagEffect(tp,m+10000)
	Duel.ResetFlagEffect(tp,m+20000)
	Duel.ResetFlagEffect(1-tp,m)
	Duel.ResetFlagEffect(1-tp,m+10000)
	Duel.ResetFlagEffect(1-tp,m+20000)
	local c=e:GetHandler()
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAINING)
	e3:SetOperation(cm.count)
	e3:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e3,tp)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_ACTIVATE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(1,1)
	e5:SetValue(cm.elimit)
	e5:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e5,tp)
end
function cm.count(e,tp,eg,ep,ev,re,r,rp)
	local n=0
	if re:IsActiveType(TYPE_SPELL) then n=n+10000 end
	if re:IsActiveType(TYPE_TRAP) then n=n+20000 end
	Duel.RegisterFlagEffect(re:GetHandlerPlayer(),m+n,0,0,0)
end
function cm.elimit(e,te,tp)
	local n=0
	if te:IsActiveType(TYPE_SPELL) then n=n+10000 end
	if te:IsActiveType(TYPE_TRAP) then n=n+20000 end
	return Duel.GetFlagEffect(te:GetHandlerPlayer(),m+n)>0
end
function cm.indvalue(e,re)
	return re:GetHandlerPlayer()~=e:GetHandlerPlayer()
end
function cm.rmfilter(c,tp)
	local clv=c:GetLevel()
	if c:IsType(TYPE_XYZ) then clv=c:GetRank() end
	return c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(cm.ctfilter,tp,0,LOCATION_MZONE,1,nil,clv)
end
function cm.ctfilter(c,lv)
	local clv=c:GetLevel()
	if c:IsType(TYPE_XYZ) then clv=c:GetRank() end
	return c:IsFaceup() and c:IsControlerCanBeChanged() and clv<=lv
end
function cm.ctcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function cm.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(cm.rmfilter,tp,LOCATION_GRAVE,0,1,nil,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=Duel.SelectMatchingCard(tp,cm.rmfilter,tp,LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
	local clv=tc:GetLevel()
	if tc:IsType(TYPE_XYZ) then clv=tc:GetRank() end
	e:SetLabel(clv)
	Duel.Remove(tc,POS_FACEUP,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,nil,1,1-tp,LOCATION_MZONE)
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
	local lv=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectMatchingCard(tp,cm.ctfilter,tp,0,LOCATION_MZONE,1,1,nil,lv)
	if not g or g:GetCount()==0 then return end
	Duel.GetControl(g:GetFirst(),tp)
end
