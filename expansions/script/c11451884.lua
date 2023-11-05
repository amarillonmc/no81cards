--灵剑小龙
--23.06.15
local cm,m=GetID()
function cm.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,cm.matfilter,1,1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCondition(cm.effcon)
	e1:SetOperation(cm.regop)
	c:RegisterEffect(e1)
	if not cm.global_check then
		cm.global_check=true
		cm[0]=7
		cm[1]=7
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(cm.clear)
		Duel.RegisterEffect(ge2,0)
	end
end
function cm.clear(e,tp,eg,ep,ev,re,r,rp)
	cm[0]=7
	cm[1]=7
end
function cm.matfilter(c)
	return c:IsSummonType(SUMMON_TYPE_NORMAL) and c:IsRace(RACE_DRAGON+RACE_WARRIOR+RACE_SPELLCASTER)
end
function cm.effcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	--inactivatable
	local c=e:GetHandler()
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	e3:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_NORMAL))
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_INACTIVATE)
	e4:SetValue(cm.effectfilter)
	e4:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e4,tp)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_DISEFFECT)
	e5:SetValue(cm.effectfilter)
	e5:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e5,tp)
	--cost
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_ACTIVATE_COST)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetCondition(cm.costcon)
	e1:SetTarget(cm.actarget2)
	e1:SetOperation(cm.costop2)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.effectfilter(e,ct)
	local p=e:GetHandlerPlayer()
	local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
	local tc=te:GetHandler()
	return tc:GetType()==TYPE_SPELL and te:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function cm.costcon(e)
	cm[2]=false
	return cm[e:GetHandlerPlayer()]>0
end
function cm.actarget2(e,te,tp)
	local tc=te:GetHandler()
	e:SetLabelObject(te)
	return tc:GetType()==TYPE_SPELL and te:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function cm.extfilter(c)
	return c:IsType(TYPE_NORMAL) and not c:IsPublic()
end
function cm.thfilter(c)
	return c:IsSetCard(0x9976) and c:IsAbleToHand()
end
function cm.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.eftg(e,c)
	return c:IsType(TYPE_NORMAL) and c:IsSummonableCard()
