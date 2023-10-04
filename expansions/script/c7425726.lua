--乌洛波洛斯之影灵衣
local s,id,o=GetID()
function s.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--revive limit
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(s.ritlimit)
	c:RegisterEffect(e1)
	--change effect type
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(id)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(1,0)
	c:RegisterEffect(e2)
	--discard_tohand_remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_TOGRAVE+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,id+1)
	e3:SetTarget(s.remtg)
	e3:SetOperation(s.remop)
	c:RegisterEffect(e3)
	--apply effect
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetCategory(CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCountLimit(1,id)
	e4:SetTarget(s.efftg)
	e4:SetOperation(s.effop)
	c:RegisterEffect(e4)
	--adjust
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetCode(EVENT_ADJUST)
	e0:SetRange(0xff)
	e0:SetOperation(s.adjustop)
	c:RegisterEffect(e0)
	--
	if not s.global_effect then
		s.global_effect=true
		--adjust
		local ge0=Effect.CreateEffect(c)
		ge0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge0:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		ge0:SetCode(EVENT_ADJUST)
		ge0:SetOperation(s.EnableRevive)
		Duel.RegisterEffect(ge0,0)
	end
end
Nekroz_discard_effect={}
Nekroz_discard_effect_card={}
Nekroz_Pendulum_Summonable={}

function s.pfilter(c)
	return c:GetOriginalCode()==id
end
function s.EnableRevive(e,tp,eg,ep,ev,re,r,rp)
	--
	for i=0,1 do
		if Duel.IsPlayerAffectedByEffect(i,id) and not Nekroz_Pendulum_Summonable[i] then
			Nekroz_Pendulum_Summonable[i]=true 
			local pg=Duel.GetMatchingGroup(s.pfilter,i,0xff,0,nil)
			if pg and pg:GetCount()>0 then
				local dg=Group.CreateGroup()
				for tc in aux.Next(pg) do
					local mt=getmetatable(tc)
					local loc=mt.psummonable_location
					if loc==nil then 
						mt.psummonable_location=LOCATION_EXTRA 
					end
				end
			end
		elseif not Duel.IsPlayerAffectedByEffect(i,id) and Nekroz_Pendulum_Summonable[i] then
			Nekroz_Pendulum_Summonable[i]=false 
			local pg=Duel.GetMatchingGroup(s.pfilter,i,0xff,0,nil)
			if pg and pg:GetCount()>0 then
				local dg=Group.CreateGroup()
				for tc in aux.Next(pg) do
					local mt=getmetatable(tc)
					local loc=mt.psummonable_location
					if loc==nil then 
						mt.psummonable_location=nil 
					end
				end
			end
		end
	end
end
function s.adjustop(e,tp,eg,ep,ev,re,r,rp)
	--
	if not s.globle_check then
		s.globle_check=true
		local g=Duel.GetMatchingGroup(s.filter2,0,LOCATION_DECK+LOCATION_HAND,LOCATION_DECK+LOCATION_HAND,nil)
		cregister=Card.RegisterEffect
		cisdiscardable=Card.IsDiscardable
		table_effect={}
		Card.IsDiscardable=function(card,reason)
			Nekroz_discard_effect_check=true
			return true
		end
		Card.RegisterEffect=function(card,effect,flag)
			if effect and effect:GetCost() then
				local cost=effect:GetCost()
				Nekroz_discard_effect_check=false
				local r=cost(e,tp,eg,ep,ev,re,r,rp,0)
				if Nekroz_discard_effect_check then
					Nekroz_discard_effect[card:GetOriginalCode()]=effect:Clone()
				end
			end
			return 
		end
		for tc in aux.Next(g) do
			Duel.CreateToken(0,tc:GetOriginalCode())
		end
		Card.RegisterEffect=cregister
		Card.IsDiscardable=cisdiscardable
	end
	e:Reset()
end
function s.ritlimit(e,se,sp,st)
	return st&SUMMON_TYPE_RITUAL==SUMMON_TYPE_RITUAL or (st&SUMMON_TYPE_PENDULUM==SUMMON_TYPE_PENDULUM and Duel.IsPlayerAffectedByEffect(sp,id))
end
function s.mat_filter(c)
	return not c:IsLevel(9)
end
function s.filter2(c)
	return c:IsSetCard(0xb4) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_RITUAL) 
end
function s.filter(c,tp,e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local eff=Nekroz_discard_effect[c:GetOriginalCode()]
	if not eff then return false end
	local target=eff:GetTarget()
	if target then
		return c:IsSetCard(0xb4) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_RITUAL) and c:GetTurnID()==Duel.GetTurnCount() and target(e,tp,eg,ep,ev,re,r,rp,0,chkc)
	end
	return c:IsSetCard(0xb4) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_RITUAL) and c:GetTurnID()==Duel.GetTurnCount() and Nekroz_discard_effect[c:GetOriginalCode()]
end
function s.efftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		local te=e:GetLabelObject()
		local tg=te:GetTarget()
		return tg and tg(e,tp,eg,ep,ev,re,r,rp,0,chkc)
	end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_GRAVE,0,1,nil,tp,e,tp,eg,ep,ev,re,r,rp,chk,chkc) end
	e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e:SetCategory(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_GRAVE,0,1,1,nil,tp,e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local te=Nekroz_discard_effect[g:GetFirst():GetOriginalCode()]
	Duel.ClearTargetCard()
	e:SetProperty(te:GetProperty())
	e:SetLabel(te:GetLabel())
	e:SetLabelObject(te:GetLabelObject())
	local tg=te:GetTarget()
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
	te:SetLabel(e:GetLabel())
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Nekroz_discard_effect_card[te]=g:GetFirst()
	Duel.ClearOperationInfo(0)
end
function s.effop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local tc=Nekroz_discard_effect_card[te]
	if tc and tc:IsRelateToEffect(e) then
		e:SetLabel(te:GetLabel())
		e:SetLabelObject(te:GetLabelObject())
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
		te:SetLabel(e:GetLabel())
		te:SetLabelObject(e:GetLabelObject())
	end
end
function s.remtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_HAND,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_GRAVE)
end
function s.remop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_HAND,nil)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,nil)
	local g3=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,nil)
	if g1:GetCount()>0 and g2:GetCount()>0 and g3:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg1=g1:RandomSelect(tp,1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local sg2=g2:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg3=g3:Select(tp,1,1,nil)
		local sg=Group.CreateGroup()
		sg:Merge(sg1)
		sg:Merge(sg2)
		sg:Merge(sg3)
		Duel.HintSelection(sg)
		Duel.SendtoGrave(sg1,REASON_EFFECT)
		Duel.SendtoHand(sg2,nil,REASON_EFFECT)
		Duel.Remove(sg3,POS_FACEUP,REASON_EFFECT)
	end
end
