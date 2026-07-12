--菌树造神 大爆炸魔像
local s,id=GetID()
s.named_with_FungalTree=1

s.TOKEN_MUSHROOM_BED=40020825

function s.FungalTree(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_FungalTree
end

function s.initial_effect(c)
	aux.AddCodeList(c,40020823)
	c:EnableReviveLimit()

	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,0))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(s.LinkCondition(s.mfilter,2,99,s.glcheck))
	e0:SetTarget(s.LinkTarget(s.mfilter,2,99,s.glcheck))
	e0:SetOperation(s.LinkOperation(s.mfilter,2,99,s.glcheck))
	e0:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e0)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.rmcon)
	e1:SetTarget(s.rmtg)
	e1:SetOperation(s.rmop)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCountLimit(1,id+1)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.lktg)
	e2:SetOperation(s.lkop)
	c:RegisterEffect(e2)
end

function s.mfilter(c)
	return c:IsRace(RACE_PLANT)
end

function s.has_yum(tp)
	local pz0=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	local pz1=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	return (pz0 and pz0:IsCode(s.YUM_KAAX_CODE)) or (pz1 and pz1:IsCode(s.YUM_KAAX_CODE))
end

function s.get_bed_count(tp)
	local ct=Duel.GetMatchingGroupCount(function(c) return c:IsFaceup() and c:IsCode(s.TOKEN_MUSHROOM_BED) end,tp,LOCATION_SZONE,0,nil)
	if ct>3 then ct=3 end
	return ct
end

