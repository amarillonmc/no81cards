--真龙剑少女 威风凛·飞马
local s,id,o=GetID()
function c98941057.initial_effect(c)
	if c:GetOriginalCode()==98941057 then
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--p summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetRange(LOCATION_PZONE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,98941057)
	e1:SetCondition(c98941057.descon)
	e1:SetTarget(c98941057.destg)
	e1:SetOperation(c98941057.desop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCost(c98941057.cost)
	e2:SetTarget(c98941057.destg1)
	c:RegisterEffect(e2)
	--change effect type
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(98941057)
	e3:SetRange(LOCATION_DECK+LOCATION_HAND+LOCATION_MZONE)
	e3:SetTargetRange(1,0)
	c:RegisterEffect(e3)
	
	--adjust
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetCode(EVENT_ADJUST)
	e0:SetRange(0xff)
	e0:SetOperation(c98941057.adjustop)
	c:RegisterEffect(e0)
	if not c98941057.global_activate_check then
		c98941057.global_activate_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_SOLVED)
		ge1:SetOperation(c98941057.checkop)
		Duel.RegisterEffect(ge1,0)
	end	
	end
end
function c98941057.checkop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if re:GetValue()~=98941058 then return end
	if rc:IsLocation(LOCATION_MZONE) and rc:GetFlagEffect(98941057)==0 then
		rc:RegisterFlagEffect(98941057,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
function c98941057.actarget(e,te,tp)
	--prevent activating
	local tc=te:GetHandler()
	return ((te:GetValue()==98941058) and not Duel.IsPlayerAffectedByEffect(te:GetHandlerPlayer(),98941057)) or ((te:GetValue()==98941057) and Duel.IsPlayerAffectedByEffect(te:GetHandlerPlayer(),98941057))
end
function c98941057.adjustop(e,tp,eg,ep,ev,re,r,rp)
	--
	if not c98941057.globle_check then
		local c=e:GetHandler()
		--change effect type
		--
		c98941057.globle_check=true
		local ge0=Effect.CreateEffect(e:GetHandler())
		ge0:SetType(EFFECT_TYPE_FIELD)
		ge0:SetCode(EFFECT_ACTIVATE_COST)
		ge0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
		ge0:SetCost(aux.FALSE)
		ge0:SetTargetRange(1,1)
		ge0:SetTarget(c98941057.actarget)
		Duel.RegisterEffect(ge0,0)
		--Activate to field
		local ge1=Effect.CreateEffect(e:GetHandler())
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetCode(EFFECT_ACTIVATE_COST)
		ge1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
		ge1:SetTargetRange(1,0)
		ge1:SetTarget(c98941057.actarget2)
		ge1:SetOperation(c98941057.costop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		Duel.RegisterEffect(ge2,1)
		local g=Duel.GetMatchingGroup(c98941057.aafilter,tp,0xff,0xff,nil)
		cregister=Card.RegisterEffect
		ecreateeffect=Effect.CreateEffect
		esetcountLimit=Effect.SetCountLimit
		table_effect={}
		table_countlimit_flag=0
		table_countlimit_count=0
		Effect.SetCountLimit=function(effect,count,flag)
			table_countlimit_flag=flag
			table_countlimit_count=count
			return esetcountLimit(effect,count,flag)
		end
		Card.RegisterEffect=function(card,effect,flag)
			if effect then
				local eff=effect:Clone()
				local cost=eff:GetCost()
				if effect:IsHasType(EFFECT_TYPE_ACTIVATE)  then
					eff:SetValue(98941059)
					--effect edit
					local eff2=effect:Clone()
					if table_countlimit_flag~=0 and table_countlimit_count==1 then
						esetcountLimit(eff2,1,0)
					end
					eff2:SetType(EFFECT_TYPE_QUICK_O)
					eff2:SetValue(98941058)
					eff2:SetDescription(aux.Stringid(98941057,0))
					eff2:SetRange(LOCATION_HAND)
					eff2:SetCost(c98941057.acost)
					table.insert(table_effect,eff2)
				end
				table.insert(table_effect,eff)
			end
			table_countlimit_flag=0
			table_countlimit_count=0
			return 
		end
		for tc in aux.Next(g) do
			table_effect={}
			tc:ReplaceEffect(98941057,0)
			Duel.CreateToken(0,tc:GetOriginalCode())
			for key,eff in ipairs(table_effect) do
				cregister(tc,eff)
			end
		end
		Card.RegisterEffect=cregister
		Effect.CreateEffect=ecreateeffect
		Effect.SetCountLimit=esetcountLimit
	end
	e:Reset()
end
function c98941057.aafilter(c)
	return c:IsSetCard(0xd0) and c:IsType(TYPE_TRAP+TYPE_SPELL)
end
function c98941057.costfilter(c,tp)
	return c:IsRace(RACE_SPELLCASTER) and c:IsAttribute(ATTRIBUTE_WIND)
		and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c98941057.cond(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsCode(98941057)
end
function c98941057.xcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c98941057.costfilter,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,c98941057.costfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c98941057.cfilter(c,tp,rp)
	return c:IsType(TYPE_MONSTER) and c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousLocation(LOCATION_MZONE+LOCATION_PZONE+LOCATION_SZONE)
end
function c98941057.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c98941057.cfilter,1,nil,tp,rp)
end
function c98941057.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local c=e:GetHandler()
		local lpz=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
		local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
		if lpz==nil or rpz==nil then return false end
		local loc=0
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_HAND end
		if Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)>0 then loc=loc+LOCATION_EXTRA end
		if loc==0 then return false end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_EXTRA_PENDULUM_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetValue(aux.TRUE)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local eset={e1}
		local lscale=lpz:GetLeftScale()
		local rscale=rpz:GetRightScale()
		if lscale>rscale then lscale,rscale=rscale,lscale end
		local g=Duel.GetFieldGroup(tp,loc,0)
		local res=g:IsExists(aux.PConditionFilter,1,nil,e,tp,lscale,rscale,eset)
		e1:Reset()
		return res
	end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c98941057.actarget2(e,te,tp)
	local tc=te:GetHandler()
	e:SetLabelObject(te)
	return tc:IsSetCard(0xd0) and te:IsHasType(EFFECT_TYPE_QUICK_O) and tc:IsLocation(LOCATION_HAND) and tc:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c98941057.costop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local tc=te:GetHandler()
	local tp=te:GetHandlerPlayer()
	local te2=te:Clone()
	tc:RegisterEffect(te2)
	te2:UseCountLimit(tp)
	te:SetType(EFFECT_TYPE_ACTIVATE)
	Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,false)
	local ge3=Effect.CreateEffect(tc)
	ge3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	ge3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	ge3:SetCode(EVENT_CHAIN_SOLVED)
	ge3:SetLabelObject(te)
	ge3:SetReset(RESET_PHASE+PHASE_END)
	ge3:SetOperation(c98941057.resetop)
	Duel.RegisterEffect(ge3,tp)
	local ge4=ge3:Clone()
	ge4:SetCode(EVENT_CHAIN_NEGATED)
	Duel.RegisterEffect(ge4,tp)
