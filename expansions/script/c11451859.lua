--魔导飞行队接引指令
local cm,m=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	--set
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,11))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,m+1)
	e3:SetCondition(cm.pzcon)
	e3:SetCost(cm.pzcost)
	e3:SetTarget(cm.pztg)
	e3:SetOperation(cm.pzop)
	c:RegisterEffect(e3)
end
function cm.sfilter(c,e)
	return c:IsType(TYPE_SPELL) and (c:IsFaceup() or c:GetEquipTarget() or c:IsLocation(LOCATION_FZONE)) and c:IsOnField() and (not e or c:IsCanBeEffectTarget(e))
end
function cm.mfilter(c,e)
	return c:IsRace(RACE_SPELLCASTER) and c:IsFaceup() and not c:IsOnField() and (not e or c:IsCanBeEffectTarget(e))
end
function cm.fselect(g)
	local ct1=g:FilterCount(Card.IsOnField,nil)
	local ct2=g:FilterCount(cm.sfilter,nil)
	local ct3=g:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)
	local ct4=g:FilterCount(cm.mfilter,nil)
	return ct1%2==0 and ct3%2==0 and ct1<=2*ct2 and ct3<=2*ct4
end
function cm.fselect2(g)
	local ct1=g:FilterCount(Card.IsOnField,nil)
	local ct3=g:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)
	return ct1%2==0 and ct3%2==0
end
function cm.fselect3(g)
	local ct2=g:FilterCount(cm.sfilter,nil)
	return #g<=2*ct2 and #g%2==0
end
function cm.fselect4(g)
	return #g%2==0
end
function cm.fselect5(g)
	local ct4=g:FilterCount(cm.mfilter,nil)
	return #g<=2*ct4 and #g%2==0
end
function cm.slfilter(c,sc)
	return (c:IsOnField() and sc:IsOnField() and cm.sfilter(c,e)==cm.sfilter(sc,e)) or (not c:IsOnField() and not sc:IsOnField() and cm.mfilter(c,e)==cm.mfilter(sc,e))
end
function cm.srfilter(c,sg,g)
	return (cm.sfilter(c) or cm.mfilter(c)) and #(g-sg)>1
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
	for tc in aux.Next(fg) do
		fg:SelectUnselect(sg,tp,false,false,min,max)
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
            if check then return false end
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
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return false end
	if chk==0 then return (Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,c) and Duel.IsExistingTarget(cm.sfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c,e)) or (Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_GRAVE,LOCATION_GRAVE,2,nil) and Duel.IsExistingTarget(cm.mfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e)) end
	--local g=Duel.GetMatchingGroup(Card.IsCanBeEffectTarget,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,c,e)
	local g1=Duel.GetMatchingGroup(Card.IsCanBeEffectTarget,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c,e)
	local g2=Duel.GetMatchingGroup(Card.IsCanBeEffectTarget,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,e)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,13))
	--Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local min=2
	if Duel.IsExistingTarget(cm.mfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e) then min=0 end
	cm.SubGroupParams={cm.slfilter,nil,cm.srfilter,false}
	--aux.GCheckAdditional=cm.fselect3
	local tg=cm.SelectSubGroup(g1,tp,cm.fselect3,false,min,#g1)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,14))
	--aux.GCheckAdditional=cm.fselect5
	local tg2=cm.SelectSubGroup(g2,tp,cm.fselect5,false,math.max(0,2-#tg),#g2)
	--aux.GCheckAdditional=nil
	cm.SubGroupParams={}
	tg:Merge(tg2)
	Duel.SetTargetCard(tg)
end
local KOISHI_CHECK=false
if Duel.DisableActionCheck then KOISHI_CHECK=true end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	local fid=c:GetFieldID()
	for tc in aux.Next(sg) do
		local ge2=Effect.CreateEffect(c)
		ge2:SetDescription(aux.Stringid(m,10))
		ge2:SetType(EFFECT_TYPE_SINGLE)
		ge2:SetCode(EFFECT_IMMUNE_EFFECT)
		ge2:SetRange(LOCATION_ONFIELD+LOCATION_GRAVE)
		ge2:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_SET_AVAILABLE)
		ge2:SetLabel(fid)
		ge2:SetValue(cm.chkval)
		ge2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		tc:RegisterEffect(ge2,true)
	end
	if not KOISHI_CHECK then
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e5:SetCode(EVENT_ADJUST)
		e5:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e5:SetLabel(fid)
		e5:SetCondition(function() return not pnfl_adjusting end)
		e5:SetOperation(cm.acop)
		Duel.RegisterEffect(e5,tp)
		local e6=e5:Clone()
		e6:SetCode(EVENT_CHAIN_SOLVED)
		e6:SetCondition(aux.TRUE)
		e6:SetOperation(cm.acop2)
		Duel.RegisterEffect(e6,tp)
	end
end
function cm.chkval(e,te)
	if te and te:GetHandler() and not te:IsHasProperty(EFFECT_FLAG_UNCOPYABLE) and (te:GetCode()<0x10000 or te:IsHasType(EFFECT_TYPE_ACTIONS)) and e:GetHandler():IsAbleToHand() then
		if KOISHI_CHECK then
			Duel.DisableActionCheck(true)
			pcall(Duel.SendtoHand,e:GetHandler(),nil,REASON_EFFECT)
			Duel.DisableActionCheck(false)
		else
			e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET,0,1,e:GetLabel())
		end
		--Duel.AdjustAll()
		--Duel.Readjust()
		e:SetValue(aux.FALSE)
		e:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e:SetDescription(0)
		if Duel.GetFlagEffect(tp,0xffff+m)==0 then
			Duel.RegisterFlagEffect(tp,0xffff+m,RESET_CHAIN,0,1)
			if SetCardData then
				Duel.Hint(24,0,aux.Stringid(m,15))
			else
				Debug.Message("「接引」任务进度更新！")
			end
		end
		return true
	end
	return false
end
function cm.filter1(c,fid)
	return c:GetFlagEffect(m)>0 and c:GetFlagEffectLabel(m)==fid
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
	if pnfl_adjusting then return end
	pnfl_adjusting=true
	local g=Duel.GetMatchingGroup(cm.filter1,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,nil,e:GetLabel())
	g:ForEach(Card.ResetFlagEffect,m)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	pnfl_adjusting=false
end
function cm.acop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.filter1,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,nil,e:GetLabel())
	g:ForEach(Card.ResetFlagEffect,m)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
