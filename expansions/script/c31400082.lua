local m=31400082
local cm=_G["c"..m]
cm.name="熊极天-小熊座ζ"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_DECK)
	e1:SetCondition(cm.sprcon)
	e1:SetOperation(cm.sprop)
	e1:SetValue(SUMMON_VALUE_SELF)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ADD_TYPE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(TYPE_SYNCHRO)
	e2:SetCondition(cm.selfspcon)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_REMOVE_TYPE)
	e3:SetValue(TYPE_TUNER)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EFFECT_CHANGE_LEVEL)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TODECK)
	e5:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCountLimit(1,m)
	e5:SetTarget(cm.tdtg)
	e5:SetOperation(cm.tdop)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RELEASE)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_MZONE)
	e6:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e6:SetCondition(cm.spcon)
	e6:SetCost(cm.spcost)
	e6:SetTarget(cm.sptg)
	e6:SetOperation(cm.spop)
	c:RegisterEffect(e6)
end
function cm.tgrfilter(c)
	return c:IsLevelAbove(1) and c:IsAbleToRemoveAsCost()
end
function cm.mnfilter(c,g)
	return g:IsExists(cm.mnfilter2,1,c,c)
end
function cm.mnfilter2(c,mc)
	return c:GetLevel()-mc:GetLevel()==1
end
function cm.fselect(g,tp,sc)
	return g:GetCount()==2 and g:IsExists(Card.IsType,1,nil,TYPE_TUNER) and g:IsExists(aux.NOT(Card.IsType),1,nil,TYPE_TUNER) and g:IsExists(cm.mnfilter,1,nil,g) and Duel.GetLocationCountFromEx(tp,tp,g,sc)>0
end
function cm.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(cm.tgrfilter,tp,LOCATION_GRAVE,0,nil)
	return g:CheckSubGroup(cm.fselect,2,2,tp,c)
end
function cm.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(cm.tgrfilter,tp,LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tg=g:SelectSubGroup(tp,cm.fselect,false,2,2,tp,c)
	Duel.Remove(tg,POS_FACEUP,REASON_COST)
end
function cm.selfspcon(e)
	return e:GetHandler():IsSummonType(SUMMON_VALUE_SELF)
end
function cm.tdfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x163) and c:IsAbleToDeck()
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tdfilter,tp,LOCATION_REMOVED,0,1,nil) end
	local g=Duel.GetMatchingGroup(cm.tdfilter,tp,LOCATION_REMOVED,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,LOCATION_REMOVED)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.tdfilter,tp,LOCATION_REMOVED,0,nil)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(m)==0 end
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESET_CHAIN,0,0)
end
function cm.rfilter_check(c,e,tp,tc)
	local lv=c:GetLevel()-tc:GetLevel()
	if lv<0 then lv=-lv end
	return c:IsLevelAbove(1) and Duel.IsExistingMatchingCard(cm.spfilter_check,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp,lv,Group.FromCards(c,tc))
end
function cm.spfilter_check(c,e,tp,lv,g)
	local loccheck
	if c:IsLocation(LOCATION_EXTRA) then
		loccheck=Duel.GetLocationCountFromEx(tp,tp,g,c)>0
	else
		loccheck=Duel.GetMZoneCount(tp,g)>0
	end
	return c:IsSetCard(0x163) and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and loccheck and c:IsLevel(lv)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetReleaseGroup(tp,true)
	if chk==0 then return g:IsContains(e:GetHandler()) and g:FilterCount(cm.rfilter_check,e:GetHandler(),e,tp,e:GetHandler())>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_GRAVE)
end
function cm.rfilter_op(c,e,tp,tc)
	local lv=c:GetLevel()-tc:GetLevel()
	if lv<0 then lv=-lv end
	return c:IsLevelAbove(1) and Duel.IsExistingMatchingCard(cm.spfilter_op,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp,lv,Group.FromCards(c,tc))
end
function cm.spfilter_op(c,e,tp,lv,g)
	local loccheck
	if c:IsLocation(LOCATION_EXTRA) then
		loccheck=(Duel.GetLocationCountFromEx(tp,tp,g,c)>0)
	else
		loccheck=(Duel.GetMZoneCount(tp,g)>0) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
	end
	return c:IsSetCard(0x163) and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and loccheck and c:IsLevel(lv)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetReleaseGroup(tp,true)
	if not (c:IsRelateToEffect(e) and g:IsContains(c)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local rg=g:FilterSelect(tp,cm.rfilter_op,1,1,c,e,tp,c)
	if not rg or #rg==0 then return end
	local lv=rg:GetFirst():GetLevel()-c:GetLevel()
	if lv<0 then lv=-lv end
	rg:AddCard(c)
	if Duel.Release(rg,REASON_EFFECT)==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,cm.spfilter_op,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil,e,tp,lv)
		if sg:GetCount()>0 then
			Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP)
		end
	end
end