end
function c98941057.resetop(e,tp,eg,ep,ev,re,r,rp)
	if re==e:GetLabelObject() and re:IsHasType(EFFECT_TYPE_ACTIVATE) then
		e:Reset()
		re:Reset()
	end
end
function c98941057.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_PENDULUM_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(aux.TRUE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local eset={e1}
	local lpz=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	local lscale=lpz:GetLeftScale()
	local rscale=rpz:GetRightScale()
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local loc=0
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)
	local ft=Duel.GetUsableMZoneCount(tp)
	local ect=c98941057 and Duel.IsPlayerAffectedByEffect(tp,98941057) and c98941057[tp]
	if ect and ect<ft2 then ft2=ect end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then
		if ft1>0 then ft1=1 end
		if ft2>0 then ft2=1 end
		ft=1
	end
	if ft1>0 then loc=loc|LOCATION_HAND end
	if ft2>0 then loc=loc|LOCATION_EXTRA end
	local tg=Duel.GetMatchingGroup(aux.PConditionFilter,tp,loc,0,nil,e,tp,lscale,rscale,eset)
	tg=tg:Filter(aux.PConditionExtraFilterSpecific,nil,e,tp,lscale,rscale,e1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	aux.GCheckAdditional=aux.PendOperationCheck(ft1,ft2,ft)
	local g=tg:SelectSubGroup(tp,aux.TRUE,false,1,math.min(#tg,ft))
	aux.GCheckAdditional=nil
	if not g then
		e1:Reset()
		return
	end
	local sg=Group.CreateGroup()
	sg:Merge(g)
	Duel.HintSelection(Group.FromCards(lpz))
	Duel.HintSelection(Group.FromCards(rpz))
	Duel.RaiseEvent(sg,EVENT_SPSUMMON_SUCCESS_G_P,e,REASON_EFFECT,tp,tp,0)
	Duel.SpecialSummon(sg,SUMMON_TYPE_PENDULUM,tp,tp,true,true,POS_FACEUP)
	e1:Reset()
end
function c98941057.pcfilter(c,tp)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0xc7,0xd0) and not c:IsForbidden() and c:CheckUniqueOnField(tp,LOCATION_SZONE) and c:GetRightScale()>3
end
function c98941057.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and  Duel.IsExistingMatchingCard(c98941057.pcfilter,tp,LOCATION_EXTRA+LOCATION_DECK,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c98941057.pcfilter,tp,LOCATION_EXTRA+LOCATION_DECK,0,1,1,nil,tp)
	if g:GetCount()>0 then
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function c98941057.destg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then  
		local c=e:GetHandler()
		local loc=0
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_HAND end
		if Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)>0 then loc=loc+LOCATION_EXTRA end
		if loc==0 then return false end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_EXTRA_PENDULUM_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetValue(aux.TRUE)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local eset={e1}
		local lscale=5
		local rscale=c:GetRightScale()
		if lscale>rscale then lscale,rscale=rscale,lscale end
		local g=Duel.GetFieldGroup(tp,loc,0)
		local res=g:IsExists(aux.PConditionFilter,1,nil,e,tp,lscale,rscale,eset)
		e1:Reset()
		return res
	end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c98941057.chkfilter(c)
	local loc=0
	if c:IsLocation(LOCATION_DECK) then loc= LOCATION_HAND+LOCATION_MZONE
	else loc= LOCATION_HAND+LOCATION_MZONE+LOCATION_DECK end
	return c:IsFaceupEx() and c:IsSetCard(0xd0) and c:IsType(TYPE_PENDULUM) and Duel.GetMatchingGroup(c98941057.chkfilter1,tp,loc,0,c)
end
function c98941057.chkfilter1(c)
	return c:IsFaceupEx() and c:IsCode(98941057) and not c:IsDisabled()
end
function c98941057.chkfilter2(c)
	return c:IsFaceupEx() and c:IsSetCard(0xd0) and c:IsType(TYPE_PENDULUM)
end
function c98941057.llcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c98941057.chkfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_MZONE,0,e:GetHandler())
	local g2=Duel.GetMatchingGroup(c98941057.chkfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,e:GetHandler())
	if e:GetHandler():IsLocation(LOCATION_DECK) and #g2==0 then return end
	return #g>0 
