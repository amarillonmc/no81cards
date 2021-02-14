local m=15000661
local cm=_G["c"..m]
cm.name="哭泣天堂"
function cm.initial_effect(c)
	aux.AddCodeList(c,15000661)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	--cost
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCost(cm.cost)
	e2:SetTarget(cm.target2)
	e2:SetOperation(cm.operation2)
	c:RegisterEffect(e2)
	--change effect
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,15000661)
	e3:SetCondition(cm.chcon)
	e3:SetCost(cm.chcost)
	e3:SetOperation(cm.chop)
	c:RegisterEffect(e3)
end
function cm.filter(c,e,tp)
	return c:IsType(TYPE_RITUAL) and c:IsSetCard(0x1f35)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp):Filter(Card.IsType,nil,TYPE_MONSTER)
		local sg=nil
		return Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,cm.filter,e,tp,mg,sg,Card.GetLevel,"Greater")
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetRitualMaterial(tp):Filter(Card.IsType,nil,TYPE_MONSTER)
	local sg=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(aux.RitualUltimateFilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,cm.filter,e,tp,mg,sg,Card.GetLevel,"Greater")
	local tc=tg:GetFirst()
	if tc then
		mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		if sg then
			mg:Merge(sg)
		end
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
			mg:RemoveCard(tc)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Greater")
		local mat=mg:SelectSubGroup(tp,aux.RitualCheck,false,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Greater")
		aux.GCheckAdditional=nil
		if not mat or mat:GetCount()==0 then return end
		tc:SetMaterial(mat)
		local mat2=mat:Filter(Card.IsLocation,nil,LOCATION_EXTRA)
		mat:Sub(mat2)
		Duel.ReleaseRitualMaterial(mat)
		Duel.SendtoGrave(mat2,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		Duel.BreakEffect()
if tc:IsCode(15000666) then Debug.Message("A shadow floating in the mist, a singing grim reaper with a blank smile.") end
if tc:IsCode(15000667) then Debug.Message("Let the pain…ghosts feel pain?") end
if tc:IsCode(15000668) then Debug.Message("Today's cry, sounds a bit melancholy.") end
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function cm.costfilter(c)
	return c:IsAbleToGraveAsCost() and c:IsLocation(LOCATION_HAND)
end
function cm.rfilter(c,rc)
	return (c:IsCanBeRitualMaterial(rc)) or (c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsLocation(LOCATION_HAND))
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp):Filter(Card.IsType,nil,TYPE_MONSTER)
		local sg=nil
		local ag=Duel.GetMatchingGroup(aux.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,cm.filter,e,tp,mg,sg,Card.GetLevel,"Greater")
--得 到 能 够 R召 的 手 卡 墓 地 怪 兽 组
		local ac=ag:GetFirst()
		local cg=Group.CreateGroup()
		while ac do
			local bg=Duel.GetMatchingGroup(cm.rfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,ac,ac)
--得 到 ac以 外 的 手 卡 场 上 的 卡 组
			local bc=bg:GetFirst()
			while bc do
				local b2g=Duel.GetMatchingGroup(cm.rfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,Group.FromCards(ac,bc),ac)
--得 到 不 包 含 ac,bc的 手 卡 场 上 卡 组
				if b2g:CheckWithSumGreater(Card.GetRitualLevel,ac:GetLevel(),ac) then
					cg:AddCard(bc)
					if not cg:IsContains(ac) then cg:AddCard(ac) end
				end
				if b2g:FilterCount(Card.IsLevelAbove,nil,1)==0 and ac:GetLevel()==bc:GetLevel() and bc:IsCanBeRitualMaterial(ac) then cg:AddCard(ac) end
				if b2g:FilterCount(Card.IsLevelAbove,nil,1)==0 and ac:GetLevel()>bc:GetLevel() and bc:IsCanBeRitualMaterial(ac) then cg:AddCard(bc) end
				if b2g:FilterCount(Card.IsLevelAbove,nil,1)==0 and ac:GetLevel()<bc:GetLevel() and bc:IsCanBeRitualMaterial(ac) then cg:AddCard(ac) end
--如 果 上 述 不 包 含 ac,bc的 组 能 够 R召 ac，则 ac,bc可 被 丢 弃
--特 殊 地 ，对 只 有 两 张 卡 的 情 况 做 出 分 析
				bc=bg:GetNext()
			end
			ac=ag:GetNext()
		end
	return cg:FilterCount(cm.costfilter,e:GetHandler())~=0 end
	local mg=Duel.GetRitualMaterial(tp):Filter(Card.IsType,nil,TYPE_MONSTER)
	local sg=nil
	local ag=Duel.GetMatchingGroup(aux.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,cm.filter,e,tp,mg,sg,Card.GetLevel,"Greater")
	local ac=ag:GetFirst()
	local cg=Group.CreateGroup()
	while ac do
		local bg=Duel.GetMatchingGroup(cm.rfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,ac,ac)
		local bc=bg:GetFirst()
		while bc do
			local b2g=Duel.GetMatchingGroup(cm.rfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,Group.FromCards(ac,bc),ac)
			if b2g:CheckWithSumGreater(Card.GetRitualLevel,ac:GetLevel(),ac) then
				cg:AddCard(bc)
				if not cg:IsContains(ac) then cg:AddCard(ac) end
			end
			if b2g:FilterCount(Card.IsLevelAbove,nil,1)==0 and ac:GetLevel()==bc:GetLevel() and bc:IsCanBeRitualMaterial(ac) then cg:AddCard(ac) end
			if b2g:FilterCount(Card.IsLevelAbove,nil,1)==0 and ac:GetLevel()>bc:GetLevel() and bc:IsCanBeRitualMaterial(ac) then cg:AddCard(bc) end
			if b2g:FilterCount(Card.IsLevelAbove,nil,1)==0 and ac:GetLevel()<bc:GetLevel() and bc:IsCanBeRitualMaterial(ac) then cg:AddCard(ac) end
			bc=bg:GetNext()
		end
		ac=ag:GetNext()
	end
	local dg=cg:Filter(cm.costfilter,e:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local fg=dg:Select(tp,1,1,e:GetHandler())
	Duel.SendtoGrave(fg,REASON_COST)
end
function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp):Filter(Card.IsType,nil,TYPE_MONSTER)
		local sg=nil
		return Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,cm.filter,e,tp,mg,sg,Card.GetLevel,"Greater")
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function cm.operation2(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetRitualMaterial(tp):Filter(Card.IsType,nil,TYPE_MONSTER)
	local sg=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(aux.RitualUltimateFilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,cm.filter,e,tp,mg,sg,Card.GetLevel,"Greater")
	local tc=tg:GetFirst()
	if tc then
		mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		if sg then
			mg:Merge(sg)
		end
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
			mg:RemoveCard(tc)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Greater")
		local mat=mg:SelectSubGroup(tp,aux.RitualCheck,false,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Greater")
		aux.GCheckAdditional=nil
		if not mat or mat:GetCount()==0 then return end
		tc:SetMaterial(mat)
		local mat2=mat:Filter(Card.IsLocation,nil,LOCATION_EXTRA)
		mat:Sub(mat2)
		Duel.ReleaseRitualMaterial(mat)
		Duel.SendtoGrave(mat2,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		Duel.BreakEffect()
if tc:IsCode(15000666) then Debug.Message("A shadow floating in the mist, a singing grim reaper with a blank smile.") end
if tc:IsCode(15000667) then Debug.Message("Let the pain…ghosts feel pain?") end
if tc:IsCode(15000668) then Debug.Message("Today's cry, sounds a bit melancholy.") end
		if Duel.SpecialSummonStep(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(aux.Stringid(m,3))
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_IMMUNE_EFFECT)
			e1:SetValue(cm.efilter)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1,true)
			Duel.SpecialSummonComplete()
		end
		tc:CompleteProcedure()
	end
end
function cm.efilter(e,te)
	return te:IsActiveType(TYPE_SPELL+TYPE_TRAP) and not te:GetHandler():IsCode(15000661)
end
function cm.chcon(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetCurrentChain()
	if ct<2 then return end
	if not Duel.IsPlayerCanDraw(tp,1) or not Duel.IsPlayerCanDraw(1-tp,1) then return false end
	local te,p=Duel.GetChainInfo(ct-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	return te and te:GetHandler():IsSetCard(0x1f35) and te:GetHandler():GetType(TYPE_RITUAL) and te:GetHandler():GetType(TYPE_MONSTER) and p==tp and rp==1-tp
end
function cm.chcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) and e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,nil)
end
function cm.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,cm.repop)
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
	Duel.Draw(1-tp,1,REASON_EFFECT)
end