end
function cm.pzcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSummonPlayer,1,nil,tp)
end
function cm.pzcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=eg:Filter(Card.IsSummonPlayer,nil,tp)
	if chk==0 then return #g==g:FilterCount(Card.IsAbleToHandAsCost,nil) end
	Duel.SendtoHand(g,nil,REASON_COST)
end
function cm.filter(c,e,tp,b1,b2)
	return c:IsSetCard(0x6e) and (((b1 and ((c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0) or c:IsSSetable()))) or (b2 and c:IsAbleToDeck()))
end
function cm.pztg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1,b2=c:IsAbleToDeck(),c:IsSSetable()
	if chk==0 then return c:IsSetCard(0x6e) and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_GRAVE,0,1,c,e,tp,b1,b2) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
end
function cm.pzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:IsSetCard(0x6e) then return end
	local b1,b2=c:IsAbleToDeck(),c:IsSSetable()
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_GRAVE,0,c,e,tp,b1,b2)
	if #g>0 then
		local setg=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_GRAVE,0,nil,e,tp,b1,false)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local tc=setg:Select(tp,1,1,nil):GetFirst()
		if c~=tc then
			if tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and (not tc:IsSSetable() or Duel.SelectYesNo(tp,Stringid(m,12))) then
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
				Duel.ConfirmCards(1-tp,tc)
			else
				Duel.SSet(tp,tc)
			end
			Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local tdg=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_GRAVE,0,c,e,tp,false,b2)
			tc=tdg:Select(tp,1,1,nil):GetFirst()
			Duel.SSet(tp,c)
			Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
		end
		--[[Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		local s1=b1 and ((tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0) or tc:IsSSetable())
		local s2=b2 and tc:IsAbleToDeck()
		local sg=Group.FromCards(c,tc)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		if s1 and (not s2 or sg:Select(tp,1,1,nil):IsContains(tc)) then
			if tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and (not tc:IsSSetable() or Duel.SelectYesNo(tp,Stringid(m,12))) then
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
				Duel.ConfirmCards(1-tp,tc)
			else
				Duel.SSet(tp,tc)
			end
			Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
		else
			Duel.SSet(tp,c)
			Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
		end--]]
	end
end