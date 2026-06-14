--No.92 伪骸神龙 心地心龙-恶魔化身
function c71280031.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1165)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c71280031.xyzcon)
	e0:SetTarget(c71280031.xyztg)
	e0:SetOperation(c71280031.xyzop)
	e0:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e0)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c71280031.value)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71280031,1))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_MSET+CATEGORY_SSET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CAN_FORBIDDEN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MSET+TIMING_SSET+TIMING_END_PHASE)
	e2:SetCost(c71280031.rmcost)
	e2:SetTarget(c71280031.rmtg)
	e2:SetOperation(c71280031.rmop)
	c:RegisterEffect(e2)
end
aux.xyz_number[71280031]=92
function c71280031.xyz(c,xyzc)
	local b1=c:IsFaceup() and c:IsCanBeXyzMaterial(xyzc) and c:IsLocation(LOCATION_MZONE) and c:IsXyzLevel(xyzc,9)
	local b2=c:IsFaceup() and c:IsCanBeXyzMaterial(xyzc) and c:IsType(TYPE_EQUIP) and c:GetOriginalType()&TYPE_MONSTER==TYPE_MONSTER
	return b1 or b2
end
function c71280031.goal(g,tp,xyzc)
	return Duel.GetLocationCountFromEx(tp,tp,g,xyzc)>0
end
function c71280031.twoxgoal(g,tp,xyzc)
	if Duel.GetLocationCountFromEx(tp,tp,g,xyzc)<=0 then return false end
	local ct=0
	local limit_table={}
	for c in Auxiliary.Next(g) do
		local le=c:IsHasEffect(EFFECT_DOUBLE_XMATERIAL,tp)
		if le then
			local tg=le:GetTarget()
			local limit_value=le:GetValue() -- not fully implemented: assuming Hard once per turn effects
			if (not tg or tg(le,xyzc,tp)) and (not limit_value or not limit_table[limit_value]) then
				ct=ct+1
				if limit_value then
					limit_table[limit_value]=true
				end
			end
		end
	end
	return #g+ct>=3
end
function c71280031.xyzcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c71280031.xyz,tp,LOCATION_ONFIELD,0,nil,c)
	if mg:IsExists(Auxiliary.Xyz2XMaterialEffectFilter,1,nil,c,9,nil,tp) then
		return c71280031.checkxyz2xmaterial(c,tp,mg)
	else
		return c71280031.checkxyzmaterial(c,tp,mg)
	end
end
function c71280031.checkxyz2xmaterial(c,tp,mg)
	local tp=c:GetControler()
	local sg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_XMATERIAL)
	if sg:IsExists(Auxiliary.MustMaterialCounterFilter,1,nil,mg) then return false end
	Duel.SetSelectedCard(sg)
	Auxiliary.GCheckAdditional=Auxiliary.TuneMagicianCheckAdditionalXyz
	local res=mg:CheckSubGroup(c71280031.twoxgoal,2,3,tp,c)
	Auxiliary.GCheckAdditional=nil
	return res
end
function c71280031.checkxyzmaterial(c,tp,mg)
	local sg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_XMATERIAL)
	if sg:IsExists(Auxiliary.MustMaterialCounterFilter,1,nil,mg) then return false end
	Duel.SetSelectedCard(sg)
	Auxiliary.GCheckAdditional=Auxiliary.TuneMagicianCheckAdditionalXyz
	local res=mg:CheckSubGroup(c71280031.goal,3,3,tp,c)
	Auxiliary.GCheckAdditional=nil
	return res