function s.glcheck(g,c,tp)
	local link=c:GetLink()
	if s.has_yum(tp) then
		local reduce=s.get_bed_count(tp)
		link=link-reduce
		if link<2 then link=2 end 
	end
	return g:CheckWithSumEqual(s.GetLinkCount,link,#g,#g)
end

function s.LConditionFilter(c,f,lc,e)
	return (c:IsFaceup() or not c:IsOnField() or e:IsHasProperty(EFFECT_FLAG_SET_AVAILABLE))
		and c:IsCanBeLinkMaterial(lc) and (not f or f(c))
end
function s.LExtraFilter(c,f,lc,tp)
	if c:IsOnField() and c:IsFacedown() then return false end
	if not c:IsCanBeLinkMaterial(lc) or f and not f(c) then return false end
	local le={c:IsHasEffect(EFFECT_EXTRA_LINK_MATERIAL,tp)}
	for _,te in pairs(le) do
		local tf=te:GetValue()
		local related,valid=tf(te,lc,nil,c,tp)
		if related then return true end
	end
	return false
end
function s.GetLinkCount(c)
	if c:IsLinkType(TYPE_LINK) and c:GetLink()>1 then
		return 1+0x10000*c:GetLink()
	else return 1 end
end
function s.GetLinkMaterials(tp,f,lc,e)
	local mg=Duel.GetMatchingGroup(s.LConditionFilter,tp,LOCATION_MZONE,0,nil,f,lc,e)
	local mg2=Duel.GetMatchingGroup(s.LExtraFilter,tp,LOCATION_HAND+LOCATION_SZONE,LOCATION_ONFIELD,nil,f,lc,tp)
	if mg2:GetCount()>0 then mg:Merge(mg2) end
	return mg
end
function s.LCheckOtherMaterial(c,mg,lc,tp)
	local le={c:IsHasEffect(EFFECT_EXTRA_LINK_MATERIAL,tp)}
	local res1=false
	local res2=true
	for _,te in pairs(le) do
		local f=te:GetValue()
		local related,valid=f(te,lc,mg,c,tp)
		if related then res2=false end
		if related and valid then res1=true end
	end
	return res1 or res2
end
function s.LUncompatibilityFilter(c,sg,lc,tp)
	local mg=sg:Filter(aux.TRUE,c)
	return not s.LCheckOtherMaterial(c,mg,lc,tp)
end
function s.LCheckGoal(sg,tp,lc,gf,lmat)
	return (gf and gf(sg,lc,tp)
		or sg:CheckWithSumEqual(s.GetLinkCount,lc:GetLink(),#sg,#sg))
		and Duel.GetLocationCountFromEx(tp,tp,sg,lc)>0
		and not sg:IsExists(s.LUncompatibilityFilter,1,nil,sg,lc,tp)
		and (not lmat or sg:IsContains(lmat))
end
function s.LExtraMaterialCount(mg,lc,tp)
	for tc in aux.Next(mg) do
		local le={tc:IsHasEffect(EFFECT_EXTRA_LINK_MATERIAL,tp)}
		for _,te in pairs(le) do
			local sg=mg:Filter(aux.TRUE,tc)
			local f=te:GetValue()
			local related,valid=f(te,lc,sg,tc,tp)
			if related and valid then
				te:UseCountLimit(tp)
			end
		end
	end
end
function s.LinkCondition(f,minct,maxct,gf)
	return function(e,c,og,lmat,min,max)
		if c==nil then return true end
		if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
		local minc=minct
		local maxc=maxct
		if min then
			if min>minc then minc=min end
			if max<maxc then maxc=max end
			if minc>maxc then return false end
		end
		local tp=c:GetControler()
		local mg=nil
		if og then
			mg=og:Filter(s.LConditionFilter,nil,f,c,e)
		else
			mg=s.GetLinkMaterials(tp,f,c,e)
		end
		if lmat~=nil then
			if not s.LConditionFilter(lmat,f,c,e) then return false end
			mg:AddCard(lmat)
		end
		local fg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_LMATERIAL)
		if fg:IsExists(aux.MustMaterialCounterFilter,1,nil,mg) then return false end
		Duel.SetSelectedCard(fg)
		return mg:CheckSubGroup(s.LCheckGoal,minc,maxc,tp,c,gf,lmat)
	end
end
function s.LinkTarget(f,minct,maxct,gf)
	return function(e,tp,eg,ep,ev,re,r,rp,chk,c,og,lmat,min,max)
		local minc=minct
		local maxc=maxct
		if min then
			if min>minc then minc=min end
			if max<maxc then maxc=max end
			if minc>maxc then return false end
		end
		local mg=nil
		if og then
			mg=og:Filter(s.LConditionFilter,nil,f,c,e)
		else
			mg=s.GetLinkMaterials(tp,f,c,e)
		end
		if lmat~=nil then
			if not s.LConditionFilter(lmat,f,c,e) then return false end
			mg:AddCard(lmat)
		end
		local fg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_LMATERIAL)
		Duel.SetSelectedCard(fg)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
		local cancel=Duel.IsSummonCancelable()
		local sg=mg:SelectSubGroup(tp,s.LCheckGoal,cancel,minc,maxc,tp,c,gf,lmat)
		if sg then
			sg:KeepAlive()
			e:SetLabelObject(sg)
			return true
		else return false end
	end
end
function s.LinkOperation(f,minct,maxct,gf)
	return function(e,tp,eg,ep,ev,re,r,rp,c,og,lmat,min,max)
		local g=e:GetLabelObject()
		c:SetMaterial(g)
		s.LExtraMaterialCount(g,c,tp)
		Duel.SendtoGrave(g,REASON_MATERIAL+REASON_LINK)
		g:DeleteGroup()
	end
end

function s.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end

function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,PLAYER_ALL,LOCATION_GRAVE)
end

function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,10,nil)
	if #g>0 then
		local ct=Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		if ct>0 then
			local og=Duel.GetOperatedGroup()
			local removed_g=og:Filter(Card.IsLocation,nil,LOCATION_REMOVED)
			local codes={}
			for tc in aux.Next(removed_g) do
				codes[tc:GetCode()]=true
			end
			local field_rm_ct=math.floor(ct/2)
			local field_g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
			if field_rm_ct>0 and #field_g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
				local max_ct=math.min(field_rm_ct,#field_g)
				local sg=field_g:Select(tp,1,max_ct,nil)
				if #sg>0 then
					Duel.HintSelection(sg)
					if Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)>0 then
						local sg_og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_REMOVED)
						for tc in aux.Next(sg_og) do
							codes[tc:GetCode()]=true
						end
					end
				end
			end
			
			for code,_ in pairs(codes) do
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetCode(EFFECT_CANNOT_ACTIVATE)
				e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e1:SetTargetRange(0,1)
				e1:SetValue(s.aclimit)
				e1:SetLabel(code)
				e1:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e1,tp)
			end
		end
	end
end

function s.aclimit(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel())
end

function s.lkfilter(c)
	return s.FungalTree(c) and c:IsLinkSummonable(nil)
end

function s.lktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.lkfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end

function s.lkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.lkfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.LinkSummon(tp,tc,nil)
	end
end
