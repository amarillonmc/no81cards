local m=15000682
local cm=_G["c"..m]
cm.name="神之皇鳞·藏锋之剑"
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,cm.matfilter,1,1)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(cm.spcost)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	--when Equip
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_EQUIP)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(cm.ctcon)
	e2:SetOperation(cm.ctop)
	c:RegisterEffect(e2)
	--SpecialSummon (equip)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(cm.sp2con)
	e3:SetCost(cm.sp2cost)
	e3:SetTarget(cm.sp2tg)
	e3:SetOperation(cm.sp2op)
	c:RegisterEffect(e3)
end
function cm.matfilter(c)
	return c:IsLinkType(TYPE_LINK) and c:IsLinkRace(RACE_WYRM) and not c:IsLinkCode(m)
end
function cm.costfilter(c,tp,sc,able)
	return c:IsRace(RACE_WYRM) and c:IsAbleToGraveAsCost() and (Duel.GetLocationCountFromEx(tp,tp,c,sc)>0 or able==1)
end
function cm.sp1filter(c,e,tp,tc,able)
	return c:IsCanBeSpecialSummoned(e,0,tp,true,true) and c:IsSetCard(0x5f3c) and (Duel.GetLocationCountFromEx(tp,tp,tc,c)>0 or able==1) and not c:IsCode(m)
end
function cm.sp2filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,true,true) and c:IsCode(15000685)
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then
		local ablecost_ican_haveDS=0
		local ablecost_ican_haveYH=0
		local ablecost_icannot_haveDS=0
		local ablecost_icannot_haveYH=0
--讨 论 自 身 送 墓 能 空 出 位 置 的 情 况
		if Duel.IsExistingMatchingCard(cm.sp1filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,0) then
	--只 要 额 外 卡 组 有 神 之 鳞 即 可
			if Duel.IsExistingMatchingCard(cm.sp1filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,0) then ablecost_ican_haveDS=1 end
	--自 己 场 上 有 2张 以 上 c以 外 的 送 墓 怪 兽 ，额 外 有 银 河 也 可
			if Duel.IsExistingMatchingCard(cm.sp2filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) and Duel.GetMatchingGroupCount(cm.costfilter,tp,LOCATION_MZONE,0,c,tp,c,1)>=2 then ablecost_ican_haveYH=1 end
		end
--讨 论 自 身 送 墓 不 能 空 出 位 置 的 情 况
		if not Duel.IsExistingMatchingCard(cm.sp1filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,0) then
	--子 讨 论 1 ：额 外 有 神 之 鳞 
			if Duel.IsExistingMatchingCard(cm.sp1filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,1) then
		--只 需 存 在 另 一 个 送 墓 能 空 出 位 置 的 怪 兽 即 可 ，但 这 种 情 况 需 要 得 到 额 外 的 神 之 鳞 并 对 每 一 只 单 独 分 析
				local ag=Duel.GetMatchingGroup(cm.sp1filter,tp,LOCATION_EXTRA,0,nil,e,tp,c,1)
				local ac=ag:GetFirst()
				local a2g=Group.CreateGroup()
				while ac do
					local a3g=Duel.GetMatchingGroup(cm.costfilter,tp,LOCATION_MZONE,0,c,tp,ac,0)
					a2g:Merge(a3g)
					ac=ag:GetNext()
				end
				if a2g:GetCount()~=0 then ablecost_icannot_haveDS=1 end
			end
	--子 讨 论 2：额 外 有 银 河 
			if Duel.IsExistingMatchingCard(cm.sp2filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) then
		--只 需 要 有 2只 以 上 c以 外 的 送 墓 怪 兽 即 可
				if Duel.GetMatchingGroupCount(cm.costfilter,tp,LOCATION_MZONE,0,c,tp,c,1)>=2 then ablecost_icannot_haveYH=1 end
			end
		end
		return ft>-1 and e:GetHandler():IsAbleToGraveAsCost() and (ablecost_ican_haveDS+ablecost_ican_haveYH+ablecost_icannot_haveDS+ablecost_icannot_haveYH)~=0
	end
	local ablecost_ican_haveDS=0
	local ablecost_ican_haveYH=0
	local ablecost_icannot_haveDS=0
	local ablecost_icannot_haveYH=0
	local a2g=Group.CreateGroup()
--讨 论 自 身 送 墓 能 空 出 位 置 的 情 况
	if Duel.IsExistingMatchingCard(cm.sp1filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,0) then
	--只 要 额 外 卡 组 有 神 之 鳞 即 可
		if Duel.IsExistingMatchingCard(cm.sp1filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,0) then ablecost_ican_haveDS=1 end
	--自 己 场 上 有 2张 以 上 c以 外 的 送 墓 怪 兽 ，额 外 有 银 河 也 可
		if Duel.IsExistingMatchingCard(cm.sp2filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) and Duel.GetMatchingGroupCount(cm.costfilter,tp,LOCATION_MZONE,0,c,tp,c,1)>=2 then ablecost_ican_haveYH=1 end
	end