end
function cm.costop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local te=e:GetLabelObject()
	if cm[2] then return end
	local tg=te:GetTarget() or aux.TRUE
	local tg2=function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
				if chkc then return tg(e,tp,eg,ep,ev,re,r,rp,0,1) end
				if chk==0 then return tg(e,tp,eg,ep,ev,re,r,rp,0) end
				e:SetTarget(tg)
				tg(e,tp,eg,ep,ev,re,r,rp,1)
				local extg=Duel.GetMatchingGroup(cm.extfilter,tp,LOCATION_HAND,0,nil)
				local thg=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil)
				local spg=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
				local sumg=Duel.GetMatchingGroup(Card.IsSummonable,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,true,nil)
				local chk1=(cm[tp]&0x1>0 and #thg>0)
				local chk2=(cm[tp]&0x2>0 and #spg>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0)
				local chk3=(cm[tp]&0x4>0 and #sumg>0)
				if #extg>0 and (chk1 or chk2 or chk3) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
					local g=extg:Select(tp,1,1,nil)
					if #g>0 then
						local e1=Effect.CreateEffect(e:GetHandler())
						e1:SetDescription(aux.Stringid(m,4))
						e1:SetType(EFFECT_TYPE_SINGLE)
						e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
						e1:SetCode(EFFECT_PUBLIC)
						e1:SetReset(RESET_EVENT+RESETS_STANDARD)
						g:GetFirst():RegisterEffect(e1)
						local op0=e:GetOperation() or (function() end)
						local op2=function(e,tp,eg,ep,ev,re,r,rp)
									e:SetOperation(op0)
									op0(e,tp,eg,ep,ev,re,r,rp)
									local thg=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil)
									local spg=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_GRAVE,0,nil,e,tp)
									local sumg=Duel.GetMatchingGroup(Card.IsSummonable,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,true,nil)
									local b1=(cm[tp]&0x1>0 and #thg>0)
									local b2=(cm[tp]&0x2>0 and #spg>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0)
									local b3=(cm[tp]&0x4>0)
									if not (b1 or b2 or b3) then return end
									local off=1
									local ops,opval={},{}
									if b1 then
										ops[off]=aux.Stringid(m,1)
										opval[off]=0
										off=off+1
									end
									if b2 then
										ops[off]=aux.Stringid(m,2)
										opval[off]=1
										off=off+1
									end
									if b3 then
										ops[off]=aux.Stringid(m,3)
										opval[off]=2
									end
									local op=Duel.SelectOption(tp,table.unpack(ops))+1
									local sel=opval[op]
									if sel==0 then
										cm[tp]=cm[tp]-1
										Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
										local g=thg:Select(tp,1,1,nil)
										if #g>0 then
											Duel.SendtoHand(g,nil,REASON_EFFECT)
											Duel.ConfirmCards(1-tp,g)
										end
									elseif sel==1 then
										cm[tp]=cm[tp]-2
										Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
										local tc=spg:Select(tp,1,1,nil):GetFirst()
										if tc then
											Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
											local sc=e:GetHandler()
											local code=sc:GetOriginalCode()
											if code>=11451881 and code<=11451883 and tc:IsType(TYPE_NORMAL) then
												local e1=Effect.CreateEffect(sc)
												e1:SetType(EFFECT_TYPE_SINGLE)
												e1:SetCode(EFFECT_DUAL_SUMMONABLE)
												e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
												e1:SetReset(RESET_EVENT+RESETS_STANDARD)
												tc:RegisterEffect(e1,true)
												local e2=Effect.CreateEffect(sc)
												e2:SetType(EFFECT_TYPE_SINGLE)
												e2:SetCode(EFFECT_REMOVE_TYPE)
												e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
												e2:SetRange(LOCATION_MZONE)
												e2:SetCondition(aux.IsDualState)
												e2:SetValue(TYPE_NORMAL)
												e2:SetReset(RESET_EVENT+RESETS_STANDARD)
												tc:RegisterEffect(e2,true)
												local e3=e2:Clone()
												e3:SetCode(EFFECT_ADD_TYPE)
												e3:SetValue(TYPE_EFFECT)
												tc:RegisterEffect(e3,true)
												--indes
												local e4=Effect.CreateEffect(sc)
												e4:SetType(EFFECT_TYPE_FIELD)
												if code==11451881 then
													e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
													e4:SetValue(function(e,c) return c:GetSummonType()&SUMMON_TYPE_NORMAL==0 end)
												elseif code==11451882 then
													e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
													e4:SetValue(function(e,re,rp) return not re:GetHandler():IsLocation(LOCATION_MZONE) or re:GetHandler():GetSummonType()&SUMMON_TYPE_NORMAL==0 end)
												elseif code==11451883 then
													e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
													e4:SetValue(function(e,re,rp) return not re:GetHandler():IsLocation(LOCATION_MZONE) or re:GetHandler():GetSummonType()&SUMMON_TYPE_NORMAL==0 end)
												end
												e4:SetRange(LOCATION_MZONE)
												e4:SetTargetRange(LOCATION_MZONE,0)
												e4:SetCondition(aux.IsDualState)
												e4:SetTarget(function(e,c) return c:GetOriginalType()&TYPE_NORMAL>0 end)
												e4:SetReset(RESET_EVENT+RESETS_STANDARD)
												tc:RegisterEffect(e4,true)
												--summon
												local e5=Effect.CreateEffect(sc)
												e5:SetDescription(aux.Stringid(code,0))
												e5:SetCategory(CATEGORY_SUMMON)
												e5:SetType(EFFECT_TYPE_QUICK_O)
												e5:SetCode(EVENT_FREE_CHAIN)
												e5:SetRange(LOCATION_MZONE)
												e5:SetCountLimit(1)
												e5:SetCondition(aux.IsDualState)
												if code==11451883 then 
													e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
												end
												e5:SetCost(sc.spcost)
												e5:SetTarget(sc.sptg)
												e5:SetOperation(sc.spop)
												e5:SetReset(RESET_EVENT+RESETS_STANDARD)
												tc:RegisterEffect(e5,true)
												tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(code,0))
												tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(code,1))
											end
											Duel.SpecialSummonComplete()
										end
									elseif sel==2 then
										cm[tp]=cm[tp]-4
										local e1=Effect.CreateEffect(e:GetHandler())
										e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
										e1:SetCode(EVENT_CHAIN_SOLVED)
										e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return re:GetActiveType()==TYPE_SPELL and re:IsHasType(EFFECT_TYPE_ACTIVATE) and rp==tp end)
										e1:SetOperation(cm.sumop2)
										e1:SetReset(RESET_PHASE+PHASE_END,2)
										Duel.RegisterEffect(e1,tp)
										--[[Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
										local tc=sumg:Select(tp,1,1,nil):GetFirst()
										if tc then
											local sc=e:GetHandler()
											local code=sc:GetOriginalCode()
											if code>=11451881 and code<=11451883 then
												local e2=Effect.CreateEffect(sc)
												e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
												e2:SetCode(EVENT_SUMMON_SUCCESS)
												e2:SetLabelObject(sc)
												e2:SetCondition(cm.effcon2)
												e2:SetOperation(cm.regop2)
												e2:SetReset(RESET_PHASE+PHASE_END,2)
												Duel.RegisterEffect(e2,tp)
											end
											Duel.HintSelection(Group.FromCards(tc))
											Duel.Summon(tp,tc,true,nil)
										end--]]
									end
								end
						te:SetOperation(op2)
						local e1=Effect.CreateEffect(e:GetHandler())
						e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
						e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
						e1:SetCode(EVENT_CHAIN_SOLVED)
						e1:SetCountLimit(1)
						e1:SetLabel(ev+1)
						e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return ev==e:GetLabel() end)
						e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp) re:SetOperation(op0) end)
						e1:SetReset(RESET_CHAIN)
						Duel.RegisterEffect(e1,tp)
						local e2=e1:Clone()
						e2:SetCode(EVENT_CHAIN_NEGATED)
						Duel.RegisterEffect(e2,tp)
					end
				end
			end
	te:SetTarget(tg2)
	cm[2]=true
