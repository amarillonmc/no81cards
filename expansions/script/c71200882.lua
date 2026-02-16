--绝音魔女·安魂之荆棘姬
function c71200882.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsRace,RACE_ZOMBIE),1)
	c:EnableReviveLimit()
	--synchro level
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SYNCHRO_LEVEL)
	e1:SetLabelObject(c)
	e1:SetValue(c71200882.slevel)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(function(e,c) 
	return c:IsRace(RACE_BEAST) and c:IsLevel(1) and c:IsType(TYPE_TUNER) end)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--to hand
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_RECOVER+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,71200882)
	e1:SetTarget(c71200882.thtg)
	e1:SetOperation(c71200882.thop)
	c:RegisterEffect(e1) 
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD) 
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetValue(function(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetMatchingGroupCount(function(c) return c:IsSetCard(0x895) end,tp,LOCATION_GRAVE,0,nil)*-200 end)
	c:RegisterEffect(e2)  
	--to hand 
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN) 
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET) 
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,71200883)
	e3:SetTarget(c71200882.xthtg)
	e3:SetOperation(c71200882.xthop)
	c:RegisterEffect(e3) 
end
function c71200882.slevel(e,c) 
	local lv=aux.GetCappedLevel(e:GetHandler())
	if c==e:GetLabelObject() then  
		return (3<<16)+lv 
	else 
		return lv
	end 
end
function c71200882.thfilter(c)
	return c:IsSetCard(0x895) and c:IsType(TYPE_MONSTER) and not c:IsCode(71200882) and c:IsAbleToHand()
end
function c71200882.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71200882.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1400)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c71200882.thop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if Duel.Recover(tp,1400,REASON_EFFECT)~=0 then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c71200882.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end 
	end 
end
function c71200882.xthtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) 
	if chkc then return false end 
	if chk==0 then return Duel.IsExistingTarget(function(c) return c:IsSetCard(0x895) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() end,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExistingTarget(nil,tp,0,LOCATION_MZONE,1,nil) end  
	local g1=Duel.SelectTarget(tp,function(c) return c:IsSetCard(0x895) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() end,tp,LOCATION_GRAVE,0,1,1,nil) 
	local g2=Duel.SelectTarget(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
	g1:Merge(g2) 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,g1:GetCount(),0,0)
end
function c71200882.xthop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e) 
	if g:GetCount()==2 then 
		Duel.SendtoHand(g,nil,REASON_EFFECT) 
	end 
end 





