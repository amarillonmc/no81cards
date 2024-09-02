--渊洋巨兽 女妖
local cm,m=GetID()

function cm.initial_effect(c)
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x223),aux.NonTuner(Card.IsAttribute,ATTRIBUTE_WATER),1)
	c:EnableReviveLimit()
	--destroy
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e0:SetType(EFFECT_TYPE_QUICK_O)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCountLimit(1)
	e0:SetTarget(cm.tgtg)
	e0:SetOperation(cm.tgop)
	c:RegisterEffect(e0)
	--recover
	--atk record
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CUSTOM+10702118)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(cm.ad1op)
	c:RegisterEffect(e1)
	--atk check
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(cm.ad2op)
	c:RegisterEffect(e2)
	local e6=e2:Clone()
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetOperation(cm.ad3op)
	c:RegisterEffect(e6)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetCode(EVENT_CUSTOM+10702119)
	e4:SetRange(0x04)
	e4:SetOperation(cm.adjustop)
	c:RegisterEffect(e4)
	--atkdefdown
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetCode(EVENT_CUSTOM+m)
	e3:SetRange(0x04)
	e3:SetOperation(cm.adjustop2)
	c:RegisterEffect(e3)
	local e5=e3:Clone()
	e5:SetCode(EVENT_TO_DECK)
	e5:SetCondition(cm.adjustcon)
	c:RegisterEffect(e5)
end
--
function cm.tgtfilter(c)
	return c:IsFaceup() and (c:GetAttack()>0 or c:GetDefense()>0)
end

function cm.tgefilter(c)
	return c:IsFaceup() and c:IsSetCard(0x9223)
end

function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgtfilter,tp,0,0x04,1,nil) and Duel.IsExistingMatchingCard(cm.tgefilter,tp,0,0x40,1,nil) end
end

function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,0x04,nil)
	if #g>0 then
		local below=Duel.GetMatchingGroupCount(cm.tgefilter,tp,0,0x40,nil)*-200
		if below<0 then
			local c=e:GetHandler()
			for tc in aux.Next(g) do
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				e1:SetValue(below)
				tc:RegisterEffect(e1)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_UPDATE_DEFENSE)
				tc:RegisterEffect(e2)
			end
		end
	end
end

function cm.ad1op(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		if tc:GetFlagEffect(110702118)~=0 then
			tc:SetFlagEffectLabel(110702118,tc:GetAttack())
		else
			tc:RegisterFlagEffect(110702118,RESET_EVENT+RESETS_STANDARD,0,1,tc:GetAttack())
		end
	end
end

function cm.opafilter(c)
	return c:GetFlagEffect(110702118)==0
end

function cm.opafilter2(c,tp)
	return c:GetAttack()==0 and c:GetFlagEffectLabel(110702118)~=0 and c:IsControler(1-tp)
end

function cm.ad3op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0x04,0x04,nil)
	Duel.RaiseEvent(g,EVENT_CUSTOM+10702118,e,0,0,0,0)
end

function cm.ad2op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0x04,0x04,nil)
	if e:GetHandler():GetFlagEffect(110702118)==0 then
		Duel.RaiseEvent(g,EVENT_CUSTOM+10702118,e,0,0,0,0)
	else
		local ng=g:Filter(cm.opafilter,nil)
		if #ng>0 then
			Duel.RaiseEvent(ng,EVENT_CUSTOM+10702118,e,0,0,0,0)
		end
	end
	local ng=g:Filter(cm.opafilter2,nil,tp)
	if #ng>0 then
		Duel.RaiseEvent(ng,EVENT_CUSTOM+10702119,e,REASON_ADJUST,tp,tp,0)
	end
	local fg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0x04,0x04,nil)
	if #fg>0 then
		Duel.RaiseEvent(fg,EVENT_CUSTOM+10702118,e,0,0,0,0)
	end
end

function cm.adjustop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.SendtoGrave(eg,REASON_RULE)
	Duel.Recover(tp,500,REASON_EFFECT)
	Duel.Readjust()
end

function cm.conafilter(c,tp)
	return c:IsSetCard(0x9223) and c:IsLocation(0x40) and c:IsFaceup() and c:IsControler(1-tp)
end

function cm.adjustcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.conafilter,1,nil,tp)
end

function cm.adjustop2(e,tp,eg,ep,ev,re,r,rp)
	local fg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,0x04,nil)
	if #fg>0 then
		Duel.Hint(HINT_CARD,0,m)
		local c=e:GetHandler()
		for tc in aux.Next(fg) do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(-200)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			tc:RegisterEffect(e2)
		end
		Duel.Readjust()
		Duel.AdjustAll()
	end
end