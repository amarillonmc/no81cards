--薰风的护风
local s,id=GetID()
local Blacklotus_Gusto_Effect={}
local Blacklotus_Gusto_Effect_Table={}
function s.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--gain effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_END_PHASE,TIMING_END_PHASE)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.cost)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
	--todeck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(TIMING_END_PHASE,TIMING_END_PHASE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,id+1)
	e2:SetTarget(s.tdtg)
	e2:SetOperation(s.tdop)
	c:RegisterEffect(e2)
	--adjust
	local e01=Effect.CreateEffect(c)
	e01:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e01:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e01:SetCode(EVENT_ADJUST)
	e01:SetRange(0xff)
	e01:SetOperation(s.adjustop)
	c:RegisterEffect(e01)
end
function s.cfilter(c)
	return c:IsSetCard(0x10) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave() and Blacklotus_Gusto_Effect_Table[c:GetOriginalCode()]
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_DECK,0,1,1,nil)
	if Duel.SendtoGrave(g,REASON_COST)~=0 then
		local tc=g:GetFirst()
		e:SetLabel(tc:GetOriginalCode())
	end
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		return true
	end
end
function s.eftg(e,c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x10)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 or e:GetLabel()==1 then return false end
	local c=e:GetHandler()
	c:SetHint(CHINT_CARD,e:GetLabel())
	local effect_table=Blacklotus_Gusto_Effect_Table[e:GetLabel()]
	for _,effect in pairs(effect_table) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetTargetRange(0xff,0)
		e1:SetTarget(s.eftg)
		e1:SetLabelObject(effect)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
	local fid=e:GetHandler():GetFieldID()
	c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1,fid)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetLabel(fid)
	e2:SetLabelObject(c)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetCondition(s.resetcon)
	e2:SetOperation(s.resetop)
	Duel.RegisterEffect(e2,tp)
end
function s.resetcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(id)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function s.resetop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	tc:SetHint(CHINT_CARD,0)
	e:Reset()
end
function s.tdfilter(c)
	return c:IsSetCard(0x10) and c:IsAbleToDeck()
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.tdfilter(chkc) and chkc~=c end
	if chk==0 then return c:IsAbleToDeck()
		and Duel.IsExistingTarget(s.tdfilter,tp,LOCATION_GRAVE,0,2,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,s.tdfilter,tp,LOCATION_GRAVE,0,2,2,c)
	g=Group.__add(g,Group.FromCards(c))
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,3,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	g=Group.__add(g,Group.FromCards(c))
	local tdg=g:Filter(Card.IsRelateToEffect,nil,e)
	if #tdg>=3 and Duel.SendtoDeck(tdg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end

--------------------------------get effect----------------------------------------
function s.filter(c)
	return c:IsSetCard(0x10) and c:IsType(TYPE_MONSTER)
end
function s.quick_filter(e)
	if (e:IsHasType(EFFECT_TYPE_QUICK_O) or e:IsHasType(EFFECT_TYPE_TRIGGER_O) or e:IsHasType(EFFECT_TYPE_TRIGGER_F) or e:IsHasType(EFFECT_TYPE_IGNITION)) and 
	   e:IsHasType(EFFECT_TYPE_SINGLE) and (e:GetCode()==EVENT_TO_GRAVE or e:GetCode()==EVENT_BATTLE_DESTROYED) and not s.in_array(e,Blacklotus_Gusto_Effect) then
		Blacklotus_Gusto_Effect[#Blacklotus_Gusto_Effect+1]=e
	end
	return false
end
function s.in_array(b,list)
  if not list then
	return false 
  end 
  if list then
	for _,ct in pairs(list) do
	  if ct==b then return true end
	end
  end
  return false
end 
function s.adjustop(e,tp,eg,ep,ev,re,r,rp)
	--
	if not s.globle_check then
		s.globle_check=true
		local c=e:GetHandler()
		--
		local g=Duel.GetMatchingGroup(s.filter,0,0xff,0xff,nil)
		for tc in aux.Next(g) do
			Blacklotus_Gusto_Effect={}
			local boolean=tc:IsOriginalEffectProperty(s.quick_filter)
			if #Blacklotus_Gusto_Effect>0 then
				Blacklotus_Gusto_Effect_Table[tc:GetOriginalCode()]={table.unpack(Blacklotus_Gusto_Effect)}
			end
		end
	end
	e:Reset()
end
