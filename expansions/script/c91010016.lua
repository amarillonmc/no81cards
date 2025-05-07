--珠泪哀歌族·维萨斯
local m=91010016
local cm=c91010016
function c91010016.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.tgcon)
	e1:SetTarget(cm.tgtg)
	e1:SetOperation(cm.tgop)
	c:RegisterEffect(e1)
	 local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_ACTION)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,m+100)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(cm.condition)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.activate)
	c:RegisterEffect(e2) 
end

function cm.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_DECK) and c:IsControler(tp)
end
function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,tp) 
end
function cm.filter(c,tp)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)and not c:IsType(TYPE_COUNTER) and c:GetActivateEffect():IsActivatable(tp,true,true) and (c:IsSetCard(0x181) or aux.IsCodeListed(c,56099748))  and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil,tp) end
	if not Duel.CheckPhaseActivity() then e:SetLabel(1) else e:SetLabel(0) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==1 then Duel.RegisterFlagEffect(tp,m,RESET_CHAIN,0,1) end
	if e:GetHandler():IsRelateToEffect(e) and Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)>0 then
		local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil,tp)
		local tc=g:GetFirst()
		local te=tc:GetActivateEffect()
			if tc:IsType(TYPE_FIELD) then
			local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
				if fc then
						Duel.SendtoGrave(fc,REASON_RULE)
						Duel.BreakEffect()
				end
				Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
				Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
			else		 
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			end
					cm.ActivateCard(tc,tp,e)
				if not (tc:IsType(TYPE_CONTINUOUS) or tc:IsType(TYPE_FIELD) or tc:IsType(TYPE_EQUIP)) then
				Duel.SendtoGrave(tc,REASON_RULE)
				end
			te:UseCountLimit(tp,1,true) 
	end
end
function cm.ActivateCard(c,tp,oe)
	local e=c:GetActivateEffect()
	local cos,tg,op=e:GetCost(),e:GetTarget(),e:GetOperation()
	if e and (not cos or cos(e,tp,eg,ep,ev,re,r,rp,0)) and (not tg or tg(e,tp,eg,ep,ev,re,r,rp,0)) then
		oe:SetProperty(e:GetProperty())
		local code=c:GetOriginalCode()
		Duel.Hint(HINT_CARD,tp,code)
		Duel.Hint(HINT_CARD,1-tp,code)
		e:UseCountLimit(tp,1,true)
		c:CreateEffectRelation(e)
		if cos then cos(e,p,eg,ep,ev,re,r,rp,1) end
		if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		if g and #g~=0 then
			local tg=g:GetFirst()
			while tg do
				tg:CreateEffectRelation(e)
				tg=g:GetNext()
			end
		end
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
		c:ReleaseEffectRelation(e)
		if g then
			tg=g:GetFirst()
			while tg do
				tg:ReleaseEffectRelation(e)
				tg=g:GetNext()
			end
		end
	end
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph~=PHASE_DAMAGE and ph~=PHASE_DAMAGE_CAL and e:GetHandler():IsReason(REASON_EFFECT)
end
function cm.symfil(c,e) 
  return c:IsType(TYPE_MONSTER) and c:IsCanBeSynchroMaterial()  and c:IsAbleToDeck() and not c:IsImmuneToEffect(e)  
end 
function cm.espfil(c,e,tp,mg) 
	return mg:CheckWithSumEqual(Card.GetSynchroLevel,c:GetLevel(),#mg,#mg,c) and c:IsSynchroSummonable(nil,mg) --and mg:GetSum(Card.GetSynchroLevel,c)==c:GetLevel()  
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

function cm.target(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetMatchingGroup(cm.symfil,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_MZONE,0,nil,e)
	if chk==0 then
		cm.SubGroupParams={nil,Card.GetLevel,nil,false,true}
		--local res=Group.CheckSubGroup(g,cm.symgck,1,3,e,tp)
		local res=cm.SelectSubGroup(g,tp,cm.symgck,false,1,3,e,tp)
		cm.SubGroupParams={}
		return res
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
	local g=Duel.GetMatchingGroup(cm.symfil,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_MZONE,0,nil,e) 
	local tc=Duel.SelectMatchingCard(tp,cm.espfil3,tp,LOCATION_EXTRA,0,1,1,nil,g,e,tp):GetFirst()
	cm.SubGroupParams={function(c,sc) return c:GetSynchroLevel(tc)==sc:GetSynchroLevel(tc) and (not cm.fparams or (cm.fparams[1](c,tc,table.unpack(cm.fparams,2))==cm.fparams[1](sc,tc,table.unpack(cm.fparams,2)))) end,Card.GetLevel,nil,false}
	local mat1=cm.SelectSubGroup(g,tp,cm.espfil2,false,1,3,tc)  
	cm.SubGroupParams={}
	cm.fparams=nil
	if mat1:IsExists(function(c) return c:IsLocation(LOCATION_MZONE) and c:IsFacedown() or c:IsLocation(LOCATION_HAND) end,1,nil) then 
			local cg=mat1:Filter(function(c) return c:IsLocation(LOCATION_MZONE) and c:IsFacedown() or c:IsLocation(LOCATION_HAND) or c:IsLocation(LOCATION_DECK) end,nil) 
			Duel.ConfirmCards(1-tp,cg)
	end 
	tc:SetMaterial(mat1)		 
	Duel.SendtoDeck(mat1,nil,SEQ_DECKTOP,REASON_EFFECT+REASON_MATERIAL+REASON_SYNCHRO) 
	local p=tp
		for i=1,2 do
		local dg=mat1:Filter(function(c,tp) return c:IsLocation(LOCATION_DECK) and c:IsControler(tp) end,nil,p)
			if #dg>1 then
			Duel.SortDecktop(tp,p,#dg)
			end
				for i=1,#dg do
				local mg=Duel.GetDecktopGroup(p,1)
				Duel.MoveSequence(mg:GetFirst(),SEQ_DECKBOTTOM)
				end
			p=1-tp
		end
	Duel.BreakEffect()
	Duel.SpecialSummon(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP) 
	tc:CompleteProcedure()  
end 

function cm.thfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)  and (c:IsSetCard(0x181) or aux.IsCodeListed(c,56099748)) and c:IsFaceup() and c:IsSSetable()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,nil) end
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
		local g=Duel.SelectTarget(tp,aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,1,nil)
		local tc=g:GetFirst()
		if tc and Duel.SSet(tp,tc)~=0 then
			local e1=Effect.CreateEffect(c)
			e1:SetDescription(aux.Stringid(m,1))
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e1:SetCondition(cm.setcon)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
end
function cm.fit1(c)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x181)
end
function cm.setcon(e,c)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(cm.fit1,tp,LOCATION_MZONE,0,1,nil)
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