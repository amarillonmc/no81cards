--迷托邦迹巡 迷绊
local cm,m=GetID()
function cm.initial_effect(c)
	--replace
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCode(EFFECT_SEND_REPLACE)
	e1:SetTarget(cm.reptg)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_ACTIVATE_COST)
	e2:SetValue(11451910)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetCondition(cm.accon)
	e2:SetOperation(cm.acop)
	c:RegisterEffect(e2)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(m)
	e6:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e6)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
	if not PTFL_SUMMONRULE_CHECK then
		PTFL_SUMMONRULE_CHECK=true
		local summon_set={"Summon","MSet","SpecialSummonRule","SynchroSummon","XyzSummon","XyzSummonByRose","LinkSummon"}
		for i,fname in pairs(summon_set) do
			local temp_f=Duel[fname]
			Duel[fname]=function(p,c,...)
				temp_f(p,c,...)
				c:RegisterFlagEffect(11451905,RESET_CHAIN,0,1)
			end
		end
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_ACTIVATING)
		ge1:SetOperation(function()
							local g=Duel.GetMatchingGroup(function(c) return c:GetFlagEffect(11451905)>0 end,0,0xff,0xff,nil)
							for tc in aux.Next(g) do tc:ResetFlagEffect(11451905) end
						end)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(ep,m,RESET_CHAIN,0,1)
end
function cm.filter(c,e,tp)
	return c:IsControler(tp) and c:IsType(TYPE_MONSTER) and c:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and c:IsAbleToRemove() and not c:IsHasEffect(EFFECT_TO_HAND_REDIRECT) and not c:IsHasEffect(EFFECT_NECRO_VALLEY) and c:GetLeaveFieldDest()==0 and c:GetDestination()==LOCATION_HAND --and not c:IsType(TYPE_TOKEN)
end
function cm.filter3(c,e,tp,eg)
	return (c:GetOriginalCode()==m or c==e:GetHandler()) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and eg:IsExists(cm.filter,1,c,e,tp) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local sg=Duel.GetMatchingGroup(cm.filter3,tp,LOCATION_GRAVE,0,eg,e,tp,eg)
	if chk==0 then
		--if cm[c]==2 then cm[c]=nil return false end
		return sg:IsContains(c) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end --and c==sg:GetFirst() end -- and Duel.GetFlagEffect(tp,m)==0 end
	--Duel.HintSelection(Group.FromCards(c))
	--Debug.Message(sg:IsContains(c))
	if cm[c]~=1 then
		if cm[c]==2 then cm[c]=nil return false end
		sg:RemoveCard(c)
		local desc=aux.Stringid(m,0)
		if eg:IsContains(c) then desc=aux.Stringid(m,1) end
		if not Duel.SelectYesNo(tp,desc) then
			local dg=(not eg:IsContains(c) and Group.__sub(sg,eg)) or Group.__band(sg,eg)
			for rc in aux.Next(dg) do cm[rc]=2 end
			return false
		end
	end
	cm[c]=nil
	local g=eg:Filter(cm.filter,c,e,tp)
	if #g>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then --and Duel.SelectYesNo(tp,desc) then
		--Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
		if #g>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			g=g:Select(tp,1,1,nil)
		end
		for tc in aux.Next(g) do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_TO_HAND_REDIRECT)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(LOCATION_REMOVED)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
		end
		Duel.AdjustAll()
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		return true
	else return false end
end
function cm.accon(e)
	cm[0]=false
	return Duel.GetFlagEffect(tp,m)==0
end
function cm.acfilter(c,tp)
	local code,code2=c:GetCode()
	return c:IsSetCard(0xc976) and c:IsAbleToGraveAsCost() and Duel.GetFlagEffect(0,m+code+0xffffff)==0 and (not code2 or Duel.GetFlagEffect(0,m+code2+0xffffff)==0) --and not Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,c:GetCode())
end
function Group.ForEach(group,func,...)
	if aux.GetValueType(group)=="Group" and group:GetCount()>0 then
		local d_group=group:Clone()
		for tc in aux.Next(d_group) do
			func(tc,...)
		end
	end
end
function cm.acop(e,tp,eg,ep,ev,re,r,rp)
	if cm[0] then return end
	if e:GetHandler():GetFlagEffect(m)>0 then return end
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.GetMatchingGroup(cm.acfilter,tp,LOCATION_DECK,0,nil,tp):CancelableSelect(tp,1,1,nil)
	if g and #g>0 then
		local code,code2=g:GetFirst():GetCode()
		Duel.RegisterFlagEffect(0,m+code+0xffffff,RESET_PHASE+PHASE_END,0,1)
		if code2 then Duel.RegisterFlagEffect(0,m+code2+0xffffff,RESET_PHASE+PHASE_END,0,1) end
		Duel.SendtoGrave(g,REASON_COST)
	else
		local cg=Duel.GetMatchingGroup(cm.cfilterx,tp,LOCATION_MZONE,0,nil)
		cg:AddCard(e:GetHandler())
		if #cg>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			cg=cg:Select(tp,1,1,nil)
		end
		Duel.HintSelection(cg)
		cg:KeepAlive()
		cg:ForEach(Card.RegisterFlagEffect,m+0xffffff,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1)
		local e1=Effect.CreateEffect(cg:GetFirst())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_SOLVED)
		e1:SetLabelObject(cg)
		e1:SetOperation(cm.desop)
		e1:SetReset(RESET_CHAIN)
		e1:SetLabel(Duel.GetCurrentChain()+1)
		Duel.RegisterEffect(e1,tp)
	end
	cm[0]=true
end
function cm.cfilterx(c)
	return c:IsHasEffect(m) and c:GetFlagEffect(m+0xffffff)==0
end
function cm.cfilter(c)
	return c:IsHasEffect(m) and c:GetFlagEffect(m+0xffffff)>0 and c:IsDestructable()
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==ev then
		Duel.Hint(HINT_CARD,0,m)
		local cg=e:GetLabelObject():Filter(cm.cfilter,nil)
		if re:GetHandler():IsRelateToEffect(re) and re:GetHandler():IsDestructable() and re:GetHandler():GetFlagEffect(11451905)==0 then cg:AddCard(re:GetHandler()) end
		if #cg>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			cg=cg:Select(tp,1,1,nil)
		end
		if #cg>0 then Duel.Destroy(cg,REASON_EFFECT) end
		e:GetLabelObject():DeleteGroup()
	end
end