end
function cm.effcon2(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return tc:IsType(TYPE_NORMAL) and tc:IsSummonableCard()
end
function cm.sumop2(e,tp,eg,ep,ev,re,r,rp)
	local sumg=Duel.GetMatchingGroup(Card.IsSummonable,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,true,nil)
	if #sumg>0 and Duel.SelectYesNo(tp,aux.Stringid(m,5)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		local tc=sumg:Select(tp,1,1,nil):GetFirst()
		if tc then
			--Duel.HintSelection(Group.FromCards(tc))
			Duel.Summon(tp,tc,true,nil)
		end
	end
end
function cm.regop2(e,tp,eg,ep,ev,re,r,rp)
	local sc=e:GetLabelObject()
	local code=sc:GetOriginalCode()
	local tc=eg:GetFirst()
	local e1=Effect.CreateEffect(sc)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DUAL_SUMMONABLE)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1,true)
	local e2=Effect.CreateEffect(sc)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_REMOVE_TYPE)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(aux.IsDualState)
	e2:SetValue(TYPE_NORMAL)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e2,true)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_ADD_TYPE)
	e3:SetValue(TYPE_EFFECT)
	tc:RegisterEffect(e3,true)
	--indes
	local e4=Effect.CreateEffect(sc)
	e4:SetType(EFFECT_TYPE_FIELD)
	if code==11451881 then
		e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e4:SetValue(function(e,c) return c:GetSummonType()&SUMMON_TYPE_NORMAL==0 end)
	elseif code==11451882 then
		e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e4:SetValue(function(e,re,rp) return not re:GetHandler():IsLocation(LOCATION_MZONE) or re:GetHandler():GetSummonType()&SUMMON_TYPE_NORMAL==0 end)
	elseif code==11451883 then
		e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e4:SetValue(function(e,re,rp) return not re:GetHandler():IsLocation(LOCATION_MZONE) or re:GetHandler():GetSummonType()&SUMMON_TYPE_NORMAL==0 end)
	end
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetCondition(aux.IsDualState)
	e4:SetTarget(function(e,c) return c:GetOriginalType()&TYPE_NORMAL>0 end)
	e4:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e4,true)
	--summon
	local e5=Effect.CreateEffect(sc)
	e5:SetDescription(aux.Stringid(code,0))
	e5:SetCategory(CATEGORY_SUMMON)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(aux.IsDualState)
	if code==11451883 then 
		e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	end
	e5:SetCost(sc.spcost)
	e5:SetTarget(sc.sptg)
	e5:SetOperation(sc.spop)
	e5:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e5,true)
	tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(code,0))
	tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(code,1))
end