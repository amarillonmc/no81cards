--余火
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(10171001)
if rsds then return end
rsds=cm 
function rsds.cost1(e,...)
	e:SetLabel(100)
	return rscost.cost(Card.IsReleasable,"res")(e,...)
end
function cm.costfun(e,tp)
	e:SetValue(100)
end 
function rsds.cost2(ct)
	return function(e,...)
		e:SetLabel(100)
		return rscost.cost(cm.rmcfilter,"rm",LOCATION_GRAVE,LOCATION_GRAVE,ct,ct)(e,...)
	end
end
function cm.rmcfilter(c,e,tp)
	if not c:IsAbleToRemoveAsCost() or not c:IsType(TYPE_MONSTER) then return false end
	return (c:IsCode(m) and c:IsControler(tp)) or (Duel.IsPlayerAffectedByEffect(tp,m+19) and not c:IsCode(e:GetHandler():GetCode()))
end
function rsds.SearchFun(c,scode,op)
	local e1=rsef.STO(c,EVENT_SUMMON_SUCCESS,{m,0},nil,"se,th","de,dsp",nil,rsds.cost2(1),rsop.target(cm.thfilter(scode),"th",LOCATION_DECK),cm.thop(scode,op))
	local e2=rsef.RegisterClone(c,e1,"code",EVENT_SPSUMMON_SUCCESS)
	return e1,e2
end
function cm.thfilter(scode)
	return function(c)
		return c:IsCode(scode) and c:IsAbleToHand()
	end
end
function cm.thop(scode,op)
	return function(e,tp,...)
		local ct,og,tc=rsop.SelectToHand(tp,cm.thfilter(scode),tp,LOCATION_DECK,0,1,1,nil,{})
		if ct>0 and op then
			op(tc,e,tp,...)
		end
	end
end
function rsds.ChainingFun(c,code,cate,flag,tg,op)
	local e1=rsef.QO(c,EVENT_CHAINING,{code,0},1,cate,flag,LOCATION_MZONE,cm.cfcon,nil,tg,op)
	return e1
end
function cm.cfcon(e,tp,eg,ep,ev,re,r,rp)
	for i=1,ev do
		local te,tep,tecode1,tecode2,teloc=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_CODE,CHAININFO_TRIGGERING_CODE2,CHAININFO_TRIGGERING_LOCATION )
		if tep==tp and (tecode1==m or (tecode2 and tecode2==m)) and teloc&LOCATION_HAND+LOCATION_ONFIELD ~=0 then
			return true
		end
	end
	return false
end
function rsds.ExtraSummonFun(c,code)
	local e1=rscf.SetSummonCondition(c,false,cm.exsumval(code))
	return e1
end
function cm.exsumval(code,excode)
	return function(e,se,sp,st)
		--if not e:GetHandler():IsLocation(LOCATION_EXTRA) then return true end
		return se and se:GetHandler():IsCode(code,excode or 0)
	end
end
function rsds.TributeFun(c,code,cate,flag,tg,op,isign)
	local e1=rsef.QO(c,nil,{code,0},{1,code},cate,flag,LOCATION_HAND,nil,rsds.cost1,tg,op)
	if isign then e1:SetType(EFFECT_TYPE_IGNITION) end
	return e1
end
function rsds.SpExtraFun(c,code,rmcode,spcode,con,ct)
	ct=ct or 1
	local e1=rsef.QO(c,nil,{code,1},{1,code+100},"sp",nil,LOCATION_GRAVE,con,rscost.reglabel(100),cm.spetg(rmcode,spcode,ct),cm.speop(spcode))
	return e1
end
function cm.spefilter(c,e,tp,spcode)
	return c:IsCode(spcode) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sprmfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() and c:IsSetCard(0xa335)
end
function cm.specfilter(c,rmcode)
	return c:IsCode(rmcode) and c:IsAbleToRemoveAsCost() 
end
function cm.spgfilter(g,rmcode)
	return g:IsExists(Card.IsCode,1,nil,rmcode)
end
function cm.spetg(rmcode,spcode,ct)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		local c=e:GetHandler()
		local g=Duel.GetMatchingGroup(cm.spefilter,tp,LOCATION_EXTRA,0,nil,e,tp,spcode)
		local rg=Duel.GetMatchingGroup(cm.sprmfilter,tp,LOCATION_GRAVE,0,c)
		local ft=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_FUSION)
		if chk==0 then
			if e:GetLabel()==100 then
				return c:IsAbleToRemoveAsCost() and rg:IsExists(Card.IsCode,1,nil,rmcode) and #g>0
			else
				return #g>0 and ct==1
			end
		end
		local sct=math.min(ct,#g)
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then sct=1 end
		if c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp] then sct=math.min(c29724053[tp],sct) end 
		sct=math.min(sct,ft)
		local sct2=0
		if e:GetLabel()==100 then 
			e:SetLabel(0)
			rshint.Select(tp,"rm")
			local rg2=rg:SelectSubGroup(tp,cm.spgfilter,false,1,sct,rmcode)
			rg2:AddCard(c)
			sct2=Duel.Remove(rg2,POS_FACEUP,REASON_COST)-1
		end
		e:SetValue(ct==1 and sct or sct2)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,sct,tp,LOCATION_EXTRA)
	end
