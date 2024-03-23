--波动节点·驻波端口
--21.07.14
local cm,m=GetID()
function cm.initial_effect(c)
	c:EnableReviveLimit()
	c:SetSPSummonOnce(m)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(cm.sprcon)
	e2:SetTarget(cm.sprtg)
	e2:SetOperation(cm.sprop)
	c:RegisterEffect(e2)
	--grave remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1)
	e3:SetCode(EVENT_REMOVE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(cm.ertg)
	e3:SetOperation(cm.erop)
	c:RegisterEffect(e3)
end
function cm.mzfilter(c)
	return c:IsAbleToDeckOrExtraAsCost() and c:GetLevel()>=1 and c:IsRace(RACE_PSYCHO) and (c:IsLocation(LOCATION_GRAVE) or c:IsFacedown())
end
function cm.CheckSubGroup(g,f,min,max,...)
	local min=min or 1
	local max=max or #g
	if min>max then return false end
	local ext_params={...}
	local sg=Duel.GrabSelectedCard()
	if #sg>max or #(g+sg)<min then return false end
	if #sg==max and (not f(sg,...) or Auxiliary.GCheckAdditional and not Auxiliary.GCheckAdditional(sg,nil,g,f,min,max,ext_params)) then return false end
	if #sg>=min and #sg<=max and f(sg,...) and (not Auxiliary.GCheckAdditional or Auxiliary.GCheckAdditional(sg,nil,g,f,min,max,ext_params)) then return true end
	return cm.CheckGroupRecursive(sg,g,f,min,max,ext_params)
end
function cm.CheckGroupRecursive(sg,g,f,min,max,ext_params)
	local eg=g:Clone()
	for c in aux.Next(g-sg) do
		sg:AddCard(c)
		if not Auxiliary.GCheckAdditional or Auxiliary.GCheckAdditional(sg,c,eg,f,min,max,ext_params) then
			if (#sg>=min and #sg<=max and f(sg,table.unpack(ext_params))) or (#sg<max and cm.CheckGroupRecursive(sg,eg,f,min,max,ext_params)) then return true end
		end
		sg:RemoveCard(c)
		eg:RemoveCard(c)
	end
	return false
end
function cm.CheckGroupRecursiveCapture(bool,sg,g,f,min,max,ext_params)
	local eg=g:Clone()
	if bool then cm.esg=sg:Clone() end
	for c in aux.Next(g-sg) do
		if not bool or not Auxiliary.SubGroupCaptured:IsContains(c) then
			sg:AddCard(c)
			if not Auxiliary.GCheckAdditional or Auxiliary.GCheckAdditional(sg,c,eg,f,min,max,ext_params) then
				if (#sg>=min and #sg<=max and f(sg,table.unpack(ext_params))) then -- or (#sg<max and cm.CheckGroupRecursiveCapture(false,sg,eg,f,min,max,ext_params)) then
					--Debug.Message(cm[0])
					for sc in aux.Next(sg-cm.esg) do
						Auxiliary.SubGroupCaptured:Merge(eg:Filter(cm.slfilter,nil,sc))
					end
				end
				if #sg<max then cm.CheckGroupRecursiveCapture(false,sg,eg,f,min,max,ext_params) end
			end
			sg:RemoveCard(c)
			--eg:RemoveCard(c)
			eg:Sub(eg:Filter(cm.slfilter,nil,c))
		end
	end
end
function cm.slfilter(c,sc)
	return c:IsLocation(sc:GetLocation()) and (c:GetLevel()-sc:GetLevel())%5==0
end
function cm.srfilter(c)
	return c:GetLevel()%5==0
end
function cm.SelectSubGroup(g,tp,f,cancelable,min,max,...)
	Auxiliary.SubGroupCaptured=g:Filter(cm.srfilter,nil)
	local min=min or 1
	local max=max or #g
	local ext_params={...}
	local sg=Group.CreateGroup()
	local fg=Duel.GrabSelectedCard()
	if #fg>max or min>max or #(g+fg)<min then return nil end
	for tc in aux.Next(fg) do
		fg:SelectUnselect(sg,tp,false,false,min,max)
	end
	sg:Merge(fg)
	local finish=(#sg>=min and #sg<=max and f(sg,...))
	while #sg<max do
		Auxiliary.SubGroupCaptured=(g-sg):Filter(cm.srfilter,nil)
		cm.CheckGroupRecursiveCapture(true,sg,g,f,min,max,ext_params)
		local cg=Auxiliary.SubGroupCaptured:Clone()
		Auxiliary.SubGroupCaptured:Clear()
			--Debug.Message(cm[0])
		cg:Sub(sg)
		finish=(#sg>=min and #sg<=max and f(sg,...))
		if #cg==0 then break end
		local cancel=not finish and cancelable
		local tc=cg:SelectUnselect(sg,tp,finish,cancel,min,max)
		if not tc then break end
		if not fg:IsContains(tc) then
			if not sg:IsContains(tc) then
				sg:AddCard(tc)
				if #sg==max then finish=true end
			else
				sg:RemoveCard(tc)
			end
		elseif cancelable then
			return nil
		end
	end
	if finish then
		return sg
	else
		return nil
	end
end
function cm.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(cm.mzfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	--[[Auxiliary.SubGroupCaptured=Group.CreateGroup()
	local sg=Group.CreateGroup()
	cm.CheckGroupRecursiveCapture(true,sg,mg,cm.syngoal,4,#mg,{1})
	Debug.Message(cm[0])--]]
	return mg:IsExists(Card.IsLocation,2,nil,LOCATION_GRAVE) and mg:IsExists(Card.IsLocation,2,nil,LOCATION_REMOVED) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and cm.CheckSubGroup(mg,cm.syngoal)
end
--cm[0]=0
function cm.syngoal(g)
	--cm[0]=cm[0]+1
	return #g>=4 and g:IsExists(Card.IsLocation,2,nil,LOCATION_GRAVE) and g:IsExists(Card.IsLocation,2,nil,LOCATION_REMOVED) and g:GetSum(Card.GetLevel)%5==0
end
function cm.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local mg=Duel.GetMatchingGroup(cm.mzfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	local sg=cm.SelectSubGroup(mg,tp,cm.syngoal,Duel.IsSummonCancelable(),4,#mg)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
	--[[local sg=Group.CreateGroup()
	local cg=mg:Filter(cm.syncheck,sg,sg,mg)
	local cg0=cg
	local finish=cm.syngoal(sg)
	while 1==1 do
		cg=cg0:Filter(cm.syncheck,sg,sg,cg0)
		cg:Sub(sg)
		finish=cm.syngoal(sg)
		local cancel=not finish and Duel.IsSummonCancelable()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local tc=cg:SelectUnselect(sg,tp,finish,cancel,4,#mg)
		if not tc then break end
		if not sg:IsContains(tc) then
			sg:AddCard(tc)
			if #sg==#cg then finish=true end
		else
			sg:RemoveCard(tc)
		end
	end
	if finish then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end--]]
end
function cm.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local sg=e:GetLabelObject()
	Card.SetMaterial(c,sg)
	local cg=sg:Filter(Card.IsFacedown,nil)
	Duel.SendtoDeck(sg,nil,2,REASON_COST+REASON_MATERIAL)
	if #cg>0 then Duel.ConfirmCards(1-tp,cg) end
end
function cm.filter3(c,tp)
	return c:IsFacedown() and c:IsPreviousControler(tp) and c:IsLocation(LOCATION_REMOVED) and c:IsAbleToDeck()
end
function cm.ertg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tg=eg:Filter(cm.filter3,nil,tp)
	local dg=Duel.GetDecktopGroup(tp,1)
	if chk==0 then return #tg>0 and dg and #dg>0 and dg:GetFirst():IsAbleToRemove(tp,POS_FACEDOWN) end
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,tg,#tg,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function cm.erop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if #tg>0 then
		Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)
		local og=Duel.GetOperatedGroup()
		local ct=og:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
		if ct>0 then
			local rg=Duel.GetDecktopGroup(tp,ct)
			Duel.DisableShuffleCheck()
			Duel.Remove(rg,POS_FACEDOWN,REASON_COST)
		end
	end
end