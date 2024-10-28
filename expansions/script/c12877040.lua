--狩猎游戏-突鸡
function c12877040.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x9a7b),10,2)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--moster effect
	--ExtraSpsummon
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1165)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c12877040.xyzcon)
	e0:SetTarget(c12877040.xyztg)
	e0:SetOperation(c12877040.xyzop)
	e0:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e0)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12877040,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c12877040.target)
	e1:SetOperation(c12877040.operation)
	c:RegisterEffect(e1)
	--pzone move
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12877040,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_RELEASE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,12877040)
	e2:SetTarget(c12877040.settg)
	e2:SetOperation(c12877040.setop)
	c:RegisterEffect(e2)
	--pendulum effect
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12877040,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1,12877041)
	e3:SetCost(c12877040.spcost)
	e3:SetTarget(c12877040.sptg)
	e3:SetOperation(c12877040.spop)
	c:RegisterEffect(e3)
	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCondition(c12877040.discon)
	e4:SetOperation(c12877040.disop)
	c:RegisterEffect(e4)
end
c12877040.pendulum_level=10
function c12877040.xyzfilter(c,xyzcard)
	if c:IsLocation(LOCATION_ONFIELD+LOCATION_REMOVED) and c:IsFacedown() then return false end
	return c:IsCanBeXyzMaterial(xyzcard) and c:IsXyzType(TYPE_PENDULUM) and c:IsXyzLevel(xyzcard,10)
end
function c12877040.xyzfilter1(c,xyzcard)
	return c:GetOriginalLevel()==10 and c:IsSetCard(0x9a7b) and c:IsCanBeXyzMaterial(xyzcard)
end
function c12877040.OverlayFilter(c,nchk)
	return nchk or not c:IsType(TYPE_TOKEN)
end
function c12877040.OverlayGroup(c,g,xm,nchk)
	if not nchk and (not c:IsLocation(LOCATION_MZONE) or c:IsFacedown() or #g<=0 or not c:IsType(TYPE_XYZ)) then return end
	local tg=g:Filter(c12877040.OverlayFilter,nil,nchk)
	if #tg==0 then return end
	local og=Group.CreateGroup()
	for tc in aux.Next(tg) do
		if tc:IsStatus(STATUS_LEAVE_CONFIRMED) then
			tc:CancelToGrave()
		end
		og:Merge(tc:GetOverlayGroup())
	end
	if #og>0 then
		if xm then
			Duel.Overlay(c,og)
		else
			Duel.SendtoGrave(og,REASON_RULE)
		end
	end
	Duel.Overlay(c,tg)
end
function c12877040.CheckFieldFilter(g,tp,c,f,...)
	if c:IsLocation(LOCATION_EXTRA) then
		return Duel.GetLocationCountFromEx(tp,tp,g,c)>0 and (not f or f(g,...))
	else
		return Duel.GetMZoneCount(tp,g,tp)>0 and (not f or f(g,...))
	end
end
function c12877040.SelectGroupNew(tp,desc,cancelable,g,f,cg,min,max,...)
	local min=min or 1
	local max=max or #g
	local ext_params={...}
	if cg then Duel.SetSelectedCard(cg) end
	Duel.Hint(tp,HINT_SELECTMSG,desc)
	return g:SelectSubGroup(tp,f,cancelable,min,max,...)
end
function c12877040.SelectGroup(tp,desc,g,f,cg,min,max,...)
	return c12877040.SelectGroupNew(tp,desc,false,g,f,cg,min,max,...)
end
function c12877040.SelectGroupWithCancel(tp,desc,g,f,cg,min,max,...)
	return c12877040.SelectGroupNew(tp,desc,true,g,f,cg,min,max,...)
end
function c12877040.CheckGroup(g,f,cg,min,max,...)
	if cg then Duel.SetSelectedCard(cg) end
	return g:CheckSubGroup(f,min,max,...)
end
function c12877040.xyzcon(e,c,og,min,max)
		if c==nil then return true end
		if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
		local tp=c:GetControler()
		local minc=2
		local maxc=2
		if min then
			minc=math.max(minc,min)
			maxc=math.min(maxc,max)
		end
		local mg=nil
		local exg=nil
		if og then
			mg=og:Filter(c12877040.xyzfilter,nil,c)
		else
			mg=Duel.GetMatchingGroup(c12877040.xyzfilter,tp,LOCATION_MZONE,0,nil,c)
			exg=Duel.GetMatchingGroup(c12877040.xyzfilter1,tp,LOCATION_PZONE,0,nil,c)
			mg:Merge(exg)
		end
		return c12877040.CheckGroup(mg,c12877040.CheckFieldFilter,nil,minc,maxc,tp,c)
end
function c12877040.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
		local g=nil
		if og and not min then
			g=og
		else
			local mg=nil
			local exg=nil
			if og then
				mg=og:Filter(c12877040.xyzfilter,nil,c)
			else
				mg=Duel.GetMatchingGroup(c12877040.xyzfilter,tp,LOCATION_MZONE,0,nil,c)
				exg=Duel.GetMatchingGroup(c12877040.xyzfilter1,tp,LOCATION_PZONE,0,nil,c)
				mg:Merge(exg)
			end
			local minc=2
			local maxc=2
			if min then
				minc=math.max(minc,min)
				maxc=math.min(maxc,max)
			end
			g=c12877040.SelectGroupWithCancel(tp,HINTMSG_XMATERIAL,mg,c12877040.CheckFieldFilter,nil,minc,maxc,tp,c)
		end
		--if g and aux.GetValueType(g)=="Card" then g=Group.FromCards(g) end
		if g and #g>0 then
			g:KeepAlive()
			e:SetLabelObject(g)
			return true
		else return false end
end
function c12877040.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
		local g=e:GetLabelObject()
		c:SetMaterial(g)
		c12877040.OverlayGroup(c,g,false,true)
end
function c12877040.spfilter(c,e,tp)
	return c:IsOriginalSetCard(0x9a7b) and c:IsType(TYPE_PENDULUM) and not c:IsExtraDeckMonster()
		and c:IsCanBeSpecialSummoned(e,SUMMON_VALUE_SELF,tp,true,false)
end
function c12877040.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local og=e:GetHandler():GetOverlayGroup()
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and og:IsExists(c12877040.spfilter,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_OVERLAY)
end
function c12877040.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=c:GetOverlayGroup():Filter(c12877040.spfilter,nil,e,tp)
	if c:IsRelateToEffect(e) and c:IsFaceup() and Duel.GetMZoneCount(tp)>0 and #sg>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=sg:Select(tp,c12877040.spfilter,1,1,nil,e,tp):GetFirst()
		if sc and Duel.SpecialSummonStep(sc,SUMMON_VALUE_SELF,tp,tp,true,false,POS_FACEUP)~=0 then
			sc:CompleteProcedure()
			sc:RegisterFlagEffect(12877040,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(12877040,3))
			Duel.SpecialSummonComplete()
		end
	end
end
function c12877040.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c12877040.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function c12877040.rlfilter(c,tp)
	local re=Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_RELEASE)
	local val=nil
	if re then val=re:GetValue() end
	return c:IsReleasable(REASON_SPSUMMON) or (c:IsType(TYPE_SPELL+TYPE_TRAP) and (val==nil or val(re,c)~=true))
