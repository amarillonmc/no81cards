--[[
全灵的一扫
Heartily Strike
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
Duel.LoadScript("glitchylib_vsnemo.lua")
function s.initial_effect(c)
	aux.CheckAlreadyRegisteredEffects()
	aux.EnabledRegisteredEffectMods[EXTRA_DECK_INFO_MODS]=true
	--[[Pay 1000 LP, then target 1 monster on the field that was Special Summoned from the Extra Deck; the owner of that monster chooses 1 of the following effects to apply:
	● They send a group of monsters that meets the material requirements of that target from their Deck to the GY.
	● They send that target to the GY.]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(2,id)
	e1:SetCategory(CATEGORY_DECKDES|CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetFunctions(nil,aux.PayLPCost(1000),s.target,s.activate)
	c:RegisterEffect(e1)
	if not s.global_check then
		s.global_check=true
		
		local _GetLocationCountFromEx, _MustMaterialCheck, _IsPlayerAffectedByEffect = Duel.GetLocationCountFromEx, Auxiliary.MustMaterialCheck, Duel.IsPlayerAffectedByEffect
		
		function Duel.GetLocationCountFromEx(...)
			if aux.HeartilyStrikeCheck then return 99 end
			return _GetLocationCountFromEx(...)
		end
		function Auxiliary.MustMaterialCheck(...)
			if aux.HeartilyStrikeCheck then return true end
			return _MustMaterialCheck(...)
		end
		function Duel.IsPlayerAffectedByEffect(p,code)
			if code==8173184 and aux.HeartilyStrikeCheck then return false end
			return _IsPlayerAffectedByEffect(p,code)
		end
		
		function Auxiliary.SynMixCheckRecursive(c,tp,sg,mg,ct,minc,maxc,syncard,sg1,smat,gc,mgchk)
			sg:AddCard(c)
			ct=ct+1
			local res=false
			if not sg:CheckWithSumGreater(Card.GetSynchroLevel,syncard:GetLevel()+1,syncard) then
				res=Auxiliary.SynMixCheckGoal(tp,sg,minc,ct,syncard,sg1,smat,gc,mgchk)
				or (ct<maxc and mg:IsExists(Auxiliary.SynMixCheckRecursive,1,sg,tp,sg,mg,ct,minc,maxc,syncard,sg1,smat,gc,mgchk))
			end
			sg:RemoveCard(c)
			ct=ct-1
			return res
		end
	end
end
function s.filter(c)
	if not c:IsSpecialSummoned(LOCATION_EXTRA) or not c:IsType(TYPE_EXTRA) then return false end
	local tp=c:GetOwner()
	return Duel.IsPlayerCanSendtoGrave(tp,c) or (tc:IsFaceup() and s.edprocfilter(c,tp))
end
function s.tgfilter(c,tp)
	return c:IsMonster() and Duel.IsPlayerCanSendtoGrave(tp,c)
end
function s.edprocfilter(c,tp,db)
	local g=Duel.Group(s.tgfilter,tp,LOCATION_DECK,0,nil,tp)
	if #g<=0 then return false end
	local type=c:GetOriginalType()
	
	if type&TYPE_FUSION>0 then
		return c:CheckFusionMaterial(g,nil,PLAYER_NONE,true)
		
	elseif type&TYPE_SYNCHRO>0 then
		local mt=getmetatable(c)
		local tab=mt.ExtraDeckSummonProcTable
		if not tab then return false end
		local proctype=tab[1]
		if proctype==EXTRA_DECK_PROC_SYNCHRO then
			local _,f1,f2,minc,maxc=table.unpack(tab)
			return g:IsExists(aux.SynMixFilter1,1,nil,f1,nil,nil,f2,minc,maxc,c,g,nil,gc,false)
		elseif proctype==EXTRA_DECK_PROC_SYNCHRO_MIX then
			local _,f1,f2,f3,f4,minc,maxc,gc=table.unpack(tab)
			return g:IsExists(aux.SynMixFilter1,1,nil,f1,f2,f3,f4,minc,maxc,c,g,nil,gc,false)
		end
		
	elseif type&TYPE_XYZ>0 then
		local mt=getmetatable(c)
		local tab=mt.ExtraDeckSummonProcTable
		if not tab then return false end
		local proctype=tab[1]
		if proctype==EXTRA_DECK_PROC_XYZ then
			local _,f,lv,ct,alterf,alterdesc,maxct,alterop=table.unpack(tab)
			g=g:Filter(Card.IsXyzLevel,nil,c,lv)
			if f then
				g=g:Filter(f,nil,c)
			end
			return g:CheckSubGroup(Auxiliary.XyzLevelFreeGoal,ct,maxct,tp,c,nil)
		elseif proctype==EXTRA_DECK_PROC_XYZ_LEVEL_FREE then
			local _,f,gf,minc,maxc,alterf,alterdesc,alterop=table.unpack(tab)
			if f then
				g=g:Filter(f,nil,c)
			end
			return g:CheckSubGroup(Auxiliary.XyzLevelFreeGoal,minc,maxc,tp,c,gf)
		end
	
	elseif type&TYPE_LINK>0 then
		local mt=getmetatable(c)
		local tab=mt.ExtraDeckSummonProcTable
		if not tab then return false end
		local proctype=tab[1]
		if proctype==EXTRA_DECK_PROC_LINK then
			local _,f,minc,maxc,gf=table.unpack(tab)
			if f then
				g=g:Filter(f,nil)
			end
			return g:CheckSubGroup(Auxiliary.LCheckGoal,minc,maxc,tp,c,gf,nil)
		end
		
	end
	
	return false
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	aux.HeartilyStrikeCheck=true
	if chkc then
		local res=chkc:IsLocation(LOCATION_MZONE) and s.filter(chkc)
		aux.HeartilyStrikeCheck=false
		return true
	end
	if chk==0 then
		local res=Duel.IsExists(true,s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		aux.HeartilyStrikeCheck=false
		return res
	end
	local g=Duel.Select(HINTMSG_TARGET,true,tp,s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	aux.HeartilyStrikeCheck=false
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOGRAVE,nil,1,g:GetFirst():GetControler(),LOCATION_DECK)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOGRAVE,g,#g,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp,tc,mat)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToChain() or not tc:IsSpecialSummoned(LOCATION_EXTRA) then return end
	local p=tc:GetOwner()
	
	aux.HeartilyStrikeCheck=true
	local b1=tc:IsFaceup() and s.edprocfilter(tc,p,true)
	aux.HeartilyStrikeCheck=false
	local b2=Duel.IsPlayerCanSendtoGrave(p,tc)
	
	local opt=aux.Option(p,id,0,b1,b2)
	if opt==0 then
		aux.HeartilyStrikeCheck=true
		local mg
		local g=Duel.Group(s.tgfilter,p,LOCATION_DECK,0,nil,p)
		local type=tc:GetOriginalType()
	
		if type&TYPE_FUSION>0 then
			mg=Duel.SelectFusionMaterial(p,tc,g,nil,PLAYER_NONE)
			
		elseif type&TYPE_SYNCHRO>0 then
			local mt=getmetatable(tc)
			local tab=mt.ExtraDeckSummonProcTable
			if not tab then return false end
			local proctype=tab[1]
			if proctype==EXTRA_DECK_PROC_SYNCHRO then
				local _,f1,f2,minc,maxc=table.unpack(tab)
				mg=s.synmixselect(p,tc,g,f1,nil,nil,f2,minc,maxc,nil,nil,nil)
			elseif proctype==EXTRA_DECK_PROC_SYNCHRO_MIX then
				local _,f1,f2,f3,f4,minc,maxc,gc=table.unpack(tab)
				mg=s.synmixselect(p,tc,g,f1,f2,f3,f4,minc,maxc,nil,gc,nil)
			end
			
		elseif type&TYPE_XYZ>0 then
			local mt=getmetatable(tc)
			local tab=mt.ExtraDeckSummonProcTable
			if not tab then return false end
			local proctype=tab[1]
			if proctype==EXTRA_DECK_PROC_XYZ then
				local _,f,lv,ct,alterf,alterdesc,maxct,alterop=table.unpack(tab)
				g=g:Filter(Card.IsXyzLevel,nil,tc,lv)
				if f then
					g=g:Filter(f,nil,tc)
				end
				mg=g:SelectSubGroup(p,Auxiliary.XyzLevelFreeGoal,false,ct,maxct,p,tc,nil)
			elseif proctype==EXTRA_DECK_PROC_XYZ_LEVEL_FREE then
				local _,f,gf,minc,maxc,alterf,alterdesc,alterop=table.unpack(tab)
				if f then
					g=g:Filter(f,nil,tc)
				end
				mg=g:SelectSubGroup(p,Auxiliary.XyzLevelFreeGoal,false,minc,maxc,p,tc,gf)
			end
		
		elseif type&TYPE_LINK>0 then
			local mt=getmetatable(tc)
			local tab=mt.ExtraDeckSummonProcTable
			if not tab then return false end
			local proctype=tab[1]
			if proctype==EXTRA_DECK_PROC_LINK then
				local _,f,minc,maxc,gf=table.unpack(tab)
				if f then
					g=g:Filter(f,nil,tc)
				end
				mg=g:SelectSubGroup(p,Auxiliary.LCheckGoal,false,minc,maxc,p,tc,gf,nil)
			end
			
		end
		aux.HeartilyStrikeCheck=false
		
		if #mg>0 then
			Duel.SendtoGrave(mg,REASON_EFFECT,p)
		end
	
	elseif opt==1 then
		Duel.SendtoGrave(tc,REASON_EFFECT,p)
	end
end
function s.synmixselect(tp,c,mg,f1,f2,f3,f4,minc,maxc,smat,gc,mgchk)
	::SynMixTargetSelectStart::
	local g=Group.CreateGroup()
	local c1
	local c2
	local c3
	local g4=Group.CreateGroup()
	local cancel=false
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
	c1=mg:Filter(Auxiliary.SynMixFilter1,nil,f1,f2,f3,f4,minc,maxc,c,mg,smat,gc,mgchk):SelectUnselect(g,tp,false,cancel,1,1)
	if not c1 then goto SynMixTargetSelectCancel end
	g:AddCard(c1)
	if f2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		c2=mg:Filter(Auxiliary.SynMixFilter2,g,f2,f3,f4,minc,maxc,c,mg,smat,c1,gc,mgchk):SelectUnselect(g,tp,false,cancel,1,1)
		if not c2 then goto SynMixTargetSelectCancel end
		if g:IsContains(c2) then goto SynMixTargetSelectStart end
		g:AddCard(c2)
		if f3 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
			c3=mg:Filter(Auxiliary.SynMixFilter3,g,f3,f4,minc,maxc,c,mg,smat,c1,c2,gc,mgchk):SelectUnselect(g,tp,false,cancel,1,1)
			if not c3 then goto SynMixTargetSelectCancel end
			if g:IsContains(c3) then goto SynMixTargetSelectStart end
			g:AddCard(c3)
		end
	end
	for i=0,maxc-1 do
		local mg2=mg:Clone()
		if f4 then
			mg2=mg2:Filter(f4,g,c,c1,c2,c3)
		else
			mg2:Sub(g)
		end
		
		local cg=mg2:Filter(Auxiliary.SynMixCheckRecursive,g4,tp,g4,mg2,i,minc,maxc,c,g,smat,gc,mgchk)
		
		if cg:GetCount()==0 then break end
		
		local finish=Auxiliary.SynMixCheckGoal(tp,g4,minc,i,c,g,smat,gc,mgchk)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local c4=cg:SelectUnselect(g+g4,tp,finish,cancel,minc,maxc)
		if not c4 then
			if finish then break
			else goto SynMixTargetSelectCancel end
		end
		if g:IsContains(c4) or g4:IsContains(c4) then goto SynMixTargetSelectStart end
		g4:AddCard(c4)
	end
	g:Merge(g4)
	::SynMixTargetSelectCancel::
	return g
end