--讨 论 自 身 送 墓 不 能 空 出 位 置 的 情 况
	if not Duel.IsExistingMatchingCard(cm.sp1filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,0) then
	--子 讨 论 1 ：额 外 有 神 之 鳞 
		if Duel.IsExistingMatchingCard(cm.sp1filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,1) then
		--只 需 存 在 另 一 个 送 墓 能 空 出 位 置 的 怪 兽 即 可 ，但 这 种 情 况 需 要 得 到 额 外 的 神 之 鳞 并 对 每 一 只 单 独 分 析
			local ag=Duel.GetMatchingGroup(cm.sp1filter,tp,LOCATION_EXTRA,0,nil,e,tp,c,1)
			local ac=ag:GetFirst()
			while ac do
				local a3g=Duel.GetMatchingGroup(cm.costfilter,tp,LOCATION_MZONE,0,c,tp,ac,0)
				a2g:Merge(a3g)
				ac=ag:GetNext()
			end
			if a2g:GetCount()~=0 then ablecost_icannot_haveDS=1 end
		end
	--子 讨 论 2：额 外 有 银 河 
		if Duel.IsExistingMatchingCard(cm.sp2filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) then
		--只 需 要 有 2只 以 上 c以 外 的 送 墓 怪 兽 即 可
			if Duel.GetMatchingGroupCount(cm.costfilter,tp,LOCATION_MZONE,0,c,tp,c,1)>=2 then ablecost_icannot_haveYH=1 end
		end
	end
	local list={}
	if ablecost_ican_haveDS==1 then table.insert(list,1) end
	if (ablecost_ican_haveDS==1 and Duel.GetMatchingGroupCount(cm.costfilter,tp,LOCATION_MZONE,0,c,tp,c,1)>=1) or (ablecost_icannot_haveDS==1) then table.insert(list,2) end
	if (ablecost_ican_haveYH+ablecost_icannot_haveYH)~=0 then table.insert(list,3) end
	if (ablecost_ican_haveYH+ablecost_icannot_haveYH)~=0 and Duel.GetMatchingGroupCount(cm.costfilter,tp,LOCATION_MZONE,0,c,tp,c,1)>=3 then table.insert(list,4) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(15000681,2))
	local x,x1=Duel.AnnounceNumber(tp,table.unpack(list))
	local yg=Group.FromCards(c)
	if x==2 then
		if ablecost_ican_haveDS==1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local ag=Duel.SelectMatchingCard(tp,cm.costfilter,tp,LOCATION_MZONE,0,1,1,c,tp,c,1)
			yg:Merge(ag)
		end
		if ablecost_icannot_haveDS==1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local bg=a2g:Select(tp,1,1,c)
			yg:Merge(bg)
		end
	end
	if x==3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local cg=Duel.SelectMatchingCard(tp,cm.costfilter,tp,LOCATION_MZONE,0,2,2,c,tp,c,1)
		yg:Merge(cg)
	end
	if x==4 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local dg=Duel.SelectMatchingCard(tp,cm.costfilter,tp,LOCATION_MZONE,0,3,3,c,tp,c,1)
		yg:Merge(dg)
	end
	yg:KeepAlive()
	e:SetLabelObject(yg)
	e:SetLabel(tp)
	Duel.SendtoGrave(yg,REASON_COST)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=e:GetLabel()
	local yg=e:GetLabelObject()
	local g=Group.CreateGroup()
	if yg:GetCount()<=2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		g=Duel.SelectMatchingCard(tp,cm.sp1filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,c,1)
	end
	if yg:GetCount()>=3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		g=Duel.SelectMatchingCard(tp,cm.sp2filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	end
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)~=0 then
		if g:GetFirst():IsCode(15000685) then g:GetFirst():CompleteProcedure() end
		local sc=g:GetFirst()
		local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
		local fg=yg:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
		if ft<fg:GetCount() then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			fg=fg:FilterSelect(tp,Card.IsLocation,ft,ft,nil,LOCATION_GRAVE)
		end
		Duel.BreakEffect()
		local tc=fg:GetFirst()
		while tc do
			Duel.Equip(tp,tc,sc,false,true)
			local e1=Effect.CreateEffect(sc)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetValue(cm.eqlimit)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			tc=fg:GetNext()
		end
		Duel.EquipComplete()
	end
end
function cm.eqlimit(e,c)
	return e:GetOwner()==c
end
function cm.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetHandler())
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsCanAddCounter(0x1f35,5) and e:GetHandler():IsLocation(LOCATION_SZONE) then
		e:GetHandler():AddCounter(0x1f35,5)
	end
end
function cm.sp2con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetEquipTarget()
end
function cm.sp3filter(c,e,tp)
	return c:IsSetCard(0x5f3c) and c:IsType(TYPE_LINK) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,true)
end
function cm.sp2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.sp3filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function cm.sp2cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanRemoveCounter(tp,0x1f35,1,REASON_COST) end
	c:RemoveCounter(tp,0x1f35,1,REASON_COST)
	Duel.RaiseEvent(e:GetHandler(),EVENT_REMOVE_COUNTER+0x1f35,e,REASON_COST,tp,tp,1)
end
function cm.sp2op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		local tc=Duel.SelectMatchingCard(tp,cm.sp3filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
		if tc then
			Duel.SpecialSummon(tc,SUMMON_TYPE_LINK,tp,tp,false,true,POS_FACEUP)
		end
	end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetTargetRange(1,0)
	e2:SetTarget(cm.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function cm.splimit(e,c)
	return not (c:IsSetCard(0x5f3c) or c:IsCode(15000685))
end