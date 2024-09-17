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
function cm.slfilter(c,sc)
	return c:IsLocation(sc:GetLocation()) and (c:GetLevel()-sc:GetLevel())%5==0
end
function cm.srfilter(c)
	return c:GetLevel()%5==0
end
--subgroup optimization
function cm.SelectSubGroup(g,tp,f,cancelable,min,max,...)
	--classif: function to classify cards, e.g. function(c,tc) return c:GetLevel()==tc:GetLevel() end
	--sortif: function of subgroup search order, high to low. e.g. Card.GetLevel
	--passf: cards that do not require check, e.g. function(c) return c:IsLevel(1) end
	--goalstop: do you want to backtrack after reaching the goal? true/false
	--check: do you want to return true after reaching the goal firstly? true/false
	local classif,sortf,passf,goalstop,check=table.unpack(cm.SubGroupParams)
	min=min or 1
	max=max or #g
	local sg=Group.CreateGroup()
	local fg=Duel.GrabSelectedCard()
	if #fg>max or min>max or #(g+fg)<min then return nil end
	if not check then
		for tc in aux.Next(fg) do
			fg:SelectUnselect(sg,tp,false,false,min,max)
		end
	end
	sg:Merge(fg)
	local mg,iisg,tmp,stop,iter,ctab,rtab,gtab
	--main check
	local finish=(#sg>=min and #sg<=max and f(sg,...))
	while #sg<max do
		mg=g-sg
		iisg=sg:Clone()
		if passf then
			aux.SubGroupCaptured=mg:Filter(passf,nil,sg,g)
		else
			aux.SubGroupCaptured=Group.CreateGroup()
		end
		ctab,rtab,gtab={},{},{1}
		for tc in aux.Next(mg) do
			ctab[#ctab+1]=tc
		end
		--high to low
		if sortf then
			for i=1,#ctab-1 do
				for j=1,#ctab-1-i do
					if sortf(ctab[j])<sortf(ctab[j+1]) then
						tmp=ctab[j]
						ctab[j]=ctab[j+1]
						ctab[j+1]=tmp
					end
				end
			end
		end
		--classify
		if classif then
			--make similar cards adjacent
			for i=1,#ctab-2 do
				for j=i+2,#ctab do
					if classif(ctab[i],ctab[j]) then
						tmp=ctab[j]
						ctab[j]=ctab[i+1]
						ctab[i+1]=tmp
					end
				end
			end
			--rtab[i]: what category does the i-th card belong to
			--gtab[i]: What is the first card's number in the i-th category
			for i=1,#ctab-1 do
				rtab[i]=#gtab
				if not classif(ctab[i],ctab[i+1]) then
					gtab[#gtab+1]=i+1
				end
			end
			rtab[#ctab]=#gtab
			--iter record all cards' number in sg
			iter={1}
			sg:AddCard(ctab[1])
			while #sg>#iisg and #aux.SubGroupCaptured<#mg do
				stop=#sg>=max
				--prune if too much cards
				if (aux.GCheckAdditional and not aux.GCheckAdditional(sg,c,g,f,min,max,...)) then
					stop=true
				--skip check if no new cards
				elseif #(sg-iisg-aux.SubGroupCaptured)>0 and #sg>=min and #sg<=max and f(sg,...) then
					for sc in aux.Next(sg-iisg) do
						if check then return true end
						aux.SubGroupCaptured:Merge(mg:Filter(classif,nil,sc))
					end
					stop=goalstop
				end
				local code=iter[#iter]
				--last card isn't in the last category
				if code and code<gtab[#gtab] then
					if stop then
						--backtrack and add 1 card from next category
						iter[#iter]=gtab[rtab[code]+1]
						sg:RemoveCard(ctab[code])
						sg:AddCard(ctab[(iter[#iter])])
					else
						--continue searching forward
						iter[#iter+1]=code+1
						sg:AddCard(ctab[code+1])
					end
				--last card is in the last category
				elseif code then
					if stop or code>=#ctab then
						--clear all cards in the last category
						while #iter>0 and iter[#iter]>=gtab[#gtab] do
							sg:RemoveCard(ctab[(iter[#iter])])
							iter[#iter]=nil
						end
						--backtrack and add 1 card from next category
						local code2=iter[#iter]
						if code2 then
							iter[#iter]=gtab[rtab[code2]+1]
							sg:RemoveCard(ctab[code2])
							sg:AddCard(ctab[(iter[#iter])])
						end
					else
						--continue searching forward
						iter[#iter+1]=code+1
						sg:AddCard(ctab[code+1])
					end
				end
			end
		--classification is essential for efficiency, and this part is only for backup
		else
			iter={1}
			sg:AddCard(ctab[1])
			while #sg>#iisg and #aux.SubGroupCaptured<#mg do
				stop=#sg>=max
				if (aux.GCheckAdditional and not aux.GCheckAdditional(sg,c,g,f,min,max,...)) then
					stop=true
				elseif #(sg-iisg-aux.SubGroupCaptured)>0 and #sg>=min and #sg<=max and f(sg,...) then
					for sc in aux.Next(sg-iisg) do
						if check then return true end
						aux.SubGroupCaptured:AddCard(sc) --Merge(mg:Filter(class,nil,sc))
					end
					stop=goalstop
				end
				local code=iter[#iter]
				if code<#ctab then
					if stop then
						iter[#iter]=nil
						sg:RemoveCard(ctab[code])
					end
					iter[#iter+1]=code+1
					sg:AddCard(ctab[code+1])
				else
					local code2=iter[#iter-1]
					iter[#iter]=nil
					sg:RemoveCard(ctab[code])
					if code2 and code2>0 then
						iter[#iter]=code2+1
						sg:RemoveCard(ctab[code2])
						sg:AddCard(ctab[code2+1])
					end
				end
			end
		end
		--finish searching
		sg=iisg
		local cg=aux.SubGroupCaptured:Clone()
		aux.SubGroupCaptured:Clear()
		cg:Sub(sg)
		--Debug.Message(cm[0])
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
	cm.SubGroupParams={cm.slfilter,Card.GetLevel,cm.srfilter,false,true}
	local res=cm.SelectSubGroup(mg,tp,cm.syngoal,Duel.IsSummonCancelable(),2,#mg)
	cm.SubGroupParams={}
	--Debug.Message(cm[0])
	return mg:IsExists(Card.IsLocation,2,nil,LOCATION_GRAVE) and mg:IsExists(Card.IsLocation,2,nil,LOCATION_REMOVED) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and res
end
--cm[0]=0
function cm.syngoal(g)
	--cm[0]=cm[0]+1
	return #g>=4 and g:IsExists(Card.IsLocation,2,nil,LOCATION_GRAVE) and g:IsExists(Card.IsLocation,2,nil,LOCATION_REMOVED) and g:GetSum(Card.GetLevel)%5==0
end
function cm.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local mg=Duel.GetMatchingGroup(cm.mzfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	cm.SubGroupParams={cm.slfilter,Card.GetLevel,cm.srfilter,false}
	local sg=cm.SelectSubGroup(mg,tp,cm.syngoal,Duel.IsSummonCancelable(),2,#mg)
	cm.SubGroupParams={}
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function cm.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local sg=e:GetLabelObject()
	c:SetMaterial(sg)
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