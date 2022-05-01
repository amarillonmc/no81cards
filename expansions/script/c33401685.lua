--狂狂帝 时间储存机关
local m=33401685
local cm=_G["c"..m]
function cm.initial_effect(c)
 c:EnableCounterPermit(0x34f)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_DISABLE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
 --remain field
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e3)
end
function cm.refilter(c,tp,re)
	 local flag=true
	local value={Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_RELEASE)}
	if #value>0 then
		for k,re in ipairs(value) do
			local val=re:GetTarget()
			if val and val(re,c,tp) then
				flag=false
			end
		end 
	end
	return  c:IsReleasable() or (c:IsType(TYPE_SPELL+TYPE_TRAP)  and flag)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if Duel.IsExistingMatchingCard(cm.refilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,e:GetHandler(),tp) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,cm.refilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,99,e:GetHandler(),tp)
	local ss=Duel.SendtoGrave(g,REASON_COST+REASON_RELEASE)
	e:SetLabel(ss)
	end
end
function cm.chlimit(e,ep,tp)
	return tp==ep
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return true end
	if e:GetLabel()~=0 then
	Duel.SetChainLimit(cm.chlimit)
	end
end
function cm.tgfilter(c,g)
	return g:IsContains(c) and c:IsAbleToGrave()
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0x34f,2*e:GetLabel())
	end
   local s1=Duel.GetMatchingGroupCount(nil,tp,0,LOCATION_ONFIELD,e:GetHandler())
   local s2=Duel.GetMatchingGroupCount(nil,tp,LOCATION_ONFIELD,0,e:GetHandler())
   local s=s1-s2
	if s<=0 then return end 
	if s>=1 then 
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetTargetRange(LOCATION_ONFIELD,0)
		e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x3340,0x6340))
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetValue(cm.efilter)
		Duel.RegisterEffect(e1,tp)
	end
	if s>=3 then 
	 local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
		e1:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
		e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x3341,0x9344))
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
		Duel.RegisterEffect(e2,tp)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CANNOT_DISABLE_FLIP_SUMMON)
		Duel.RegisterEffect(e3,tp)
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_SUMMON_SUCCESS)
		e4:SetCondition(cm.sumcon)
		e4:SetOperation(cm.sumsuc)
		e4:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e4,tp)
		local e5=e4:Clone()
		e5:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(e5,tp)
		local e6=e4:Clone()
		e6:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
		Duel.RegisterEffect(e6,tp)
	end
	if s>=5 then 
		local e7=Effect.CreateEffect(e:GetHandler())
		e7:SetType(EFFECT_TYPE_FIELD)
		e7:SetCode(EFFECT_IMMUNE_EFFECT)
		e7:SetTargetRange(LOCATION_ONFIELD,0)
		e7:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x3341,0x9344))
		e7:SetReset(RESET_PHASE+PHASE_END)
		e7:SetValue(cm.efilter)
		Duel.RegisterEffect(e7,tp)
	end 
	if s>=7 then  
		local b1=Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
		local b2=Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetMZoneCount(tp)>0
		local op=99
		if b1 and b2 then
			op=Duel.SelectOption(tp,aux.Stringid(m,2),aux.Stringid(m,3))
		elseif b1 then
			op=Duel.SelectOption(tp,aux.Stringid(m,2))
		elseif b2 then
			op=Duel.SelectOption(tp,aux.Stringid(m,3))+1
		end
		if op==0 then
			local g1=Duel.SelectMatchingCard(tp,cm.filter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
			Duel.SendtoHand(g1,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g1)
		elseif op==1 then
			local g2=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
			Duel.SpecialSummon(g2,0,tp,tp,false,false,POS_FACEUP)
		end 
		if Duel.IsExistingMatchingCard(cm.filter3,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)then 
			local g1=Duel.SelectMatchingCard(tp,cm.filter3,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
			Duel.SendtoHand(g1,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g1)
		end
	end
	if s>=9 then 
	 local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(cm.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetLabel(c:GetFieldID())
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetTargetRange(0,LOCATION_ONFIELD)
	e2:SetTarget(cm.disable)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetLabel(c:GetFieldID())
	Duel.RegisterEffect(e2,tp)
	end
end
function cm.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function cm.filter0(c)
	return c:IsFaceup() and c:IsSetCard(0x3341,0x9344)
end
function cm.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.filter0,1,nil)
end
function cm.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimitTillChainEnd(cm.efun)
end
function cm.efun(e,ep,tp)
	return ep==tp
end
function cm.filter1(c)
	return c:IsSetCard(0x3341,0x9344) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.filter2(c,e,tp)
	return c:IsSetCard(0x3341,0x9344) and  c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.filter3(c)
	return c:IsSetCard(0x3340,0x6340) and c:IsAbleToHand()
end
function cm.aclimit(e,re,tp)
	local rc=re:GetHandler()
	return rc:IsOnField() 
end
function cm.disable(e,c)
	return  (not c:IsType(TYPE_MONSTER) or (c:IsType(TYPE_EFFECT) or bit.band(c:GetOriginalType(),TYPE_EFFECT)==TYPE_EFFECT))
end