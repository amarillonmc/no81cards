--冻汐击龙“苍痕”
local cm,m=GetID()
function cm.initial_effect(c)
	--check
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_REMOVE)
	e0:SetCondition(aux.ThisCardInGraveAlreadyCheckReg)
	c:RegisterEffect(e0)
	--xyz summon
	local e10=Effect.CreateEffect(c)
	e10:SetDescription(1165)
	e10:SetType(EFFECT_TYPE_FIELD)
	e10:SetCode(EFFECT_SPSUMMON_PROC)
	e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e10:SetRange(LOCATION_EXTRA)
	e10:SetCondition(aux.XyzLevelFreeCondition(cm.mfilter,cm.xyzcheck,2,99))
	e10:SetTarget(aux.XyzLevelFreeTarget(cm.mfilter,cm.xyzcheck,2,99))
	e10:SetOperation(aux.XyzLevelFreeOperation(cm.mfilter,cm.xyzcheck,2,99))
	e10:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e10)
	cm[c]=e10
	c:EnableReviveLimit()
	--effect1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetLabelObject(e0)
	e2:SetCondition(cm.spcon)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
end
if not Duel.GetMustMaterial then
	function Duel.GetMustMaterial(tp,code)
		local g=Group.CreateGroup()
		local ce={Duel.IsPlayerAffectedByEffect(tp,code)}
		for _,te in ipairs(ce) do
			local tc=te:GetHandler()
			if tc then g:AddCard(tc) end
		end
		return g
	end
end
function cm.mfilter(c,xyzc)
	return c:IsXyzType(TYPE_MONSTER) and c:IsXyzLevel(xyzc,9)
end
function cm.xyzcheck(g)
	return g:GetClassCount(Card.GetRace)==#g
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler())
end
function cm.dsfilter(c)
	return c:IsFaceup() and ((c:IsLocation(LOCATION_MZONE) and ((bit.band(c:GetOriginalType(),TYPE_SPELL+TYPE_TRAP)~=0 and (not c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsCanTurnSet()) or (c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable() and c:IsCanTurnSet())) or (bit.band(c:GetOriginalType(),TYPE_SPELL+TYPE_TRAP)==0 and c:IsCanTurnSet()))) or (c:IsLocation(LOCATION_SZONE) and c:IsSSetable(true))) and not (c:IsType(TYPE_PENDULUM) and c:IsLocation(LOCATION_PZONE))
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) and Duel.IsExistingMatchingCard(cm.dsfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and c:GetFlagEffect(m)==0 end
	c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1)
	local g=Duel.GetMatchingGroup(cm.dsfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetOverlayCount()
	if c:IsRelateToEffect(e) and ct>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,cm.dsfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,nil)
		local flag=0
		local setg=Group.CreateGroup()
		for tc in aux.Next(g) do
			tc:CancelToGrave()
			if (tc:IsType(TYPE_MONSTER) and Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)>0) or Duel.ChangePosition(tc,POS_FACEDOWN)>0 then flag=1 end
			--[[local loc=0
			if tc:IsType(TYPE_FIELD) then loc=LOCATION_FZONE
			elseif tc:IsType(TYPE_SPELL+TYPE_TRAP) then loc=LOCATION_SZONE end
			if tc:GetOriginalType()&TYPE_MONSTER==0 and tc:IsLocation(LOCATION_MZONE) then Duel.MoveToField(tc,tp,tp,loc,POS_FACEDOWN,false) end--]]
			if tc:IsType(TYPE_SPELL+TYPE_TRAP) and tc:IsFacedown() then setg:AddCard(tc) end
		end
		if #setg>0 then
			setg:KeepAlive()
			Duel.RaiseEvent(setg,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
		end
		if flag>0 then c:RemoveOverlayCard(tp,1,1,REASON_EFFECT) end
	end
end
function cm.spfilter(c,se)
	if not (se==nil or c:GetReasonEffect()~=se) then return false end
	return c:IsFaceup() and c:IsSetCard(0x9977)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local se=e:GetLabelObject():GetLabelObject()
	return eg:IsExists(cm.spfilter,1,nil,se)
end
function cm.XyzLevelFreeGoal(g,tp,xyzc,gf)
	return (not gf or gf(g)) and Duel.GetLocationCountFromEx(tp,tp,g,TYPE_XYZ)>0
end
function cm.XyzLevelFreeCondition(f,gf,minct,maxct)
	return  function(e,c,og,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				local minc=minct
				local maxc=maxct
				if min then
					minc=math.max(minc,min)
					maxc=math.min(maxc,max)
				end
				if maxc<minc then return false end
				local mg=nil
				if og then
					mg=og:Filter(aux.XyzLevelFreeFilter,nil,c,f)
				else
					mg=Duel.GetMatchingGroup(aux.XyzLevelFreeFilter,tp,LOCATION_MZONE,0,nil,c,f)
				end
				local sg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_XMATERIAL)
				if sg:IsExists(aux.MustMaterialCounterFilter,1,nil,mg) then return false end
				Duel.SetSelectedCard(sg)
				aux.GCheckAdditional=aux.TuneMagicianCheckAdditionalX(EFFECT_TUNE_MAGICIAN_X)
				local res=mg:CheckSubGroup(cm.XyzLevelFreeGoal,minc,maxc,tp,c,gf)
				aux.GCheckAdditional=nil
				return res
			end
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local te=c[c]
	if chk==0 then return c:IsCanBeSpecialSummoned(te,SUMMON_TYPE_XYZ,tp,true,true) and cm.XyzLevelFreeCondition(cm.mfilter,cm.xyzcheck,2,99)(te,c,nil,2,99) and c:IsAbleToDeck() and c:GetFlagEffect(m-10)==0 end
	c:RegisterFlagEffect(m-10,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,LOCATION_EXTRA)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,2,REASON_EFFECT)>0 and c:IsLocation(LOCATION_EXTRA) and c:IsControler(tp) then
		Duel.XyzSummon(tp,c,nil)
	end
end