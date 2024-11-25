--幻入的影灵衣
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,id)
	e2:SetCost(s.setcost)
	e2:SetTarget(s.settg)
	e2:SetOperation(s.setop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetCode(EVENT_ADJUST)
	e3:SetRange(0xff)
	e3:SetOperation(s.adjustop)
	c:RegisterEffect(e3)
end
yly_discard_effect={}
yly_discard_effect_code={}
function s.rsefilter(c,te,e,tp,eg,ep,ev,re,r,rp,rs,...)
	local ext_params={...}
	if s.idfilter(c,table.unpack(ext_params)) then return false end
	local rse=yly_discard_effect[c:GetOriginalCode()]
	if not rse then return false end
	local target=rse:GetTarget()
	if yly_discard_effect_code[c:GetOriginalCode()] then
		local con=rse:GetCondition()
		if yly_discard_effect_code[c:GetOriginalCode()]==EVENT_CHAINING then
			if rs and Duel.GetCurrentChain()<1 then return false end
			local ce
			if not te then
				ce=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_EFFECT)
			else
				ce=te:Clone()
			end
			return Duel.GetCurrentChain()>0 and (te or con(e,tp,eg,ep,ev,ce,r,rp))
		elseif yly_discard_effect_code[c:GetOriginalCode()]==EVENT_ATTACK_ANNOUNCE then
			return Duel.GetAttacker() and con(e,tp,eg,ep,ev,ce,r,rp)
		end
		return false
	end
	if c:GetOriginalCode()==21105106 and Duel.GetCurrentPhase()~=PHASE_MAIN1 then
		return false
	end
	return c:IsSetCard(0xb4) and c:IsType(TYPE_RITUAL) and c:IsAbleToHand() and rse and (not target or target(e,tp,eg,ep,ev,re,r,rp,0))
end
function s.idfilter(c,code1,code2,...)
	if c:GetOriginalCode()==code1 then
		return true
	elseif code2 then
		return s.idfilter(c,code2,...)
	else
		return false
	end
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.rsefilter,tp,LOCATION_MZONE,0,1,false,nil,e,tp,eg,ep,ev,re,r,rp,false) end
	e:SetLabelObject(Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_EFFECT))
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local res=false
	local code={}
	while Duel.IsExistingMatchingCard(s.rsefilter,tp,LOCATION_MZONE,0,1,nil,e:GetLabelObject(),e,tp,eg,ep,ev,re,r,rp,true,table.unpack(code)) and (not res or Duel.SelectYesNo(tp,aux.Stringid(id,2))) do
		if not res then
			res=true
		else
			Duel.BreakEffect()
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local g=Duel.SelectMatchingCard(tp,s.rsefilter,tp,LOCATION_MZONE,0,1,1,nil,e:GetLabelObject(),e,tp,eg,ep,ev,re,r,rp,true,table.unpack(code))
		local tc=g:GetFirst()
		if tc then
			Duel.Hint(HINT_CARD,0,tc:GetOriginalCode())
			table.insert(code,tc:GetOriginalCode())
			local te=yly_discard_effect[tc:GetOriginalCode()]
			local target=te:GetTarget()
			local operation=te:GetOperation()
			if target then target(e,tp,eg,ep,ev+1,e:GetLabelObject(),r,rp,1) end
			if operation then operation(e,tp,eg,ep,ev+1,e:GetLabelObject(),r,rp) end
			local tg=Group.CreateGroup()
			Duel.ChangeTargetCard(Duel.GetCurrentChain()+1,tg)
		end
		Duel.AdjustAll()
	end
end
function s.rfilter(c)
	return c:IsSetCard(0xb4) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_RITUAL) 
end
function s.adjustop(e,tp,eg,ep,ev,re,r,rp)
	if not s.globle_check then
		s.globle_check=true
		local g=Duel.GetMatchingGroup(s.rfilter,0,0xff,0xff,nil)
		yly_RegisterEffect=Card.RegisterEffect
		yly_IsDiscardable=Card.IsDiscardable
		LOCATION_HAND=0xff
		local cs_yly_IsDiscardable=false
		Card.IsDiscardable=function(card,reason)
			cs_yly_IsDiscardable=true
			return true
		end
		Card.RegisterEffect=function(Card_c,Effect_e,bool)
			if Effect_e and Effect_e:GetCost() and yly_discard_effect[Card_c:GetOriginalCode()]==nil then
				local cost=Effect_e:GetCost()
				local r=cost(e,Card_c:GetControler(),eg,ep,ev,re,r,rp,0)
				if cs_yly_IsDiscardable then
					yly_discard_effect[Card_c:GetOriginalCode()]=Effect_e:Clone()
					if Effect_e:GetType() and bit.band(Effect_e:GetType(),EFFECT_TYPE_QUICK_O+EFFECT_TYPE_TRIGGER_O)~=0
						and Effect_e:GetCode()
						and Effect_e:GetCode()~=EVENT_FREE_CHAIN then
						yly_discard_effect_code[Card_c:GetOriginalCode()]=Effect_e:GetCode()
					end
				end
				cs_yly_IsDiscardable=false
			end
			if bool then
				yly_RegisterEffect(Card_c,Effect_e,bool)
			else
				yly_RegisterEffect(Card_c,Effect_e,false)
			end
		end
		for tc in aux.Next(g) do
			if tc.initial_effect then
				local Traitor_initial_effect=s.initial_effect
				s.initial_effect=function() end
				tc:ReplaceEffect(id,0)
				s.initial_effect=Traitor_initial_effect
				tc.initial_effect(tc)
			end
		end
		Card.RegisterEffect=yly_RegisterEffect
		Card.IsDiscardable=yly_IsDiscardable
		LOCATION_HAND=0x2
	end
	e:Reset()
end
function s.cfilter(c)
	return c:IsSetCard(0xb4) and c:IsAbleToDeckAsCost()
end
function s.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_REMOVED,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_REMOVED,0,2,2,nil)
	Duel.HintSelection(g)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SSet(tp,c)
	end
end