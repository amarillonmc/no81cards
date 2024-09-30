--煌之汐雏 罅裂之枪
local cm,m=GetID()
function cm.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--extra pendulum
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND+LOCATION_EXTRA)
	--e1:SetCondition(cm.pspcon)
	e1:SetTarget(cm.psptg)
	e1:SetOperation(cm.pspop)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCost(cm.pspcost)
	--c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCondition(cm.effcon)
	e4:SetOperation(cm.regop)
	c:RegisterEffect(e4)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_GRAVE_ACTION)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCondition(cm.spcon)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
end
function cm.pspcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetActivateLocation()==LOCATION_HAND --or re:GetHandler():IsStatus(STATUS_ACT_FROM_HAND)
end
function cm.pspcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		if c:GetFlagEffect(m+1)>0 then return false end
		for i=1,Duel.GetCurrentChain() do
			local te,tep,loc,pos=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_POSITION)
			if te:IsHasType(EFFECT_TYPE_QUICK_F) or te:IsHasType(EFFECT_TYPE_QUICK_O) or te:IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
			if te:IsHasType(EFFECT_TYPE_TRIGGER_O) and loc==LOCATION_HAND and pos&POS_FACEDOWN>0 then return false end
			if te:IsHasType(EFFECT_TYPE_TRIGGER_O) and tep==1-tp and Duel.GetTurnPlayer()==tp then return false end
		end
		return true
	end
end
function cm.dfilter(c,lv)
	return c:IsType(TYPE_PENDULUM) and c:GetLeftScale()<lv
end
function cm.hfilter(c,lv)
	return c:IsType(TYPE_PENDULUM) and c:GetLeftScale()>lv
end
function cm.fselect(g,lv)
	return g:IsExists(cm.dfilter,1,nil,lv) and g:IsExists(cm.hfilter,1,nil,lv) and g:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)<=1 and g:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)<=1
