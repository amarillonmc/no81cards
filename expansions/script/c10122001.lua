--空想乌托邦 混沌之海
local m=10122001
local cm=_G["c"..m]
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
if not rsv.Utoland then
	rsv.Utoland={}
	rsul=rsv.Utoland
rsul.hint={0,TIMINGS_CHECK_MONSTER+TIMING_CHAIN_END+TIMING_END_PHASE }
function rsul.GraveDestroyActivateEffect(c,code)
	local e1=rsef.QO(c,nil,{m,8},{1,code},nil,nil,LOCATION_GRAVE,nil,rscost.cost(Card.IsAbleToHandAsCost,"th"),rsul.gdtg,rsul.gdop,rsul.hint)
	e1:SetLabel(code)
	return e1
end
function rsul.gdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	if chkc then return false end
	if chk==0 then return tc and tc:IsCanBeEffectTarget(e) and e:GetHandler():GetActivateEffect():IsActivatable(tp) end
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,tp,LOCATION_FZONE)
end
function rsul.gdop(e,tp,eg,ep,ev,re,r,rp)
	local tc,c=Duel.GetFirstTarget(),e:GetHandler()
	local te=tc:GetActivateEffect()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) and te:IsActivatable(tp) then
	   Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	   local tep=tc:GetControler()
	   local cost=te:GetCost()
	   if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
	   Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
	end
end
function rsul.ToHandActivateEffect(c,code)
	local e1=rsef.QO(c,nil,{m,8},{1,code},nil,nil,LOCATION_FZONE,nil,rscost.cost(Card.IsAbleToHandAsCost,"th"),rsul.thtg,rsul.thop,rsul.hint)
	e1:SetLabel(code)
	return e1
end
function rsul.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(rsul.thfilter,tp,LOCATION_HAND,0,1,nil,tp,e:GetLabel()) end
end
function rsul.thfilter(c,tp,code)
	if not c:IsType(TYPE_FIELD) or c:IsCode(code) then return false end
	local te=c:GetActivateEffect()
	--for i,pe in ipairs({Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_ACTIVATE)}) do
		--local con,val=pe:GetCondition(),pe:GetValue()
		--if (not con or con(pe)) and val(pe,te,1-tp) then return false --end
	--end
	--return not c:IsHasEffect(EFFECT_CANNOT_TRIGGER) and not c:IsHasEffect(EFFECT_CANNOT_ACTIVATE)
	return te:IsActivatable(tp,true)
end
function rsul.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,7))
	local tc=Duel.SelectMatchingCard(tp,rsul.thfilter,tp,LOCATION_HAND,0,1,1,nil,tp,e:GetLabel()):GetFirst()
	if tc then
	   local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	   if fc then
		  Duel.SendtoGrave(fc,REASON_RULE)
		  Duel.BreakEffect()
	   end
	   Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	   local te=tc:GetActivateEffect()
	   local tep=tc:GetControler()
	   local cost=te:GetCost()
	   if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
	   Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
	end
end
function rsul.SpecialOrPlaceBool(tp,tc,ct,maxct)
	if not ct then ct=1 end
	if not maxct then maxct=ct end
	if type(maxct)=="function" then maxct=math.min(maxct(tp),ct) end
	local szonect=Duel.IsPlayerAffectedByEffect(tp,10122021) and Duel.GetLocationCount(tp,LOCATION_SZONE) or 0
	if szonect>0 and tc and tc:IsLocation(LOCATION_SZONE) then szonect=szonect+1 end
	local mzonect=not tc and Duel.GetLocationCount(tp,LOCATION_MZONE) or Duel.GetMZoneCount(tp,tc)
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,10122011,0xc333,0x4011,0,0,1,RACE_SPELLCASTER,ATTRIBUTE_DARK) then mzonect=0 end
	if mzonect>0 and Duel.IsPlayerAffectedByEffect(tp,59822133) then mzonect=1 end
	return mzonect+szonect>=ct,mzonect,szonect
end
function rsul.TokenTg(ct,maxct)
	if not ct then ct=1 end
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return rsul.SpecialOrPlaceBool(tp,nil,ct,maxct) end
		Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,ct,0,0)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,ct,0,0)
	end