end
function cm.speop(spcode)
	return function(e,tp,...)
		local sg=Duel.GetMatchingGroup(cm.spefilter,tp,LOCATION_EXTRA,0,nil,e,tp,spcode)
		local sct=e:GetValue()
		if sct<=0 or #sg<sct then return end
		if sct>=2 and Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
		if c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]<sct then return end
		local ft=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_FUSION)
		if ft<sct then return end
		local ct,og=rsgf.SelectSpecialSummon(sg,tp,aux.TRUE,sct,sct,nil,{})
		if #og>0 then
			for tc in aux.Next(og) do
				tc:CompleteProcedure()
			end
		end
	end
end
-------------------------
function cm.initial_effect(c)
	local e2=rsef.QO(c,nil,{m,2},nil,"sp",nil,LOCATION_HAND+LOCATION_MZONE,nil,rsds.cost1,rsop.target2(cm.resetfun,cm.spfilter,"sp",LOCATION_HAND),cm.spop)
	local e3=rsef.QO(c,nil,{m,4},nil,"atk,def",nil,LOCATION_HAND+LOCATION_MZONE,nil,rsds.cost1,rsop.target2(cm.resetfun,cm.atkfilter,"dum",LOCATION_MZONE,LOCATION_MZONE),cm.atkop)
	local e4=rsef.FTF(c,EVENT_LEAVE_FIELD,{m,0},nil,"th",nil,LOCATION_REMOVED,cm.embthcon,cm.embthcost,rsop.target(Card.IsAbleToHand,"th"),cm.embthop)
end
function cm.recop(e,tp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
function cm.resetfun(g,e,tp)
	e:SetLabel(0)
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0xa335) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and ((e:GetLabel()==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0) or (e:GetLabel()==100 and Duel.GetMZoneCount(tp,e:GetHandler(),tp)>0 and c~=e:GetHandler()))
end
function cm.spop(e,tp)
	rsop.SelectSpecialSummon(tp,cm.spfilter,tp,LOCATION_HAND,0,1,1,nil,{},e,tp)
end
function cm.rmfilter(c,e,tp)
	return c:IsAbleToRemove() and c:IsFaceup() and (e:GetLabel()~=100 or c~=e:GetHandler())
end
function cm.rmop(e,tp)
	local ct,og,tc=rsop.SelectRemove(tp,cm.rmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,{ POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY },e,tp)
	if tc and tc:IsLocation(LOCATION_REMOVED) and Duel.ReturnToField(tc) then
		local e1=rsef.SV_UPDATE({e:GetHandler(),tc},"atk",300,nil,rsreset.est,"cd")
	end
end
function cm.atkfilter(c,e,tp)
	return c:IsFaceup() and (e:GetLabel()~=100 or c~=e:GetHandler()) and c:IsSetCard(0xa335,0xc335)
end
function cm.atkop(e,tp)
	local ct=rsop.SelectSolve(HINTMSG_FACEUP,tp,cm.atkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,aux.ExceptThisCard(e),cm.solvefun,e,tp)
end
function cm.solvefun(g,e,tp)
	local tc=g:GetFirst()
	local c=e:GetHandler()
	local e1,e2=rscf.QuickBuff({c,tc},"atk+,def+",500,"rst",rsreset.est_pend)
	tc:RegisterFlagEffect(m,rsreset.est_pend-RESET_LEAVE,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,5))
	local e3,e4=rsef.FV_CANNOT_DISABLE({c,tp},"neg,dise",cm.imval(tc),nil,nil,nil,rsreset.pend)
	--local phase=Duel.GetCurrentPhase()
	--if phase>PHASE_MAIN1 and phase<PHASE_MAIN2 then phase=PHASE_BATTLE end
	--local e3=rsef.SV_IMMUNE_EFFECT({c,tc},rsval.imoe,cm.imcon(phase),rsreset.pend)
end
function cm.imval(tc)
	return function(e,ev)
		local te,loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_LOCATION)
		return tc:GetFlagEffect(m)>0 and loc&LOCATION_MZONE ~=0 and te:GetHandler()==tc
	end
end
function cm.imcon(phase)
	return function(e)
		local cp=Duel.GetCurrentPhase()
		if cp>PHASE_MAIN1 and cp<PHASE_MAIN2 then cp=PHASE_BATTLE end
		return cp==phase
	end
end
function cm.embthfilter(c)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousSetCard(0xa335,0xc335)
end
function cm.embthcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.embthfilter,1,nil) 
end
function cm.embthcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCurrentChain()==0 end
end
function cm.embthop(e,tp)
	local c=aux.ExceptThisCard(e)
	if c then Duel.SendtoHand(c,nil,REASON_EFFECT) end
end
