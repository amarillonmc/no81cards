--暗海的鲸脉
if not require and loadfile then
	function require(str)
		require_list=require_list or {}
		if not require_list[str] then
			if string.find(str,"%.") then
				require_list[str]=loadfile(str)
			else
				require_list[str]=loadfile(str..".lua")
			end
			require_list[str]()
			return require_list[str]
		end
		return require_list[str]
	end
end
if not require("expansions/script/c11633000") then require("expansions/script/c11633000") end
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_HAND)
	e2:SetCode(EVENT_ADJUST)
	e2:SetCondition(Dark_Sea_pucon)
	e2:SetOperation(Dark_Sea_puop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_DECK)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,id)
	e3:SetCondition(Dark_Sea_spcon)
	e3:SetOperation(s.addop)
	c:RegisterEffect(e3)
end
function s.drfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and bit.band(c:GetType(),0x81)==0x81
end
function s.drfilter2(c)
	return c:IsSetCard(0xa220) and bit.band(c:GetType(),0x81)==0x81
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.drfilter,tp,LOCATION_MZONE,0,1,nil)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local dg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0):Filter(s.drfilter2,nil)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) and dg:GetCount()>=2 or Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,2-dg:GetCount(),nil) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,tp,LOCATION_HAND)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)>0 then	  
		local c=e:GetHandler()
		if c:IsRelateToEffect(e) then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_CHAIN_END)
			e2:SetReset(RESET_EVENT+RESET_PHASE+PHASE_END)
			e2:SetOperation(s.tgop)
			e2:SetCountLimit(1)
			Duel.RegisterEffect(e2,tp)
		end
	end
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0):Filter(s.drfilter2,nil)	   
	if  Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local num=math.max(3-dg:GetCount(),0)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,num,99,nil)
		if g:GetCount()>=num then
			Duel.ConfirmCards(1-tp,g)
			Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		end
	end
	e:Reset()
end   
--
function s.addop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ResetFlagEffect(tp,11633002)
	if Duel.GetFlagEffect(tp,11633001)==2 then
		Duel.ResetFlagEffect(tp,11633001)
		Duel.RegisterFlagEffect(tp,11633001,RESET_PHASE+PHASE_END,0,1)
	else
		Duel.ResetFlagEffect(tp,11633001)
	end
end
