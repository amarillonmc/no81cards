--时龙之契 倾袭
local cm,m=GetID()
function c91011014.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.spcon)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e3:SetCountLimit(1)
	e3:SetValue(cm.indct)
	c:RegisterEffect(e3)
	 local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_ACTION)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_START)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,91011012)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.activate)
	c:RegisterEffect(e2) 
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetTarget(cm.tdtg)
	e4:SetOperation(cm.tdop)
	c:RegisterEffect(e4)
	if not cm.global_check3 then
		cm.global_check3=true
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ATTACK_ANNOUNCE)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
	Duel.RegisterFlagEffect(1-tp,m,RESET_PHASE+PHASE_END,0,1)
end
function cm.indct(e,re,r,rp)
	return bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsReason(REASON_DRAW)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		if c:IsLevelAbove(1) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.BreakEffect()
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_UPDATE_LEVEL)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			e2:SetValue(1)
			c:RegisterEffect(e2)
		end
	end
end
function cm.symfil(c,e) 
  return c:IsType(TYPE_MONSTER) and c:IsCanBeSynchroMaterial()  and c:IsAbleToDeck() and not c:IsImmuneToEffect(e)  
end 
function cm.espfil(c,e,tp,mg) 
	return mg:CheckWithSumEqual(Card.GetSynchroLevel,c:GetLevel(),#mg,#mg,c) and c:IsSynchroSummonable(nil,mg) and c:IsRace(RACE_DRAGON) --and mg:GetSum(Card.GetSynchroLevel,c)==c:GetLevel()  
	--false. GetSum(Card.GetSynchroLevel)~=c:GetLevel(). CheckWithSumEqual~=GetSum.
end   
function cm.espfil2(g,c) 
	return g:CheckWithSumEqual(Card.GetSynchroLevel,c:GetLevel(),#g,#g,c) and c:IsSynchroSummonable(nil,g) 
end  
function cm.symgck(g,e,tp)
	return Duel.IsExistingMatchingCard(cm.espfil,tp,LOCATION_EXTRA,0,1,nil,e,tp,g) 
end 
function cm.slfilter(c,sc,lv)
	return c:GetSynchroLevel(sc)==lv
end
function Auxiliary.SynMixCheckRecursive(c,tp,sg,mg,ct,minc,maxc,syncard,sg1,smat,gc,mgchk)
	local eg=mg:Clone()
	local tempg=mg-sg
	for c in aux.Next(tempg) do
		if eg:IsContains(c) then
			sg:AddCard(c)
			ct=ct+1
			if Auxiliary.SynMixCheckGoal(tp,sg,minc,ct,syncard,sg1,smat,gc,mgchk) or (ct<maxc and Auxiliary.SynMixCheckRecursive(c,tp,sg,eg,ct,minc,maxc,syncard,sg1,smat,gc,mgchk)) then return true end
			sg:RemoveCard(c)
			ct=ct-1
			--eg:RemoveCard(c)
			eg:Sub(eg:Filter(cm.slfilter,nil,syncard,c:GetSynchroLevel(syncard)))
		end
	end
	return false
end
function Auxiliary.SynMixFilter4(c,f4,minc,maxc,syncard,mg1,smat,c1,c2,c3,gc,mgchk)
	cm.fparams={f4,c1,c2,c3}
	if f4 and not f4(c,syncard,c1,c2,c3) then return false end
	local sg=Group.FromCards(c1,c)
	sg:AddCard(c1)
	if c2 then sg:AddCard(c2) end
	if c3 then sg:AddCard(c3) end
	local mg=mg1:Clone()
	if f4 then
		mg=mg:Filter(f4,sg,syncard,c1,c2,c3)
	else
		mg:Sub(sg)
	end
	return Auxiliary.SynMixCheck(mg,sg,minc-1,maxc-1,syncard,smat,gc,mgchk)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk) 
	
	local g=Duel.GetMatchingGroup(cm.symfil,tp,LOCATION_REMOVED+LOCATION_GRAVE+LOCATION_MZONE,0,nil,e)
	local g2=Duel.GetMatchingGroup(cm.symfil,tp,LOCATION_MZONE,0,nil,e)
	if chk==0 then
		cm.SubGroupParams={nil,Card.GetLevel,nil,false,true}
		--local res=Group.CheckSubGroup(g,cm.symgck,1,3,e,tp)
		local res=cm.SelectSubGroup(g,tp,cm.symgck,false,1,3,e,tp)
		local res2=cm.SelectSubGroup(g2,tp,cm.symgck,false,1,3,e,tp)
		cm.SubGroupParams={}
		return res2 or (res and Duel.GetFlagEffect(tp,m)>=3 )
	end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA) 
end 
function cm.espfil3(c,g,e,tp) 
	cm.SubGroupParams={nil,Card.GetLevel,nil,false,true}
	--local res=Group.CheckSubGroup(g,cm.symgck,1,3,e,tp)
	local res=cm.SelectSubGroup(g,tp,cm.espfilr,false,1,3,e,tp,c)
	cm.SubGroupParams={}
	return res
	--return c:IsSynchroSummonable(nil,g)  
end 
function cm.espfilr(mg,e,tp,c) 
	return mg:CheckWithSumEqual(Card.GetSynchroLevel,c:GetLevel(),#mg,#mg,c) and c:IsSynchroSummonable(nil,mg) --and mg:GetSum(Card.GetSynchroLevel,c)==c:GetLevel()  
	--false. GetSum(Card.GetSynchroLevel)~=c:GetLevel(). CheckWithSumEqual~=GetSum.
end   
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	cm.fparams=nil
	local g=Duel.GetMatchingGroup(cm.symfil,tp,LOCATION_MZONE,0,nil,e) 
	if Duel.GetFlagEffect(tp,m)>=3 then
	g=Duel.GetMatchingGroup(cm.symfil,tp,LOCATION_REMOVED+LOCATION_GRAVE+LOCATION_MZONE,0,nil,e) 
	end
	local tc=Duel.SelectMatchingCard(tp,cm.espfil3,tp,LOCATION_EXTRA,0,1,1,nil,g,e,tp):GetFirst()
	cm.SubGroupParams={function(c,sc) return c:GetSynchroLevel(tc)==sc:GetSynchroLevel(tc) and (not cm.fparams or (cm.fparams[1](c,tc,table.unpack(cm.fparams,2))==cm.fparams[1](sc,tc,table.unpack(cm.fparams,2)))) end,Card.GetLevel,nil,false}
	local mat1=g:SelectSubGroup(tp,cm.espfil2,false,1,3,tc)  
	cm.SubGroupParams={}
	cm.fparams=nil
	if mat1:IsExists(function(c) return c:IsLocation(LOCATION_MZONE+LOCATION_REMOVED) and c:IsFacedown()  end,1,nil) then 
			local cg=mat1:Filter(function(c) return c:IsLocation(LOCATION_MZONE+LOCATION_REMOVED) and c:IsFacedown() or c:IsLocation(LOCATION_DECK) end,nil) 
			Duel.ConfirmCards(1-tp,cg)
	end 
	tc:SetMaterial(mat1)		 
	Duel.SendtoDeck(mat1,nil,3,REASON_EFFECT+REASON_MATERIAL+REASON_SYNCHRO) 
	Duel.BreakEffect()
	Duel.SpecialSummon(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP) 
	tc:CompleteProcedure()  
end 
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end

function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
	end
end
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