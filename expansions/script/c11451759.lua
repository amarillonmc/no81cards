--御汐击龙“玄威”
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
	e10:SetCondition(cm.XyzLevelFreeCondition(cm.mfilter,cm.xyzcheck,4,99))
	e10:SetTarget(cm.XyzLevelFreeTarget(cm.mfilter,cm.xyzcheck,4,99))
	e10:SetOperation(cm.XyzLevelFreeOperation(cm.mfilter,cm.xyzcheck,4,99))
	e10:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e10)
	cm[c]=e10
	c:EnableReviveLimit()
	--effect1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOEXTRA)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CUSTOM+m)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetLabelObject(e0)
	e2:SetCondition(cm.spcon)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	local e5=e2:Clone()
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_MOVE)
	e5:SetCondition(cm.spcon2)
	c:RegisterEffect(e5)
	aux.RegisterMergedDelayedEvent(c,m,EVENT_SPSUMMON_SUCCESS)
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
	return g:GetClassCount(Card.GetCode)==#g
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler())
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and c:GetFlagEffect(m)==0 end
	c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1)
	local tc=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil):GetFirst()
	c:SetCardTarget(tc)
	tc:SetUniqueOnField(1,1,cm.uqfilter,LOCATION_ONFIELD)
	tc:RegisterFlagEffect(m-14,RESET_EVENT+0x1fc0000,0,1)
end
function cm.uqfilter(c)
	return Duel.IsExistingMatchingCard(cm.afilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,c)
end
function cm.afilter(c,tc)
	local flag=c:GetFlagEffectLabel(m-13)
	local flag2=tc:GetFlagEffectLabel(m-14)
	return c:IsHasCardTarget(tc) and flag and flag2
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(m-13,RESET_EVENT+RESETS_STANDARD,0,1)
end
function cm.spfilter(c,se)
	return c:IsFaceup() and c:IsSetCard(0x9977)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local se=e:GetLabelObject():GetLabelObject()
	return eg:IsExists(cm.spfilter,1,nil,se)
end
function cm.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local bool,ceg=Duel.CheckEvent(EVENT_CUSTOM+m,true)
	return eg:IsContains(e:GetHandler()) and bool and ceg:IsExists(cm.spfilter,1,nil) and (re==nil or not re:IsActivated())
end
function cm.XyzLevelFreeGoal(g,tp,xyzc,gf)
	if Duel.GetLocationCountFromEx(tp,tp,g,TYPE_XYZ)<=0 then return false end
	if gf and not gf(g) then return false end
	local lg=g:Filter(Card.IsHasEffect,nil,EFFECT_XYZ_MIN_COUNT)
	for c in aux.Next(lg) do
		local le=c:IsHasEffect(EFFECT_XYZ_MIN_COUNT)
		local ct=le:GetValue()
		if #g<ct then return false end
	end
	return true
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
					local loc=c:GetFlagEffect(m)>0 and LOCATION_DECK+LOCATION_MZONE or LOCATION_MZONE
					mg=Duel.GetMatchingGroup(aux.XyzLevelFreeFilter,tp,loc,0,nil,c,f)
				end
				local sg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_XMATERIAL)
				if sg:IsExists(aux.MustMaterialCounterFilter,1,nil,mg) then return false end
				Duel.SetSelectedCard(sg)
				aux.GCheckAdditional=function(g,...) return aux.TuneMagicianCheckAdditionalX(EFFECT_TUNE_MAGICIAN_X)(g,...) and (c:GetFlagEffect(m)==0 or g:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=1) end
				local gfc=function(g,...) return gf(g,...) and (c:GetFlagEffect(m)==0 or g:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=1) end
				local res=mg:CheckSubGroup(cm.XyzLevelFreeGoal,minc,maxc,tp,c,gfc)
				aux.GCheckAdditional=nil
				return res
			end
end
function cm.XyzLevelFreeTarget(f,gf,minct,maxct)
	return  function(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
				if og and not min then
					return true
				end
				local minc=minct
				local maxc=maxct
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
				end
				local mg=nil
				if og then
					mg=og:Filter(aux.XyzLevelFreeFilter,nil,c,f)
				else
					local loc=c:GetFlagEffect(m)>0 and LOCATION_DECK+LOCATION_MZONE or LOCATION_MZONE
					mg=Duel.GetMatchingGroup(aux.XyzLevelFreeFilter,tp,loc,0,nil,c,f)
				end
				local sg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_XMATERIAL)
				Duel.SetSelectedCard(sg)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
				local cancel=Duel.IsSummonCancelable()
				aux.GCheckAdditional=function(g,...) return aux.TuneMagicianCheckAdditionalX(EFFECT_TUNE_MAGICIAN_X)(g,...) and (c:GetFlagEffect(m)==0 or g:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=1) end
				local gfc=function(g,...) return gf(g,...) and (c:GetFlagEffect(m)==0 or g:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=1) end
				local g=mg:SelectSubGroup(tp,cm.XyzLevelFreeGoal,cancel,minc,maxc,tp,c,gfc)
				aux.GCheckAdditional=nil
				if g and g:GetCount()>0 then
					g:KeepAlive()
					e:SetLabelObject(g)
					return true
				else return false end
			end
end
function cm.XyzLevelFreeOperation(f,gf,minct,maxct)
	return  function(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
				if og and not min then
					local sg=Group.CreateGroup()
					local tc=og:GetFirst()
					while tc do
						local sg1=tc:GetOverlayGroup()
						sg:Merge(sg1)
						tc=og:GetNext()
					end
					Duel.SendtoGrave(sg,REASON_RULE)
					c:SetMaterial(og)
					Duel.Overlay(c,og)
				else
					local mg=e:GetLabelObject()
					if e:GetLabel()==1 then
						local mg2=mg:GetFirst():GetOverlayGroup()
						if mg2:GetCount()~=0 then
							Duel.Overlay(c,mg2)
						end
					else
						local sg=Group.CreateGroup()
						local tc=mg:GetFirst()
						while tc do
							local sg1=tc:GetOverlayGroup()
							sg:Merge(sg1)
							tc=mg:GetNext()
						end
						Duel.SendtoGrave(sg,REASON_RULE)
					end
					c:SetMaterial(mg)
					Duel.Overlay(c,mg)
					if mg:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
					mg:DeleteGroup()
				end
			end
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local te=c[c]
	if chk==0 then
		c:RegisterFlagEffect(m,0,0,1)
		local res=(c:IsCanBeSpecialSummoned(te,SUMMON_TYPE_XYZ,tp,true,true) and cm.XyzLevelFreeCondition(cm.mfilter,cm.xyzcheck,4,99)(te,c,nil,4,99) and c:IsAbleToDeck() and c:GetFlagEffect(m-10)==0)
		c:ResetFlagEffect(m)
		return res
	end
	c:RegisterFlagEffect(m-10,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,LOCATION_EXTRA)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,2,REASON_EFFECT)>0 and c:IsLocation(LOCATION_EXTRA) and c:IsControler(tp) then
		c:RegisterFlagEffect(m,0,0,1)
		if c:IsXyzSummonable(nil) then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_SPSUMMON_COST)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetOperation(cm.resetop)
			c:RegisterEffect(e2)
			Duel.XyzSummon(tp,c,nil)
		else
			c:ResetFlagEffect(m)
		end
	end
end
function cm.resetop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():ResetFlagEffect(m)
	e:Reset()
end