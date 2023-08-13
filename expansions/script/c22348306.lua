--祭 铜 轮 回
local m=22348306
local cm=_G["c"..m]
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,22348306+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c22348306.target)
	e1:SetOperation(c22348306.operation)
	c:RegisterEffect(e1)
	
end
function c22348306.thfilter(c)
	return c:IsFaceupEx() and c:IsSetCard(0x708) and c:IsAbleToHand()
end
function c22348306.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c22348306.thfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if chk==0 then return g:GetClassCount(c22348306.GetType)>1 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,0)
end
function c22348306.GetType(c)
	if c:IsType(TYPE_TRAP) then return 1
	elseif c:IsType(TYPE_MONSTER) then return 2
	elseif c:IsType(TYPE_SPELL) then return 3 
	else return nil
	end
end
function c22348306.tpcheck(g)
	return g:GetClassCount(c22348306.GetType)==#g
end
function c22348306.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c22348306.thfilter),tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g:SelectSubGroup(tp,c22348306.tpcheck,false,2,2)
	if sg:GetCount()==2 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end