end
--[[ "useless because move to szone cannot directly point zone"
function rsul.TokenOp(op,ignore,ct,maxct)
	return function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		if (not ignore and not c:IsRelateToEffect(e)) then return end
		if not ct then ct=1 end
		if not maxct then maxct=ct end
		if type(maxct)=="function" then maxct=math.min(maxct(tp),ct) end
		local bool,mzonect,szonect=rsul.SpecialOrPlaceBool(tp,nil,ct)
		if not bool then return end
		local complete=false
		for i=1,maxct do
			if mzonect+szonect<=0 or (i>1 and not Duel.SelectYesNo(tp,aux.Stringid(10122016,1))) then break end
			local zone=0
			local token=Duel.CreateToken(tp,10122011) 
			local loc=LOCATION_MZONE+LOCATION_SZONE 
			if mzonect<=0 then loc=loc-LOCATION_MZONE end
			if szonect<=0 then loc=loc-LOCATION_SZONE end
			local spzone=Duel.SelectDisableField(tp,1,0,loc,0)
			if spzone<=0x10 then
				if Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)>0 then 
					complete=true
					mzonect=mzonect-1
					op({e:GetHandler(),token},e)
				end
			else
				Duel.MoveToField(token,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
				szonect=szonect-1
				local e1=Effect.CreateEffect(c)
				e1:SetCode(EFFECT_CHANGE_TYPE)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetReset(rsreset.est-RESET_TURN_SET)
				e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
				token:RegisterEffect(e1,true)
				rsul.TokenSpellOp(c,token)
			end
		end
		if complete then
			Duel.SpecialSummonComplete()
		end
	end 
end--]]
function rsul.TokenOp(op,ignore,ct,maxct)
	return function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		if (not ignore and not c:IsRelateToEffect(e)) then return end
		if not op then op=rsul.basetkop end
		if not ct then ct=1 end
		if not maxct then maxct=ct end
		local bool,mzonect,szonect=rsul.SpecialOrPlaceBool(tp,nil,ct)
		if not bool then return end
		local complete=false
		for i=1,maxct do
			if mzonect+szonect<=0 then break end
			local zone=0
			local token=Duel.CreateToken(tp,10122011) 
			local b1=mzonect>0
			local b2=szonect>0
			local b3=i>ct
			local sel=rsof.SelectOption(tp,b3,{m,5},b1,{10122021,0},b2,{10122021,1},true)
			if sel==1 then
				break
			elseif sel==2 then
				if Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP) then 
					complete=true
					mzonect=mzonect-1
					op({e:GetHandler(),token},e)
				end
			else
				Duel.MoveToField(token,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
				szonect=szonect-1
				local e1=Effect.CreateEffect(c)
				e1:SetCode(EFFECT_CHANGE_TYPE)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetReset(rsreset.est-RESET_TURN_SET)
				e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
				token:RegisterEffect(e1,true)
				rsul.TokenSpellOp(c,token)
			end
		end
		if complete then
			Duel.SpecialSummonComplete()
		end
	end 
end
function rsul.TokenSpellOp(c,tc)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetRange(LOCATION_SZONE)
	e0:SetTargetRange(LOCATION_MZONE,0)
	e0:SetReset(rsreset.est)
	e0:SetDescription(aux.Stringid(m,1))
	e0:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e0:SetTarget(function(e,sc)
	   return e:GetHandler():GetColumnGroup():Filter(Card.IsControler,nil,tp):IsContains(sc)
	end)
	e0:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e0:SetValue(aux.indoval)
	tc:RegisterEffect(e0)
	local e1=e0:Clone()
	e1:SetCode(EFFECT_UNRELEASABLE_SUM)
	e1:SetValue(function(e,re,rp)
	   return rp==1-e:GetHandlerPlayer()
	end)
	tc:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	tc:RegisterEffect(e2)   
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetReset(rsreset.est)
	e3:SetCondition(function(e,tp)
	   return Duel.GetTurnPlayer()==tp
	end)
	e3:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
	   if chk==0 then return e:GetHandler():GetColumnGroup():Filter(Card.IsControler,nil,1-tp):FilterCount(Card.IsAbleToRemove,nil)>0 end
	end)
	e3:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
	   local g=e:GetHandler():GetColumnGroup():Filter(Card.IsControler,nil,1-tp):Filter(Card.IsAbleToRemove,nil)  
	   if g:GetCount()>0 then
		  Duel.Hint(HINT_CARD,0,10122011)
		  Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	   end  
	end)
	tc:RegisterEffect(e3)
end
function rsul.basetkop(c,e)
	rsef.SV_INDESTRUCTABLE(c,"battle",1,nil,rsreset.est,nil,{m,3})
	rsef.SV_LIMIT(c,"ress",1,nil,rsreset.est,nil,{m,6})
end
function rsul.advtkop(c,e)
	rsef.SV_INDESTRUCTABLE(c,"ct",rsval.indbae("battle"),nil,rsreset.est,nil,{m,1},1)
	rsef.SV_LIMIT(c,"ress",1,nil,rsreset.est,nil,{m,4})
end
-------
end
if cm then
function cm.initial_effect(c)
	local e1=rsef.ACT(c)
	local e2=rsul.ToHandActivateEffect(c,m)
	local e3=rsef.QO(c,nil,{m,0},1,"tk,sp",nil,LOCATION_FZONE,nil,rscost.lpcost(500),rsul.TokenTg(1),rsul.TokenOp(),rsul.hint)  
end
------
end