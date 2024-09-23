--构异梦境-巡行病房
if not c71400001 then dofile("expansions/script/c71400001.lua") end
function c71400042.initial_effect(c)
	yume.temp_card_field[c]=yume.temp_card_field[c] or {}
	yume.temp_card_field[c].id=71400042
	yume.temp_card_field[c].ft=2
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCountLimit(1,71400042+EFFECT_COUNT_CODE_OATH)
	e0:SetCost(c71400042.cost0)
	c:RegisterEffect(e0)
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
	e1:SetCountLimit(1)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTarget(c71400042.tg1)
	e1:SetDescription(aux.Stringid(71400042,0))
	e1:SetCost(c71400042.cost1)
	e1:SetOperation(c71400042.op1)
	c:RegisterEffect(e1)
	--activate field
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71400001,2))
	e2:SetCategory(EFFECT_TYPE_ACTIVATE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCondition(yume.ActivateFieldCon)
	e2:SetOperation(yume.ActivateFieldOp)
	c:RegisterEffect(e2)
end
function c71400042.filter0(c)
	return c:IsSetCard(0x714) and c:IsType(TYPE_LINK) and c:IsFaceup() and c:IsAbleToGraveAsCost()
end
function c71400042.cost0(e,tp,eg,ep,ev,re,r,rp,chk)
	local lg=Duel.GetMatchingGroup(c71400042.filter0,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return yume.IsRust(tp) or lg:CheckWithSumGreater(Card.GetLink,4) end
	if yume.IsRust(tp) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=lg:SelectSubGroup(tp,Group.CheckWithSumGreater,false,1,4,Card.GetLink,4)
	Duel.SendtoGrave(sg,REASON_COST)
end
function c71400042.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeckAsCost(tp,4) and Duel.CheckLPCost(tp,1000) end
	Duel.DiscardDeck(tp,4,REASON_COST)
	Duel.PayLPCost(tp,1000)
end
function c71400042.filter1sp(c,e,tp)
	return c:IsSetCard(0x714) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK)
end
function c71400042.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	if chk==0 then return g:GetCount()>0 and Duel.GetMZoneCount(tp,g)>0 and Duel.IsExistingMatchingCard(c71400042.filter1sp,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c71400042.filter1th(c)
	return c:IsSetCard(0x714) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c71400042.op1(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,aux.ExceptThisCard(e))
	Duel.SendtoGrave(sg,REASON_EFFECT)
	local ct=sg:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ct>ft then ct=ft end
	local g=Duel.GetMatchingGroup(c71400042.filter1sp,tp,LOCATION_GRAVE,0,nil,e,tp)
	if ct<1 or g:GetCount()==0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local spg=g:Select(tp,1,ct,nil)
	if Duel.SpecialSummon(spg,0,tp,tp,false,false,POS_FACEUP_ATTACK)>0 and (Duel.GetLP(tp)<=4000 or yume.IsRust(tp)) then
		Duel.BreakEffect()
		local thg=Duel.SelectMatchingCard(tp,c71400042.filter1th,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		if thg:GetCount()>0 then
			Duel.SendtoHand(thg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,thg)
		end
	end 
end