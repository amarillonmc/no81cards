--批量生产
local m=11561073
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c11561073.cost)
	e1:SetTarget(c11561073.target)
	e1:SetOperation(c11561073.activate)
	c:RegisterEffect(e1)
	
end
function c11561073.costfilter(c)
	return c:IsAbleToDeckAsCost() and not c:IsCode(11561073)
end
function c11561073.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11561073.costfilter,tp,LOCATION_HAND,0,1,nil) end
	local tc=Duel.SelectMatchingCard(tp,c11561073.costfilter,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
	Duel.ConfirmCards(1-tp,tc)
	tc:SetCardData(CARDDATA_CODE,11561073) 
	tc:SetCardData(CARDDATA_TYPE,TYPE_SPELL)
	tc:SetCardData(CARDDATA_ATTRIBUTE,nil)
	tc:SetCardData(CARDDATA_RACE,nil)
	tc:SetCardData(CARDDATA_ATTACK,nil)
	tc:SetCardData(CARDDATA_DEFENSE,nil)
	tc:SetCardData(CARDDATA_LEVEL,nil)
	tc:ReplaceEffect(11561073,0,1) 
	Duel.ConfirmCards(1-tp,tc)
	Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function c11561073.cgfilter(c)
	return not c:IsCode(11561073)
end
function c11561073.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) and Duel.IsExistingMatchingCard(c11561073.cgfilter,tp,LOCATION_HAND,0,2,nil) and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>3 end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,800)
end
function c11561073.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	if Duel.Damage(p,800,REASON_EFFECT)~=0 then
		if Duel.Draw(p,2,REASON_EFFECT)~=0 then
			local g=Duel.GetMatchingGroup(c11561073.cgfilter,tp,LOCATION_DECK,0,nil) 
			if g:GetCount()>1 then  
				local sg=g:RandomSelect(tp,2) 
				local tc=sg:GetFirst()
				while tc do  
					tc:SetCardData(CARDDATA_CODE,11561073) 
					tc:SetCardData(CARDDATA_TYPE,TYPE_SPELL) 
					tc:SetCardData(CARDDATA_ATTRIBUTE,nil)
					tc:SetCardData(CARDDATA_RACE,nil) 
					tc:SetCardData(CARDDATA_ATTACK,nil) 
					tc:SetCardData(CARDDATA_DEFENSE,nil) 
					tc:SetCardData(CARDDATA_LEVEL,nil)	 
					tc:ReplaceEffect(11561073,0,1) 
					tc=sg:GetNext() 
				end
			end
		end
	end
end
