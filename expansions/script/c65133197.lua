--幻叙天际领航者
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1164)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(s.SynMixCondition)
	e0:SetTarget(s.SynMixTarget)
	e0:SetOperation(s.SynMixOperation)
	e0:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e0)
	--send to grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetTarget(s.tgtg)
	e1:SetOperation(s.tgop)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(s.rmcon)
	e2:SetOperation(s.rmop)
	c:RegisterEffect(e2)
end
--written by purplenightfall
function s.SelectSubGroup(g,tp,f,cancelable,min,max,...)
	local classif,sortf,passf,goalstop,check,params1,params2,params3=table.unpack(s.SubGroupParams)
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
	local params1=params1 or {}
	local params2=params2 or {}
	local params3=params3 or {}
	local finish=(#sg>=min and #sg<=max and f(sg,...))
	while #sg<max do
		mg=g-sg
		iisg=sg:Clone()
		if passf then
			aux.SubGroupCaptured=mg:Filter(passf,nil,table.unpack(params3))
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
					if sortf(ctab[j],table.unpack(params2))<sortf(ctab[j+1],table.unpack(params2)) then
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
					if classif(ctab[i],ctab[j],table.unpack(params1)) then
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
				if not classif(ctab[i],ctab[i+1],table.unpack(params1)) then
					gtab[#gtab+1]=i+1
				end
			end
			rtab[#ctab]=#gtab
--Debug.Message("Classification resulted in " .. #gtab .. " groups.")
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
						aux.SubGroupCaptured:Merge(mg:Filter(classif,nil,sc,table.unpack(params1)))
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
				if #sg>=max then stop=true end
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
function s.IsInTable(value, tbl)
	for k,v in ipairs(tbl) do
		if v == value then
		return true
		end
	end
	return false
end
function s.SMatCatch(tp,syncard)
	local g=aux.GetSynMaterials(tp,syncard)
	local mg=Duel.GetMatchingGroup(s.SMatCheck,tp,0x10,0x1c,g,syncard)
	return Group.__add(g,mg)
end
function s.SMatCheck(c,syncard)
	if not (c:IsCanBeSynchroMaterial(syncard) or c:IsLevel(0)) then return false end
	if c:IsStatus(STATUS_FORBIDDEN) then return false end
	if c:IsHasEffect(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL) then return false end
	local tp=syncard:GetControler()
	if c:IsLocation(LOCATION_GRAVE) then
		if c:GetControler()==tp and c:IsLevel(0) and syncard:GetOriginalCode()~=id then return false end
		if Duel.GetFlagEffect(tp,id)>0 or Duel.GetFlagEffect(tp,id-1)==0 then return false end
		if not c:IsAbleToRemove(tp,POS_FACEUP,REASON_MATERIAL+REASON_SYNCHRO) then return false end
	elseif c:IsLocation(LOCATION_ONFIELD) then
		if c:IsFacedown() then return false end
	else return false end
	return true
end
function s.SLevelCal(c,sc)
	local lv=c:GetSynchroLevel(sc)
	local tp=sc:GetControler()
	if c:IsLocation(LOCATION_GRAVE) and c:IsLevel(0) and (c:GetControler()~=tp or sc:GetOriginalCode()==id) then return 1 else return lv end
end
function s.lvs(c,syncard)
	if not c then return 0 end
	local lv=s.SLevelCal(c,syncard)
	local lv2=lv>>16
	lv=lv&0xffff
	if lv2>0 then return lv,lv2 else return lv end
end
function s.lvplus(group,sc)
	local results = {}
	local function calculateRecursive(cards, index, sum)
		if index > #cards then
			table.insert(results, sum)
			return
		end
		local card = cards[index]
		local level1, level2 = s.lvs(card,sc)
		if not level2 then
			calculateRecursive(cards, index + 1, sum + level1)
		else
			calculateRecursive(cards, index + 1, sum + level1)
			calculateRecursive(cards, index + 1, sum + level2)
		end
	end
	local cards = {}
	local card = group:GetFirst()
	while card do
		table.insert(cards, card)
		card = group:GetNext()
	end
	calculateRecursive(cards, 1, 0)
	return results
end
function s.TunerCheck(c,sc)
	local p,sp=c:GetControler(),sc:GetControler()
	return c:IsTuner(sc) and (c:IsFaceup() or p==sp or not c:IsOnField())
end
function s.NotTunerCheck(c,sc)
	local p,sp=c:GetControler(),sc:GetControler()
	return c:IsNotTuner(sc) or (c:IsFacedown() and p~=sp and c:IsOnField())
end
function s.slfilter(c,tc,sc)
	local lv1_1,lv1_2=s.lvs(c,sc)
	local lv2_1,lv2_2=s.lvs(tc,sc)
	if (lv1_2 and not lv2_2) or (not lv1_2 and lv2_2) then return false end
	local res1=(lv1_1==lv2_1)
	if lv1_2 and lv2_2 then res1=(((lv1_1==lv2_1) and (lv1_2==lv2_2)) or ((lv1_1==lv2_2) and (lv1_2==lv2_1))) end
	if not res1 then return false end
	local function botht(card,syncard)
		return s.TunerCheck(card,syncard) and s.NotTunerCheck(card,syncard)
	end
	if botht(c,sc) and botht(tc,sc) then return true
	elseif botht(c,sc) and not botht(tc,sc) then return false
	elseif not botht(c,sc) and botht(tc,sc) then return false else
		if (s.TunerCheck(c,sc) and s.TunerCheck(tc,sc)) or (s.NotTunerCheck(c,sc) and s.NotTunerCheck(tc,sc)) then return true end
	end
	return false
end
function s.gcheck(sc)
	return  function(sg)
				return math.min(table.unpack(s.lvplus(sg,sc)))<=sc:GetLevel()
			end
end
function s.SynMixCondition(e,c,smat,mg1,min,max)
	if c==nil then return true end
	local minc=0
	local maxc=99
	if min then
		local exct=1
		if min-exct>minc then minc=min-exct end
		if max-exct<maxc then maxc=max-exct end
		if minc>maxc then return false end
	end
	local tp=c:GetControler()
	if Duel.IsPlayerAffectedByEffect(tp,8173184) then
		Duel.RegisterFlagEffect(tp,8173184+1,0,0,1)
	end
	if smat and not s.SMatCheck(smat,c) then
		Duel.ResetFlagEffect(tp,8173184+1)
		return false
	end
	local mg
	local mgchk=false
	if mg1 then
		mg=mg1:Filter(s.SMatCheck,nil,c)
		mgchk=true
	else
		mg=s.SMatCatch(tp,c)
	end
	if smat~=nil then mg:AddCard(smat) end
	Auxiliary.SubGroupCaptured=Group.CreateGroup()
	s.SubGroupParams={s.slfilter,s.SLevelCal,nil,true,true,{c},{c}}
	aux.GCheckAdditional=s.gcheck(c)
	local res=s.SelectSubGroup(mg,tp,s.syngoal,Duel.IsSummonCancelable(),2,#mg,c,smat,tp,mgchk)
	aux.GCheckAdditional=nil
	s.SubGroupParams={}
	Duel.ResetFlagEffect(tp,8173184+1)
	return res and mg:IsExists(s.ntfilter,1,nil,c,mg)
end
function s.ntfilter(c,sc,mg)
	return s.TunerCheck(c,sc) and mg:IsExists(s.NotTunerCheck,1,c,sc)
end
function s.syngoal(g,sc,smat,tp,mgchk)
	if Duel.GetLocationCountFromEx(tp,tp,g,sc)<=0 then return false end
	if not g:IsExists(s.ntfilter,1,nil,sc,g) then return false end
	if smat and not g:IsContains(smat) then return false end
	if not aux.MustMaterialCheck(g,tp,EFFECT_MUST_BE_SMATERIAL) then return false end
	if Duel.IsPlayerAffectedByEffect(tp,8173184)
		and not g:IsExists(aux.Tuner(Card.IsSetCard,0x2),1,nil,sc) then return false end
	if not s.IsInTable(sc:GetLevel(),s.lvplus(g,sc))
		and (not g:IsExists(Card.IsHasEffect,1,nil,89818984)
		or (#g)*2~=sc:GetLevel())
		then return false end
	if not (mgchk or aux.SynMixHandCheck(g,tp,sc)) then return false end
	for c in aux.Next(g) do
		local le,lf,lloc,lmin,lmax=c:GetTunerLimit()
		if le then
			local lct=g:GetCount()-1
			if lloc then
				local llct=g:FilterCount(Card.IsLocation,c,lloc)
				if llct~=lct then return false end
			end
			if lf and g:IsExists(aux.SynLimitFilter,1,c,lf,le,sc) then return false end
			if (lmin and lct<lmin) or (lmax and lct>lmax) then return false end
		end
	end
	return true
end
function s.SynMixTarget(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local minc=0
	local maxc=99
	local gc=nil
	if min then
		local exct=1
		if min-exct>minc then minc=min-exct end
		if max-exct<maxc then maxc=max-exct end
		if minc>maxc then return false end
	end
	if Duel.IsPlayerAffectedByEffect(tp,8173184) then
		Duel.RegisterFlagEffect(tp,8173184+1,0,0,1)
	end
	local g=Group.CreateGroup()
	local mg
	local mgchk=false
	if mg1 then
		mg=mg1:Filter(s.SMatCheck,nil,c)
		mgchk=true
	else
		mg=s.SMatCatch(tp,c)
	end
	if smat~=nil then mg:AddCard(smat) end
	s.SubGroupParams={s.slfilter,s.SLevelCal,nil,true,false,{c},{c}}
	aux.GCheckAdditional=s.gcheck(c)
	local sg=s.SelectSubGroup(mg,tp,s.syngoal,Duel.IsSummonCancelable(),2,#mg,c,smat,tp,mgchk)
	aux.GCheckAdditional=nil
	s.SubGroupParams={}
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function s.SynMixOperation(e,tp,eg,ep,ev,re,r,rp,c,smat,mg,min,max)
	local g=e:GetLabelObject()
	c:SetMaterial(g)
	local rg=g:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	if #rg>0 then
		Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
	end
	local et={}
	s[0]={} s[1]={}
	for tc in aux.Next(mrg) do
		local le1={tc:IsHasEffect(EFFECT_CANNOT_REMOVE)}
		for _,v in pairs(le1) do
			table.insert(et,v)
			local con=v:GetCondition() or aux.TRUE
			s[0][v]=con
			s[1][v]=0
			v:SetCondition(aux.FALSE)
		end
		local le2={Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_REMOVE)}
		for _,v in pairs(le2) do
			table.insert(et,v)
			local tg=v:GetTarget() or aux.TRUE
			if tg(v,tc,tp,REASON_MATERIAL+REASON_SYNCHRO,e) then
				s[0][v]=tg
				s[1][v]=1
				v:SetTarget(s.chtg(tg,tc))
			end
		end
	end
	Duel.Remove(rg,POS_FACEUP,REASON_MATERIAL+REASON_SYNCHRO)
	for _,v in pairs(et) do
		local ch=s[0][v]
		if s[1][v]==0 then v:SetCondition(ch) else v:SetTarget(ch) end
	end
	s[0]={} s[1]={}
	local fg=Group.__sub(g,rg)
	Duel.SendtoGrave(fg,REASON_MATERIAL+REASON_SYNCHRO)
	g:DeleteGroup()
end
function s.tgfilter(c)
	return (c:IsType(TYPE_TUNER) or c:IsSetCard(0x838)) and c:IsFaceup()
end
function s.sendfilter(c,e,tp)
	return (c:IsType(TYPE_TUNER) and c:IsLocation(LOCATION_MZONE) or c:IsSetCard(0x838)) and c:IsCanBeEffectTarget(e) and c:IsControler(tp)
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local g1=g:Filter(s.sendfilter,nil,e,tp)
	local g2=g-g1
	local ct=#g1
	if #g2<#g1 then ct=math.floor(#g/2) end
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.sendfilter(chkc,e,tp) end
	if chk==0 then return #g>1 and #g1>0 end
	local ct=#g1
	if #g2<#g1 then ct=math.floor(#g/2) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tg=g1:Select(tp,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,#tg,PLAYER_ALL,LOCATION_ONFIELD)
end

function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain()
	if #g==0 then return end
	local ct=#g
	local sp=Duel.GetTurnPlayer()
	local tg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,g)	
	if #tg>=ct then
		Duel.Hint(HINT_SELECTMSG,1-sp,HINTMSG_TOGRAVE)
		local sg=tg:Select(1-sp,ct,ct,nil)
		if #sg>0 then
			Duel.HintSelection(sg)
			local tg1=tg:Filter(Card.IsControler,nil,sp)
			local tg2=tg:Filter(Card.IsControler,nil,1-sp)
			Duel.SendtoGrave(tg1,REASON_RULE,sp)
			Duel.SendtoGrave(tg2,REASON_RULE,1-sp)
		end
	end
end
function s.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Remove(c,POS_FACEUP,REASON_EFFECT+EFFECT_SELF_TOGRAVE)
end