end
function cm.psptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local lv=c:GetLevel()
	local lpz=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	if chk==0 then
		if c:IsLocation(LOCATION_EXTRA) and c:GetFlagEffect(m)>0 then return false end
		if Duel.GetFlagEffect(tp,m)==0 then
			Duel.Hint(HINT_OPSELECTED,tp,aux.Stringid(m,5))
			Duel.RegisterFlagEffect(tp,m,RESET_CHAIN,0,1)
		end
		if Duel.GetCurrentChain()<1 then return false end
		if c:GetFlagEffect(m+1)>0 then return false end
		local loc=0
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_HAND end
		if Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)>0 then loc=loc+LOCATION_EXTRA end
		if loc==0 or not c:IsLocation(loc) or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,false,false) then return false end
		if rpz==nil and lpz==nil then
			local z1=Duel.CheckLocation(tp,LOCATION_SZONE,0)
			local z2=Duel.CheckLocation(tp,LOCATION_SZONE,4)
			if not z1 or not z2 then return false end
			local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_HAND,0,c,TYPE_PENDULUM)
			if Duel.GetCurrentChain()>0 then
				g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA,0,c,TYPE_PENDULUM)
			end
			local res=g:CheckSubGroup(cm.fselect,2,2,lv)
			--if res then c:RegisterFlagEffect(m+1,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1) end
			return res
		elseif rpz==nil or lpz==nil then
			local seq=0
			if lpz then seq=4 end
			local z1=Duel.CheckLocation(tp,LOCATION_SZONE,seq)
			if not z1 then return false end
			local pz=lpz or rpz
			local scale=pz:GetLeftScale()
			local ds=lv<scale
			local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_HAND,0,c,TYPE_PENDULUM)
			local fil=cm.dfilter
			if lv>scale then fil=cm.hfilter end
			if Duel.GetCurrentChain()>0 then
				g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA,0,c,TYPE_PENDULUM)
			end
			local res=g:IsExists(fil,1,nil,lv)
			--if res then c:RegisterFlagEffect(m+1,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1) end
			return res
		else
			local lscale=lpz:GetLeftScale()
			local rscale=rpz:GetRightScale()
			if lscale>rscale then lscale,rscale=rscale,lscale end
			local res=lv>lscale and lv<rscale
			--if res then c:RegisterFlagEffect(m+1,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1) end
			return res
		end
	end
	c:RegisterFlagEffect(m+1,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1)
	local sg=Group.CreateGroup()
	if rpz==nil and lpz==nil then
		local z1=Duel.CheckLocation(tp,LOCATION_SZONE,0)
		local z2=Duel.CheckLocation(tp,LOCATION_SZONE,4)
		if not z1 or not z2 then return false end
		local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_HAND,0,c,TYPE_PENDULUM)
		if Duel.GetCurrentChain()>1 then
			g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA,0,c,TYPE_PENDULUM)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		sg=g:SelectSubGroup(tp,cm.fselect,false,2,2,lv)
	elseif rpz==nil or lpz==nil then
		local seq=0
		if lpz then seq=4 end
		local z1=Duel.CheckLocation(tp,LOCATION_SZONE,seq)
		if not z1 then return false end
		local pz=lpz or rpz
		local scale=pz:GetLeftScale()
		local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_HAND,0,c,TYPE_PENDULUM)
		local fil=cm.dfilter
		if lv>scale then fil=cm.hfilter end
		if Duel.GetCurrentChain()>1 then
			g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA,0,c,TYPE_PENDULUM)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		sg=g:FilterSelect(tp,fil,1,1,nil,lv)
	end
	for sc in aux.Next(sg) do
		if not sc:IsLocation(LOCATION_HAND) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
			sc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			sc:RegisterEffect(e2)
		end
		Duel.MoveToField(sc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
	--cm.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.pspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lpz=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	if rpz==nil or lpz==nil then return false end
	local lscale=lpz:GetLeftScale()
	local rscale=rpz:GetRightScale()
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local loc=0
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)
	if ft1>0 then loc=loc|LOCATION_HAND end
	if ft2>0 then loc=loc|LOCATION_EXTRA end
	if loc==0 then return false end
	local _PendulumChecklist=aux.PendulumChecklist
	aux.PendulumChecklist=0
	local res=c:IsLocation(loc) and aux.PConditionFilter(c,e,tp,lscale,rscale,nil)
	aux.PendulumChecklist=_PendulumChecklist
	if not res then return false end
	Duel.HintSelection(Group.FromCards(lpz))
	Duel.HintSelection(Group.FromCards(rpz))
	local tc=c
	if not tc.pendulum_rule or not tc.pendulum_rule[tc] then
		local tcm=getmetatable(tc)
		tcm.pendulum_rule=tcm.pendulum_rule or {}
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SPSUMMON_PROC)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetRange(LOCATION_HAND+LOCATION_EXTRA)
		e1:SetLabel(1)
		e1:SetCondition(function(e) return e:GetLabel()==1 end)
		e1:SetTarget(function(e) e:SetLabel(0) return true end)
		e1:SetValue(SUMMON_TYPE_PENDULUM)
		tc:RegisterEffect(e1,true)
		tcm.pendulum_rule[tc]=e1
	else
		tc.pendulum_rule[tc]:SetLabel(1)
	end
	Duel.SpecialSummonRule(tp,tc,SUMMON_TYPE_PENDULUM)
end
function cm.effcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_PENDULUM)
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local fid=c:GetFieldID()
	local e1=Card.RegisterFlagEffect(c,m,RESET_EVENT+0xc3e0000+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,fid,aux.Stringid(m,0))
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_DECK)
	e2:SetLabel(fid)
	e2:SetLabelObject(e1)
	e2:SetOperation(cm.tdop)
	Duel.RegisterEffect(e2,tp)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(cm.tdfilter,1,nil,e:GetLabel()) then
		e:GetLabelObject():Reset()
		e:Reset()
	end
end
function cm.tdfilter(c,lab)
	local fid=c:GetFlagEffectLabel(m)
	return c:IsLocation(LOCATION_DECK) and fid and fid==lab
end
function cm.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x9977)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.spfilter,1,nil)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeck() and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	if Duel.GetCurrentChain()>1 then
		e:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_DISABLE+0x200)
	else e:SetProperty(EFFECT_FLAG_DELAY) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,2,PLAYER_ALL,LOCATION_GRAVE+LOCATION_SZONE)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(Card.IsAbleToDeck),tp,LOCATION_GRAVE,LOCATION_GRAVE,1,3,nil)
	if #g>0 then
		Duel.HintSelection(g)
		g:AddCard(c)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end