--星天气 川绿
local s,id,o=GetID()
function s.initial_effect(c)
	--todeck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_RECOVER)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(s.rettg)
	e1:SetOperation(s.retop)
	c:RegisterEffect(e1)
	--change effect range
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(id)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK)
	c:RegisterEffect(e2)
	--adjust
	local e01=Effect.CreateEffect(c)
	e01:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e01:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e01:SetCode(EVENT_ADJUST)
	e01:SetRange(0xff)
	e01:SetOperation(s.adjustop)
	c:RegisterEffect(e01)
	--select
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_REMOVE)
	e3:SetTarget(s.actg)
	e3:SetOperation(s.acop)
	c:RegisterEffect(e3)
end
function s.tdfilter(c)
	return c:IsSetCard(0x109) and c:IsAbleToDeck()
end
function s.rettg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and s.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,s.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,99,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,g:GetCount()*500)
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local ct=Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	if ct>0 then
		Duel.Recover(tp,ct*500,REASON_EFFECT)
	end
end
function s.thfilter(c)
	return c:IsCode(27784944) and c:IsAbleToHand()
end
function s.sumfilter(c)
	return c:IsSetCard(0x109) and c:IsSummonable(true,nil)
end
function s.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) or Duel.IsExistingMatchingCard(s.sumfilter,tp,LOCATION_HAND,0,1,nil) end
end
function s.acop(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(s.sumfilter,tp,LOCATION_HAND,0,1,nil) or b1
	local res=false
	if b1 and (not b2 or Duel.SelectYesNo(tp,aux.Stringid(id,2))) then
		res=true
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
		if g:GetCount()>0 then
			local tc=g:GetFirst()
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
	local b2=Duel.IsExistingMatchingCard(s.sumfilter,tp,LOCATION_HAND,0,1,nil)
	if b2 and (not res or Duel.SelectYesNo(tp,aux.Stringid(id,3))) then
		if res then
			Duel.BreakEffect()
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		local g=Duel.SelectMatchingCard(tp,s.sumfilter,tp,LOCATION_HAND,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.Summon(tp,tc,true,nil)
		end
	end
end
function s.filter(c)
	return c:IsSetCard(0x109)
end
function s.adjustop(e,tp,eg,ep,ev,re,r,rp)
	--
	if not s.globle_check then
		s.globle_check=true
		local c=e:GetHandler()
		--
		local g=Duel.GetMatchingGroup(s.filter,0,0xff,0xff,nil)
		for tc in aux.Next(g) do
			local grant_effect={}
			function s.quick_filter(e)
				if e:IsHasType(EFFECT_TYPE_GRANT) and 
				   (e:IsHasRange(LOCATION_SZONE) or e:IsHasRange(LOCATION_MZONE)) then
					grant_effect[#grant_effect+1]=e
				end
				return false
			end
			local boolean=tc:IsOriginalEffectProperty(s.quick_filter)
			if #grant_effect>0 then
				for _,effect in pairs(grant_effect) do
					local c_effect=effect:Clone()
					local g_effect=c_effect:GetLabelObject()
					if not g_effect then break end
					local g_effect=g_effect:Clone()
					g_effect:SetRange(LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK)
					local condition=effect:GetCondition()
					local target=effect:GetTarget()
					local property=effect:GetProperty()
					c_effect:SetTargetRange(LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0)
					c_effect:SetLabelObject(g_effect)
					c_effect:SetProperty(property|EFFECT_FLAG_SET_AVAILABLE)
					--[[c_effect:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
						return Duel.IsPlayerAffectedByEffect(tp,id)~=nil and (not condition or condition(e,tp,eg,ep,ev,re,r,rp))
					end)]]
					c_effect:SetTarget(function(e,c)
						local c_GetSequence=Card.GetSequence
						Card.GetSequence=(function(c) return 0 end)
						local c_GetLinkedGroup=Card.GetLinkedGroup
						Card.GetLinkedGroup=(function(lc) return Group.__add(c_GetLinkedGroup(lc),c) end)
						--[[local c_IsType=Card.IsType
						Card.IsType=(function(c,type)
						if type==TYPE_EFFECT then return c_IsType(c,TYPE_MONSTER) end
						return c_IsType(c,type) end)]]
						local boolean=(not target or target(e,c))
						Card.GetSequence=c_GetSequence
						Card.GetLinkedGroup=c_GetLinkedGroup
						--Card.IsType=c_IsType
						return c:IsHasEffect(id) and boolean
					end)
					tc:RegisterEffect(c_effect)
				end
			end
		end
	end
	e:Reset()
end
