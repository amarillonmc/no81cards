--海造贼-银胡子机关长
local m=89387022
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,93031067)
	aux.AddLinkProcedure(c,cm.mfilter,1,1)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetCode(EVENT_ADJUST)
	e0:SetRange(0xff)
	e0:SetOperation(cm.adjustop)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.thcon)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
end
function cm.mfilter(c)
	return c:IsLevelBelow(4) and c:IsLinkSetCard(0x13f)
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function cm.thfilter(c)
	return c:IsCode(93031067) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function cm.discfilter(c)
	return c:IsCode(m) and not c:IsDisabled() and c:IsAbleToRemoveAsCost()
end
function cm.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.discfilter,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.GetFirstMatchingCard(cm.discfilter,tp,LOCATION_GRAVE,0,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.filter(c)
	return c:IsSetCard(0x13f) and not c:IsCode(id)
end
function cm.adjustop(e,tp,eg,ep,ev,re,r,rp)
	if not cm.globle_check then
		cm.globle_check=true
		local g=Duel.GetMatchingGroup(cm.filter,0,0xff,0xff,nil)
		cregister=Card.RegisterEffect
		cisDiscardable=Card.IsDiscardable
		disexistingmatchingcard=Duel.IsExistingMatchingCard
		local marked=false
		Duel.IsExistingMatchingCard=function(filter,player,s,o,count,c_g_n,...)
			if not Duel.GetFieldGroup(player,s,o) or #Duel.GetFieldGroup(player,s,o)<=0 then
				s=0xff
			end
			return disexistingmatchingcard(filter,player,s,o,count,c_g_n,...)
		end
		Card.IsDiscardable=function(card)
			marked=true
			return true
		end
		Card.RegisterEffect=function(card,effect,flag)
			if effect and effect:GetType()~=EFFECT_TYPE_FIELD then
				marked=false
				local cost=effect:GetCost()
				if cost and cost(e,tp,eg,ep,ev,re,r,rp,0) then end
				if marked then 
					local eff=effect:Clone()
					table.insert(table_effect,eff) 
				end
			end
			return 
		end
		for tc in aux.Next(g) do
			marked=false
			table_effect={}
			Duel.CreateToken(0,tc:GetOriginalCode())
			for key,eff in ipairs(table_effect) do
				eff:SetDescription(aux.Stringid(m,0))
				eff:SetCost(cm.discost)
				cregister(tc,eff,true)
			end
		end
		Card.RegisterEffect=cregister
		Card.IsDiscardable=cisDiscardable
		Duel.IsExistingMatchingCard=disexistingmatchingcard
	end
	e:Reset()
end