end
function c98941057.gcheck(g)
	return g:FilterCount(Card.IsCode,nil,98941057)==1 
		and g:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=1
end
function c98941057.acost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.CheckReleaseGroup(tp,c98941057.costfilter,1,nil)
	local b2=Duel.GetMatchingGroup(c98941057.chkfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_MZONE,0,nil)
	local b3=Duel.GetMatchingGroup(c98941057.chkfilter1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_MZONE,0,nil)
	if chk==0 then return b1 or b2 or (b3 and Duel.GetTurnPlayer()==e:GetHandlerPlayer()) end
	if b2 then
		e:SetLabel(0)
		local g=Duel.GetMatchingGroup(c98941057.chkfilter2,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_MZONE,0,nil) 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local sk=2
		if Duel.GetTurnPlayer()==e:GetHandlerPlayer() then sk=1 end
		local tg=g:SelectSubGroup(tp,c98941057.gcheck,false,sk,2)
		Duel.ConfirmCards(1-tp,tg)
		if not c:IsCode(78949372) and (not b1 or Duel.SelectYesNo(tp,aux.Stringid(98941057,1))) then
		   sc=tg:GetFirst()
		   while sc do
			   if (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and Duel.SelectYesNo(tp,aux.Stringid(98941057,3)) then
			  	   Duel.MoveToField(sc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
			   else
				   Duel.SendtoExtraP(sc,nil,REASON_EFFECT)
			   end
			   sc=tg:GetNext()
			end
			if c:IsCode(51250293) then 
				e:SetLabel(LOCATION_DECK) 
			end
		elseif c:IsCode(51250293) then
			local res=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp)
			if Duel.CheckReleaseGroup(tp,s.cfilter,1,nil,tp) and (not res or Duel.SelectYesNo(tp,aux.Stringid(id,1))) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
				local g=Duel.SelectReleaseGroup(tp,s.cfilter,1,1,nil,tp)
				Duel.Release(g,REASON_COST)
				e:SetLabel(LOCATION_DECK)
			end
		elseif c:IsCode(78949372) then 
			if chk==0 then return true end
		else
			if chk==0 then return Duel.CheckReleaseGroup(tp,c98941057.costfilter,1,nil) end
			local g=Duel.SelectReleaseGroup(tp,c98941057.costfilter,1,1,nil)
			Duel.Release(g,REASON_COST)
		end
	elseif not c:IsCode(51250293) then
		if chk==0 then return Duel.CheckReleaseGroup(tp,c98941057.costfilter,1,nil) end
		local g=Duel.SelectReleaseGroup(tp,c98941057.costfilter,1,1,nil)
		Duel.Release(g,REASON_COST)
	else 
		if chk==0 then return true end
		e:SetLabel(0)
		local res=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp)
		if Duel.CheckReleaseGroup(tp,s.cfilter,1,nil,tp) and (not res or Duel.SelectYesNo(tp,aux.Stringid(id,1))) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local g=Duel.SelectReleaseGroup(tp,s.cfilter,1,1,nil,tp)
			Duel.Release(g,REASON_COST)
			e:SetLabel(LOCATION_DECK)
		end
	end
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0xd0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end