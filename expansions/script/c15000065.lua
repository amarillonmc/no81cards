local m=15000065
local cm=_G["c"..m]
cm.name="与色带神的连接"
function cm.initial_effect(c)
	--Activate  
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(15000065,0)) 
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(15000065,1)) 
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_ACTIVATE)  
	e2:SetCode(EVENT_FREE_CHAIN) 
	e2:SetCountLimit(1,15000065)  
	e2:SetCondition(c15000065.drcon)  
	e2:SetOperation(c15000065.drop) 
	c:RegisterEffect(e2)
	--when SpecialSummon
	local e3=Effect.CreateEffect(c) 
	e3:SetDescription(aux.Stringid(15000065,5)) 
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,15010065) 
	e3:SetCondition(c15000065.descon)
	e3:SetOperation(c15000065.desop)  
	c:RegisterEffect(e3)
	local e4=Effect.Clone(e3)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e4)
	local e5=Effect.Clone(e3)
	e5:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e5)
end
function c15000065.drfilter(c)  
	return c:IsType(TYPE_PENDULUM) and c:IsFaceup() and c:IsAbleToDeck()
end
function c15000065.c3filter(c)  
	return c:IsType(TYPE_PENDULUM) and c:IsFaceup()
end
function c15000065.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c15000065.drfilter,e:GetHandlerPlayer(),LOCATION_EXTRA,0,1,nil)
end
function c15000065.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,e:GetHandlerPlayer(),HINTMSG_TODECK)
	local ag=Duel.SelectMatchingCard(e:GetHandlerPlayer(),c15000065.drfilter,e:GetHandlerPlayer(),LOCATION_EXTRA,0,1,3,nil)
	if ag:GetCount()~=0 then
		Duel.SendtoDeck(ag,nil,1,REASON_EFFECT)
		Duel.ShuffleDeck(e:GetHandlerPlayer())
		Duel.BreakEffect()
		local g=Duel.GetMatchingGroup(c15000065.c3filter,e:GetHandlerPlayer(),LOCATION_PZONE,0,nil)
		if g:GetCount()==2 then
			local cc=g:GetFirst()
			local lsc=cc:GetLeftScale()
			local dc=g:GetNext()
			local l2sc=dc:GetLeftScale()
			if (lsc==l2sc or lsc==l2sc-1 or lsc==l2sc+1) and Duel.SelectYesNo(tp,aux.Stringid(15000065,2)) and Duel.IsPlayerCanDraw(e:GetHandlerPlayer(),2) then
				Duel.Draw(e:GetHandlerPlayer(),2,REASON_EFFECT)
			end
		end
	end
end
function c15000065.desfilter(c,tp)  
	return c:IsFaceup() and c:IsSetCard(0xf33) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_PENDULUM) and c:IsControler(tp) and c:IsDestructable()
end 
function c15000065.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c15000065.desfilter,1,nil,tp)
end
function c15000065.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(e:GetHandlerPlayer(),c15000065.desfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,1,nil)
	if g:GetCount()~=0 then
		Duel.Destroy(g,REASON_EFFECT)
		Duel.BreakEffect()
		local tc=g:GetFirst()
		if ((not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1)) and tc:IsAbleToHand()) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
		if ((Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and not tc:IsAbleToHand()) then
			Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
		if ((Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and tc:IsAbleToHand() and Duel.SelectOption(tp,aux.Stringid(15000065,3),aux.Stringid(15000065,4))==1) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		else
			Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
	end
end