--魔法少女的茶话会
local m=43990095
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCountLimit(1,43990095+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c43990095.target)
	e1:SetOperation(c43990095.activate)
	c:RegisterEffect(e1)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(43990095,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c43990095.condition1)
	e2:SetTarget(c43990095.detg)
	e2:SetOperation(c43990095.deop)
	c:RegisterEffect(e2)
	--drow
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(43990095,2))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c43990095.condition2)
	e3:SetTarget(c43990095.drtg)
	e3:SetOperation(c43990095.drop)
	c:RegisterEffect(e3)
	--Damage
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(43990095,3))
	e4:SetCategory(CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c43990095.condition3)
	e4:SetTarget(c43990095.datg)
	e4:SetOperation(c43990095.daop)
	c:RegisterEffect(e4)
	--Decked
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(43990095,4))
	e5:SetCategory(CATEGORY_DECKDES)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c43990095.condition4)
	e5:SetTarget(c43990095.dktg)
	e5:SetOperation(c43990095.dkop)
	c:RegisterEffect(e5)
	--SpecialSummon
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(43990095,5))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCountLimit(1)
	e6:SetCondition(c43990095.condition5)
	e6:SetTarget(c43990095.sptg)
	e6:SetOperation(c43990095.spop)
	c:RegisterEffect(e6)
	
end
function c43990095.thtgfilter(c)
	return c:IsCode(43990025,43990026,43990027,43990028,43990030) and (c:IsAbleToHand() or c:IsAbleToGrave())
end
function c43990095.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c43990095.thtgfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c43990095.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c43990095.thtgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()<=0 then return end
	local tc=g:GetFirst()
	if tc:IsAbleToHand() and (not tc:IsAbleToGrave() or Duel.SelectOption(tp,1190,1191)==0) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	else
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end
function c43990095.detg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,0,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,2,0,0)
end
function c43990095.deop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	g:Merge(g1)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c43990095.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsPlayerCanDraw(1-tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,1)
end
function c43990095.drop(e,tp,eg,ep,ev,re,r,rp)
	local d1=Duel.Draw(tp,1,REASON_EFFECT)
	local d2=Duel.Draw(1-tp,1,REASON_EFFECT)
end
function c43990095.datg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,1000)
end
function c43990095.daop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(1-tp,1000,REASON_EFFECT,true)
	Duel.Damage(tp,1000,REASON_EFFECT,true)
	Duel.RDComplete()
end
function c43990095.dktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,3) and Duel.IsPlayerCanDiscardDeck(1-tp,3) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,PLAYER_ALL,3)
end
function c43990095.dkop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetDecktopGroup(tp,3)
	local g2=Duel.GetDecktopGroup(1-tp,3)
	g1:Merge(g2)
	Duel.SendtoGrave(g1,REASON_EFFECT)
end
function c43990095.spfilter(c,e,tp)
	return c:IsRace(RACE_SPELLCASTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and ((c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0) or Duel.GetLocationCount(tp,LOCATION_MZONE)>0)
end
function c43990095.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c43990095.spfilter,tp,0x41,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x41)
end
function c43990095.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsExistingMatchingCard(c43990095.spfilter,tp,0x41,0,1,nil,e,tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c43990095.spfilter,tp,0x41,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		if tc then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c43990095.filter(c)
	return c:IsFaceup() and c:IsCode(43990025,43990026,43990027,43990028,43990030)
end
function c43990095.condition1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c43990095.filter,tp,LOCATION_ONFIELD,0,nil)
	return g:GetClassCount(Card.GetCode)>=1
end
function c43990095.condition2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c43990095.filter,tp,LOCATION_ONFIELD,0,nil)
	return g:GetClassCount(Card.GetCode)>=2
end
function c43990095.condition3(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c43990095.filter,tp,LOCATION_ONFIELD,0,nil)
	return g:GetClassCount(Card.GetCode)>=3
end
function c43990095.condition4(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c43990095.filter,tp,LOCATION_ONFIELD,0,nil)
	return g:GetClassCount(Card.GetCode)>=4
end
function c43990095.condition5(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c43990095.filter,tp,LOCATION_ONFIELD,0,nil)
	return g:GetClassCount(Card.GetCode)==5
end