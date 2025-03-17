--熔岩炎山谷的王女
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsAttribute,ATTRIBUTE_FIRE),1)
	c:EnableReviveLimit()
	--record
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetCode(EVENT_ADJUST)
	e0:SetRange(0xff)
	e0:SetOperation(s.adjustop)
	c:RegisterEffect(e0)
	Blacklotus_Laval_Creature=nil
	--add effect
	local e01=Effect.CreateEffect(c)
	e01:SetType(EFFECT_TYPE_SINGLE)
	e01:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e01:SetRange(LOCATION_GRAVE)
	e01:SetCode(id)
	c:RegisterEffect(e01)
	--tograve rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(s.tgcon)
	e1:SetOperation(s.tgop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_REMOVE)
	e4:SetCountLimit(1,id)
	e4:SetTarget(s.sptg)
	e4:SetOperation(s.spop)
	c:RegisterEffect(e4)
end
function s.rcfilter(c)
	return c:IsSetCard(0x39) and c:IsType(TYPE_MONSTER) --and not c:IsCode(id)
end
function s.cfilter(c)
	return c:IsHasEffect(7418201)
end
function s.adjustop(e,tp,eg,ep,ev,re,r,rp)
	--
	if not s.globle_check then
		s.globle_check=true
		local g=Duel.GetMatchingGroup(s.rcfilter,0,0xff,0xff,nil)
		local cregister=Card.RegisterEffect
		local esetcountLimit=Effect.SetCountLimit
		local disexistingmatchingcard=Duel.IsExistingMatchingCard
		local disexistingtarget=Duel.IsExistingTarget
		--[[local dselectmatchingcard=Duel.SelectMatchingCard
		local dselecttarget=Duel.SelectTarget]]
		table_effect={}
		--countlimit_record
		table_countlimit_flag=0
		table_countlimit_count=0
		Effect.SetCountLimit=function(effect,count,flag)
			table_countlimit_flag=flag
			table_countlimit_count=count
			return esetcountLimit(effect,count,flag)
		end
		Duel.IsExistingMatchingCard=function(func,p,s,o,count,cgn,...)
			if Blacklotus_Laval_Creature then
				local cgn2=cgn
				if cgn and aux.GetValueType(cgn)=="Card" then
					cgn2=Group.FromCards(cgn,Blacklotus_Laval_Creature)
					return disexistingmatchingcard(func,p,s,o,count,cgn2,...)
				elseif cgn and aux.GetValueType(cgn)=="Group" then
					cgn2:AddCard(Blacklotus_Laval_Creature)
					return disexistingmatchingcard(func,p,s,o,count,cgn2,...)
				else
					return disexistingmatchingcard(func,p,s,o,count,Blacklotus_Laval_Creature,...)
				end
			end
			return disexistingmatchingcard(func,p,s,o,count,cgn,...)
		end
		Duel.IsExistingTarget=function(func,p,s,o,count,cgn,...)
			if Blacklotus_Laval_Creature then
				local cgn2=cgn
				if cgn and aux.GetValueType(cgn)=="Card" then
					cgn2=Group.FromCards(cgn,Blacklotus_Laval_Creature)
					return disexistingtarget(func,p,s,o,count,cgn2,...)
				elseif cgn and aux.GetValueType(cgn)=="Group" then
					cgn2:AddCard(Blacklotus_Laval_Creature)
					return disexistingtarget(func,p,s,o,count,cgn2,...)
				else
					return disexistingtarget(func,p,s,o,count,Blacklotus_Laval_Creature,...)
				end
			end
			return disexistingtarget(func,p,s,o,count,cgn,...)
		end
		--[[Duel.SelectMatchingCard=function(sp,func,p,s,o,min,max,cgn,...)
			if Blacklotus_Laval_Creature then
				local cgn2=cgn
				if cgn and aux.GetValueType(cgn)=="Card" then
					cgn2=Group.FromCards(cgn,Blacklotus_Laval_Creature)
					return dselectmatchingcard(sp,func,p,s,o,min,max,cgn2,...)
				elseif cgn and aux.GetValueType(cgn)=="Group" then
					cgn2:AddCard(Blacklotus_Laval_Creature)
					return dselectmatchingcard(sp,func,p,s,o,min,max,cgn2,...)
				else
					return dselectmatchingcard(sp,func,p,s,o,min,max,Blacklotus_Laval_Creature,...)
				end
			end
			return dselectmatchingcard(sp,func,p,s,o,min,max,cgn,...)
		end
		Duel.SelectTarget=function(sp,func,p,s,o,min,max,cgn)
			if Blacklotus_Laval_Creature then
				local cgn2=cgn
				if cgn and aux.GetValueType(cgn)=="Card" then
					cgn2=Group.FromCards(cgn,Blacklotus_Laval_Creature)
					return dselecttarget(sp,func,p,s,o,min,max,cgn2,...)
				elseif cgn and aux.GetValueType(cgn)=="Group" then
					cgn2:AddCard(Blacklotus_Laval_Creature)
					return dselecttarget(sp,func,p,s,o,min,max,cgn2,...)
				else
					return dselecttarget(sp,func,p,s,o,min,max,Blacklotus_Laval_Creature,...)
				end
			end
			return dselecttarget(sp,func,p,s,o,min,max,cgn,...)
		end]]
		--
		Card.RegisterEffect=function(card,effect,flag)
			if effect and effect:IsHasType(EFFECT_TYPE_IGNITION) then
				local eff=effect:Clone()
				local cost=effect:GetCost()
				local tg=effect:GetTarget()
				local op=effect:GetOperation()
				local edit_cost=(function(e,tp,eg,ep,ev,re,r,rp,chk)
					if chk==0 then
						e:SetLabel(7418201)
						return true
					end	 
				end)
				local edit_tg=(function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
					if chkc then return tg(e,tp,eg,ep,ev,re,r,rp,chk,1) end
					if chk==0 then
						if e:GetLabel()==7418201 then
							e:SetLabel(0)
							local boolean=Duel.IsExistingMatchingCard((function(c)
								Blacklotus_Laval_Creature=c
								local boolean2=(c:IsHasEffect(7418201) and c:IsAbleToRemoveAsCost() and (not cost or cost(e,tp,eg,ep,ev,re,r,rp,0)) and (not tg or tg(e,tp,eg,ep,ev,re,r,rp,0)))
								Blacklotus_Laval_Creature=nil
								return boolean2
							end),tp,LOCATION_GRAVE,0,1,nil)
							return boolean
						else
							local boolean=Duel.IsExistingMatchingCard((function(c)
								Blacklotus_Laval_Creature=c
								local boolean2=(c:IsHasEffect(7418201) and c:IsAbleToRemoveAsCost() and (not tg or tg(e,tp,eg,ep,ev,re,r,rp,0)))
								Blacklotus_Laval_Creature=nil
								return boolean2
							end),tp,LOCATION_GRAVE,0,1,nil)
							return boolean
						end
					end
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
					local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
					Duel.Remove(g,POS_FACEUP,REASON_COST)
					if cost then cost(e,tp,eg,ep,ev,re,r,rp,chk,chkc) end
					if tg then tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) end
				end)
				eff:SetDescription(aux.Stringid(7418201,3))
				eff:SetCost(edit_cost)
				eff:SetTarget(edit_tg)
				eff:SetType(EFFECT_TYPE_QUICK_O)
				eff:SetCode(EVENT_FREE_CHAIN)
				eff:SetHintTiming(TIMING_END_PHASE,TIMING_DRAW_PHASE+TIMING_END_PHASE+TIMINGS_CHECK_MONSTER)
				--countlimit
				if not table_countlimit_flag and table_countlimit_count and not s[card:GetOriginalCode()] then
					s[card:GetOriginalCode()]=1
					local countlimit_count=table_countlimit_count
					local ge0=Effect.CreateEffect(e:GetHandler())
					ge0:SetType(EFFECT_TYPE_FIELD)
					ge0:SetCode(EFFECT_ACTIVATE_COST)
					ge0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
					ge0:SetTargetRange(1,1)
					ge0:SetCost(function(e,te_or_c,tp)
						local tc=nil
						local te=e:GetLabelObject()
						if aux.GetValueType(te_or_c)=="Effect" then 
							tc=te_or_c:GetHandler()
						elseif aux.GetValueType(te_or_c)=="Card" then
							tc=te_or_c
						end
						if not tc then tc=te:GetHandler() end
						return tc:GetFlagEffect(7418202)<countlimit_count
					end)
					ge0:SetTarget(function(e,te,tp)
						e:SetLabelObject(te)
						local tc=te:GetHandler()
						local cost2=te:GetCost()
						local tg2=te:GetTarget()
						local op2=te:GetOperation()
						local b1=true
						local b2=true
						local b3=(not op2 or op2==op)
						--if cost2 then b1=(not cost or cost==cost2 or cost2==edit_cost) end
						if tg2 then b2=(not tg or tg==tg2 or tg2==edit_tg) end
						return (--b1 and 
						   b2 or b3) and tc and tc:GetOriginalCode()==card:GetOriginalCode()
					end)
					ge0:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
						local te=e:GetLabelObject()
						local tc=te:GetHandler()
						tc:RegisterFlagEffect(7418202,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
					end)
					Duel.RegisterEffect(ge0,0)
				end
				table.insert(table_effect,eff)
			end
			table_countlimit_flag=0
			table_countlimit_count=0
			return 
		end
		for tc in aux.Next(g) do
			table_effect={}
			Duel.CreateToken(0,tc:GetOriginalCode())
			for key,eff in ipairs(table_effect) do
				cregister(tc,eff)
			end
		end
		Card.RegisterEffect=cregister
		Effect.SetCountLimit=esetcountLimit
	end
	e:Reset()