end
function c71280031.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=nil
	local mg=Duel.GetMatchingGroup(c71280031.xyz,tp,LOCATION_ONFIELD,0,nil,c)
	local sg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_XMATERIAL)
	Duel.SetSelectedCard(sg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local cancel=Duel.IsSummonCancelable()
	Auxiliary.GCheckAdditional=Auxiliary.TuneMagicianCheckAdditionalXyz
	if mg:IsExists(Auxiliary.Xyz2XMaterialEffectFilter,1,nil,c,9,nil,tp) then
		g=mg:SelectSubGroup(tp,c71280031.twoxgoal,cancel,2,3,tp,c)
	else
		g=mg:SelectSubGroup(tp,c71280031.goal,cancel,3,3,tp,c)
	end
	Auxiliary.GCheckAdditional=nil
	if g and g:GetCount()>0 then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else return false end
end
function c71280031.xyzop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=e:GetLabelObject()
	Auxiliary.Xyz2XMaterialOperation(tp,mg,c,3,3)
	local sg=Group.CreateGroup()
	local tc=mg:GetFirst()
	while tc do
		local sg1=tc:GetOverlayGroup()
		sg:Merge(sg1)
		tc=mg:GetNext()
	end
	Duel.SendtoGrave(sg,REASON_RULE)
	c:SetMaterial(mg)
	Duel.Overlay(c,mg)
	mg:DeleteGroup()
end
function c71280031.value(e,c)
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_REMOVED,LOCATION_REMOVED)*1000
end
function c71280031.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c71280031.spfilter(c,e,tp)
	return not c:IsType(TYPE_TOKEN) and c:IsFaceup() and c:IsLocation(LOCATION_REMOVED) and not c:IsReason(REASON_REDIRECT)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE,c:GetControler())
end
function c71280031.setfilter(c,tp)
	return not c:IsType(TYPE_TOKEN) and c:IsFaceup() and c:IsLocation(LOCATION_REMOVED) and not c:IsReason(REASON_REDIRECT)
		and c:IsSSetable(true) and (c:IsType(TYPE_FIELD) or Duel.GetLocationCount(c:GetControler(),LOCATION_SZONE,tp)>0)
end
function c71280031.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON+CATEGORY_MSET,nil,1,1-tp,LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_SSET,nil,1,1-tp,LOCATION_REMOVED)
end
function c71280031.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
	if #g>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 then
		Duel.AdjustAll()
		local mog=Duel.GetOperatedGroup():Filter(c71280031.spfilter,nil,e,tp)
		local sog=Duel.GetOperatedGroup():Filter(c71280031.setfilter,nil,tp)
		if #mog<=0 and #sog<=0 then return end
		local ftm1=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local ftm2=Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)
		if ftm1>0 or ftm2>0 then
			local spg=Group.CreateGroup()
			if Duel.IsPlayerAffectedByEffect(tp,59822133) then
				if ftm1>0 and ftm2>0 then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
					spg=mog:Select(tp,1,1,nil)
				else
					local p
					if ftm1>0 and ftm2<=0 then
						p=tp
					end
					if ftm1<=0 and ftm2>0 then
						p=1-tp
					end
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
					spg=mog:FilterSelect(tp,Card.IsControler,1,1,nil,p)
				end
			else
				local p=tp
				for i=1,2 do
					local sg=mog:Filter(Card.IsControler,nil,p)
					local ft=Duel.GetLocationCount(p,LOCATION_MZONE,tp)
					if #sg>ft then
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
						sg=sg:Select(tp,ft,ft,nil)
					end
					spg:Merge(sg)
					p=1-tp
				end
			end
			if #spg>0 then
				Duel.BreakEffect()
				local tc=spg:GetFirst()
				while tc do
					Duel.SpecialSummonStep(tc,0,tp,tc:GetControler(),false,false,POS_FACEDOWN_DEFENSE)
					tc=spg:GetNext()
				end
				Duel.SpecialSummonComplete()
				local cg=spg:Filter(Card.IsFacedown,nil)
				if #cg>0 then
					Duel.ConfirmCards(1-tp,cg)
				end
			end
		end
		local ssg=Group.CreateGroup()
		local p=tp
		for i=1,2 do
			local sg=sog:Filter(Card.IsControler,nil,p)
			local fg=sg:Filter(Card.IsType,nil,TYPE_FIELD)
			sg:Sub(fg)
			local ft=Duel.GetLocationCount(p,LOCATION_SZONE,tp)
			if #sg>ft then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
				sg=sg:Select(tp,ft,ft,nil)
			end
			ssg:Merge(sg)
			ssg:Merge(fg)
			p=1-tp
		end
		if #ssg>0 then
			Duel.BreakEffect()
			local tc=ssg:GetFirst()
			while tc do
				Duel.SSet(tp,tc,tc:GetControler())
				tc=ssg:GetNext()
			end
		end
	end
end