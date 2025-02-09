--[[
「最后的任务」
"Final Task"
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()

local FLAG_RECORDED_NAMES			= id

Duel.LoadScript("glitchylib_vsnemo.lua")
function s.initial_effect(c)
	c:Activation()
	--See recorded names
	local hint=Effect.CreateEffect(c)
	hint:Desc(0,id)
	hint:SetType(EFFECT_TYPE_IGNITION|EFFECT_TYPE_CONTINUOUS)
	hint:SetProperty(EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_BOTH_SIDE)
	hint:SetRange(LOCATION_ONFIELD)
	hint:SetCountLimit(10)
	hint:SetCondition(s.hasRecordedNamesCond)
	hint:SetOperation(s.hintop)
	c:RegisterEffect(hint)
	--[[If a face-up card(s) you control would be destroyed by battle or by an opponent's card effect, or if it would be sent to the GY by your opponent's card effect, you can banish, face-down, (for
	each of those cards) a number of monsters (from your hand and/or field) equal to the number of card names recorded on this card +1 instead, and if you do, record the names of those cards that
	would be destroyed/sent to the GY on this card (you must protect all those cards, if you use this effect).]]
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTarget(s.reptg(s.repfilter))
	e1:SetValue(s.repval(s.repfilter))
	e1:SetOperation(s.repop)
	c:RegisterEffect(e1)
	local e1a=e1:Clone()
	e1a:SetCode(EFFECT_SEND_REPLACE)
	e1a:SetTarget(s.reptg(s.repfilter2))
	e1a:SetValue(s.repval(s.repfilter2))
	c:RegisterEffect(e1a)
	--Cards on the field whose name is recorded on this card are unaffected by your opponent's card effects.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e2:SetCondition(s.hasRecordedNamesCond)
	e2:SetTarget(s.imtg)
	e2:SetValue(s.imval)
	c:RegisterEffect(e2)
	--During the End Phase: Banish a number of cards equal to the number of card names recorded on this card +1 from the top of your Deck, face-down.
	local e3=Effect.CreateEffect(c)
	e3:Desc(1,id)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE|PHASE_END)
	e3:SetRange(LOCATION_SZONE)
	e3:OPT()
	e3:SetTarget(s.rmtg)
	e3:SetOperation(s.rmop)
	c:RegisterEffect(e3)
end
--E0
function s.hasRecordedNamesCond(e)
	return e:GetHandler():HasFlagEffect(FLAG_RECORDED_NAMES)
end
function s.hintop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local G=Group.CreateGroup()
	for _,code in ipairs({c:GetFlagEffectLabel(FLAG_RECORDED_NAMES)}) do
		local temp=Duel.CreateToken(tp,code)
		G:AddCard(temp)
	end
	if #G>0 then
		G:Select(tp,0,#G,nil)
	end
	Duel.Exile(G,REASON_RULE)
	Duel.SetChainLimitTillChainEnd(aux.FALSE)
end

--E1
function s.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsOnField() and (c:IsReason(REASON_BATTLE) or (c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp)) and not c:IsReason(REASON_REPLACE)
end
function s.repfilter2(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsOnField() and c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp and not c:IsReason(REASON_REPLACE|REASON_DESTROY)
		and c:GetDestination()==LOCATION_GRAVE
end
function s.rmfilter(c,tp)
	return c:IsFaceupEx() and (c:IsLocation(LOCATION_MZONE) or c:IsMonster()) and not c:IsStatus(STATUS_DESTROY_CONFIRMED) and c:IsAbleToRemove(tp,POS_FACEDOWN,REASON_EFFECT|REASON_REPLACE)
end
function s.reptg(f)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk)
				local c=e:GetHandler()
				local ct=c:GetFlagEffect(FLAG_RECORDED_NAMES)+1
				local g=eg:Filter(f,nil,tp)
				local rg=Duel.Group(s.rmfilter,tp,LOCATION_HAND|LOCATION_MZONE,0,g,tp)
				if chk==0 then return #g>0 and #rg>=ct*#g end
				if Duel.SelectEffectYesNo(tp,c,96) then
					local codes={}
					for tc in aux.Next(g) do
						for _,code in ipairs({tc:GetCode()}) do
							if not c:HasFlagEffectLabel(FLAG_RECORDED_NAMES,code) then
								table.insert(codes,code)
							end
						end
					end
					e:SetLabel(#g,table.unpack(codes))
					return true
				else
					return false
				end
			end
end
function s.repval(f)
	return	function(e,c)
				return f(c,e:GetHandlerPlayer())
			end
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetFlagEffect(FLAG_RECORDED_NAMES)+1
	local labels={e:GetLabel()}
	local n=table.remove(labels,1)
	local rct=n*ct
	local rg=Duel.Group(s.rmfilter,tp,LOCATION_HAND|LOCATION_MZONE,0,g,tp)
	Duel.HintMessage(tp,HINTMSG_REMOVE)
	local rtg=rg:Select(tp,rct,rct,nil)
	Duel.Remove(rtg,POS_FACEDOWN,REASON_EFFECT|REASON_REPLACE)
	if #labels==0 then return end
	for _,code in ipairs(labels) do
		c:RegisterFlagEffect(FLAG_RECORDED_NAMES,RESET_EVENT|RESETS_STANDARD,0,1,code)
	end
end

--E2
function s.imtg(e,c)
	local h=e:GetHandler()
	return h:HasFlagEffectLabel(FLAG_RECORDED_NAMES,c:GetCode())
end
function s.imval(e,te)
	return te:GetOwnerPlayer()==1-e:GetHandlerPlayer()
end

--E3
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local ct=c:GetFlagEffect(FLAG_RECORDED_NAMES)+1
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,ct,tp,LOCATION_DECK)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToChain() or not c:IsFaceup() then return end
	local ct=c:GetFlagEffect(FLAG_RECORDED_NAMES)+1
	local g=Duel.GetDecktopGroup(tp,ct)
	if #g==0 then return end
	Duel.DisableShuffleCheck()
	Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
end