end
function s.tgfilter(c)
	return c:IsAbleToGraveAsCost() and c:IsSetCard(0x39)
end
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	return c:IsFacedown() and c:IsLocation(LOCATION_EXTRA) and c:IsAbleToGrave()
		and Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_HAND,0,1,nil)
		and Duel.GetTurnPlayer()==tp
		and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_HAND,0,1,1,nil)
	g1:AddCard(c)
	Duel.Hint(HINT_CARD,0,id)
	Duel.SendtoGrave(g1,REASON_RULE)
end
function s.rthfilter(c)
	return c:IsSetCard(0x39) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.rthfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.rthfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,s.rthfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function s.sspfilter(c,mg)
	return c:IsType(TYPE_SYNCHRO) and c:IsSynchroSummonable(nil,mg)
end
function s.spmfilter(c)
	return (c:IsLocation(LOCATION_MZONE) and c:IsFaceup()) or c:IsLocation(LOCATION_HAND)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 then
		Duel.AdjustAll()
		local mg=Duel.GetMatchingGroup(s.spmfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,nil)
		local g=Duel.GetMatchingGroup(s.sspfilter,tp,LOCATION_EXTRA,0,nil,mg)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,4)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			Duel.SynchroSummon(tp,sg:GetFirst(),nil,mg)
		end
	end
end
function s.spfilter3(c,e,tp)
	return c:IsSetCard(0x39) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.tdfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsAbleToDeck()
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter3,tp,LOCATION_REMOVED,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(s.tdfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	local g=Duel.GetMatchingGroup(s.tdfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,LOCATION_REMOVED)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local tg=Duel.GetMatchingGroup(s.spfilter3,tp,LOCATION_REMOVED,0,nil,e,tp)
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local g=nil
	if tg:GetCount()>ft then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		g=tg:Select(tp,ft,ft,nil)
	else
		g=tg
	end
	if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.IsExistingMatchingCard(s.tdfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) then
		Duel.BreakEffect()
		local tdg=Duel.GetMatchingGroup(s.tdfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
		Duel.SendtoDeck(tdg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