end
function c12877040.rlcheck(mg,tp)
	return Duel.GetMZoneCount(tp,mg)>0 and (#mg==1 and mg:IsExists(Card.IsLevel,1,nil,10) and mg:IsExists(Card.IsType,1,nil,TYPE_MONSTER) or #mg==2)
end
function c12877040.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetMatchingGroup(c12877040.rlfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,e:GetHandler(),tp)
	if chk==0 then return #mg>0 and mg:CheckSubGroup(c12877040.rlcheck,1,2,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=mg:SelectSubGroup(tp,c12877040.rlcheck,false,1,2,tp)
	Duel.Release(sg,REASON_COST)
end
function c12877040.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c12877040.ovfilter(c)
	return c:IsSetCard(0x9a7b) and c:IsType(TYPE_PENDULUM) and c:IsFaceupEx() and c:IsCanOverlay()
end
function c12877040.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetMZoneCount(tp)>0
		and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and c:IsType(TYPE_XYZ)
		and Duel.IsExistingMatchingCard(c12877040.ovfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(12877040,5)) then
		--overlay
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local tc=Duel.SelectMatchingCard(tp,c12877040.ovfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil):GetFirst()
		if tc then
			Duel.Overlay(c,tc)
		end
	end
end
function c12877040.disfilter(c)
	return c:IsSetCard(0x9a7b) and c:IsReleasableByEffect()
end
function c12877040.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and Duel.IsChainDisablable(ev) and Duel.IsExistingMatchingCard(c12877040.disfilter,tp,LOCATION_MZONE,0,1,nil) and e:GetHandler():GetFlagEffect(12877040)<=0
end
function c12877040.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(12877040,2)) then
	local rg=Duel.SelectReleaseGroupEx(tp,c12877040.disfilter,1,1,REASON_EFFECT,false,nil,e,tp)
		Duel.Hint(HINT_CARD,0,12877040)
		if Duel.Release(rg,REASON_EFFECT)>0 then
		local rc=re:GetHandler()
		if Duel.NegateEffect(ev) and rc:IsRelateToEffect(re) then
			Duel.Destroy(rc,REASON_EFFECT)
			end
		e:GetHandler():RegisterFlagEffect(12877040,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(12877040,4))
		end
	end
end
