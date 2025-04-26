--献上不义之祈祷
local s,id,o=GetID()
s.UnJustice=1
function s.initial_effect(c)
	aux.AddCodeList(c,130006118)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--change cost
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(id)
	e3:SetRange(LOCATION_GRAVE)
	c:RegisterEffect(e3)
end
function s.costfilter1(c)
	return c:IsAbleToDeck() and c:IsLevelAbove(1) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function s.thfilter(c)
	return c.UnJustice==1 and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function s.thfilter2(c)
	return c:IsLevelAbove(1) and c.UnJustice==1 and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function s.spfilter(c,e,tp)
	return c:IsType(TYPE_RITUAL) and c:IsCode(130006118)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
end
function s.fselect(g,e,tp)
	local sg=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
	local lv=g:GetSum(Card.GetLevel)
	if not Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,g,e,tp) then return false end
	local params=s.SubGroupParams
	s.SubGroupParams={function(c,tc) return c:GetLevel()==tc:GetLevel() end,Card.GetLevel,nil,true,true}
	local res=s.SelectSubGroup(sg,tp,s.fselect2,false,1,#g-1,lv)
	s.SubGroupParams=params
	return res
end
function s.fselect2(g,lv)
	return g:GetSum(Card.GetLevel)==lv
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local sg=Duel.GetMatchingGroup(s.costfilter1,tp,LOCATION_HAND,0,nil)
	if chk==0 then
		s.SubGroupParams={function(c,tc) return c:GetLevel()==tc:GetLevel() end,Card.GetLevel,nil,false,true}
		local res=s.SelectSubGroup(sg,tp,s.fselect,false,2,#sg,e,tp)
		s.SubGroupParams={}
		return res
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	s.SubGroupParams={function(c,tc) return c:GetLevel()==tc:GetLevel() end,Card.GetLevel,nil,false}
	local g=s.SelectSubGroup(sg,tp,s.fselect,false,2,#sg,e,tp)
	s.SubGroupParams={}
	Duel.SetTargetCard(g)
	local lv=g:GetSum(Card.GetLevel)
	e:SetLabel(lv)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
	local rg=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)
	local lv=e:GetLabel()
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	local mat=Group.CreateGroup()
	mat:Merge(tg)
	if tg:GetCount()>0 then
		local ct=Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		s.SubGroupParams={function(c,tc) return c:GetLevel()==tc:GetLevel() end,Card.GetLevel,nil,true}
		local tg=s.SelectSubGroup(sg,tp,s.fselect2,false,1,ct-1,lv)
		s.SubGroupParams={}
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
		if #rg>0 then 
			local rc=rg:Select(tp,1,1,nil):GetFirst()
			if rc then
				rc:SetMaterial(mat)
				Duel.SpecialSummonStep(rc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CHANGE_LEVEL)
				e1:SetValue(lv)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				rc:RegisterEffect(e1,true)
				Duel.SpecialSummonComplete()
			end
		end
	end
end

function s.SelectSubGroup(g,tp,f,cancelable,min,max,...)
	--classif: function to classify cards, e.g. function(c,tc) return c:GetLevel()==tc:GetLevel() end
	--sortif: function of subgroup search order, high to low. e.g. Card.GetLevel
	--passf: cards that do not require check, e.g. function(c) return c:IsLevel(1) end
	--goalstop: do you want to backtrack after reaching the goal? true/false
	--check: do you want to return true after reaching the goal firstly? true/false
	local classif,sortf,passf,goalstop,check=table.unpack(s.SubGroupParams)
	goalstop=goalstop~=false
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