--蕾宗忍法·闪光登场
function c22347111.initial_effect(c)
	--①：从卡组把1只「蕾宗忍者」怪兽加入手卡。自己场上没有怪兽存在的场合，也能不加入手卡特殊召唤。
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,22347111+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c22347111.target)
	e1:SetOperation(c22347111.activate)
	c:RegisterEffect(e1)
	--②：把这个回合没有送去墓地的这张卡从墓地除外才能发动。从卡组把1张「蕾宗忍法」魔法卡加入手卡。
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(aux.exccon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c22347111.thtg)
	e2:SetOperation(c22347111.thop)
	c:RegisterEffect(e2)
end
function c22347111.filter(c,e,tp,check)
	return c:IsSetCard(0x5705) and c:IsType(TYPE_MONSTER) and (c:IsAbleToHand()
		or check and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function c22347111.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local check=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		return Duel.IsExistingMatchingCard(c22347111.filter,tp,LOCATION_DECK,0,1,nil,e,tp,check)
	end
end
function c22347111.activate(e,tp,eg,ep,ev,re,r,rp)
	local check=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
	local res=0
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c22347111.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp,check)
	if g:GetCount()<=0 then return end
	local tc=g:GetFirst()
	local b=check and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
	if tc:IsAbleToHand() and (not b or Duel.SelectOption(tp,1190,1152)==0) then
		res=Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	else
		res=Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
	local c=e:GetHandler()
	local exc=nil
	if c:IsStatus(STATUS_LEAVE_CONFIRMED) then exc=c end
	local te=Duel.IsPlayerAffectedByEffect(tp,22347011)
	if c:IsSetCard(0x3705) and c:GetType(TYPE_SPELL) and e:IsHasType(EFFECT_TYPE_ACTIVATE) and te and Duel.SelectYesNo(tp,Auxiliary.Stringid(22347011,1)) and c:IsRelateToEffect(e) and c:IsCanTurnSet()
	then
		if res>0 then Duel.BreakEffect() end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		g=Duel.SelectMatchingCard(tp,c22347111.lllfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
		Duel.Hint(HINT_CARD,0,22347011)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
		c:CancelToGrave()
		Duel.ChangePosition(c,POS_FACEDOWN)
		Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
		end
	end
end
function c22347111.lllfilter(c)
	return c:IsCode(22347011) and c:IsAbleToRemoveAsCost()
end


function c22347111.thfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToHand() and c:IsSetCard(0x3705) 
end
function c22347111.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22347111.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c22347111.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c22347111.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
