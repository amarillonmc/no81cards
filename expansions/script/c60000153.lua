--星冕武装
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,60000150)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(cm.handcon)
	c:RegisterEffect(e2)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_EQUIP)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(cm.activate) 
	c:RegisterEffect(e1)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e3:SetTarget(cm.thtg)
	e3:SetOperation(cm.thop)
	c:RegisterEffect(e3)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e3:SetTarget(cm.eqtg)
	e3:SetOperation(cm.eqop)
	c:RegisterEffect(e3)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,3))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCost(aux.bfgcost)
	e1:SetCondition(aux.exccon)
	e1:SetTarget(cm.geqtg)
	e1:SetOperation(cm.geqop)
	c:RegisterEffect(e1)
end
function cm.handcon(e)
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),m)~=0
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(1,m,RESET_PHASE+PHASE_END,0,1)
	Duel.RegisterFlagEffect(0,m,RESET_PHASE+PHASE_END,0,1)
end
function cm.filter(c)
	return c:IsCode(60000150) and c:IsSpecialSummonable()
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SpecialSummonRule(tp,sg:GetFirst())
	end
end
function cm.thfilter(c)
	return aux.IsCodeListed(c,60000150) and c:IsAbleToHand() and c:GetType()==TYPE_TRAP
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,g)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND,0,1,1,nil)
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
	end
end

function cm.eqfil1(c,tp)
	return c:IsCode(60000150) and c:IsFaceup() and Duel.IsExistingMatchingCard(cm.eqfil2,tp,LOCATION_DECK,0,1,nil,c)
end
function cm.eqfil2(c,tc)
	return c:IsType(TYPE_EQUIP) and Card.CheckEquipTarget(c,tc) and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function cm.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.eqfil1,tp,LOCATION_MZONE,0,1,nil,tp)
		and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK)
end
function cm.eqop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)==0 or not Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,cm.eqfil1,tp,LOCATION_MZONE,0,1,1,nil,tp)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local eg=Duel.SelectMatchingCard(tp,cm.eqfil2,tp,LOCATION_DECK,0,1,1,nil,g:GetFirst())
		if #eg~=0 and Duel.Equip(tp,eg:GetFirst(),g:GetFirst())~=0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local dg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
			Duel.SendtoDeck(dg,nil,2,REASON_EFFECT)
		end
	end
end

function cm.geqfil1(c)
	return c:IsCode(60000150) and c:IsFaceup()
end
function cm.geqfil2(c)
	return aux.IsCodeListed(c,60000150) and c:IsType(TYPE_SPELL)
end
function cm.geqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.geqfil1,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(cm.geqfil2,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_GRAVE)
end
function cm.geqop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(cm.geqfil1,tp,LOCATION_MZONE,0,1,nil) or not Duel.IsExistingMatchingCard(cm.geqfil2,tp,LOCATION_GRAVE,0,1,nil) or Duel.GetLocationCount(tp,LOCATION_SZONE) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,cm.geqfil1,tp,LOCATION_MZONE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local eg=Duel.SelectMatchingCard(tp,cm.geqfil2,tp,LOCATION_GRAVE,0,1,1,nil)
		local ec=eg:GetFirst()
		local tc=g:GetFirst()
		if #eg~=0 and Duel.Equip(tp,ec,tc)~=0 then 
			local e1=Effect.CreateEffect(tc)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetValue(cm.eqlimit)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			ec:RegisterEffect(e1)
			local e2=Effect.CreateEffect(tc)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e2:SetCode(EFFECT_ADD_TYPE)
			e2:SetRange(0xff)
			e2:SetReset(RESET_EVENT+RESETS_REDIRECT)
			e2:SetValue(TYPE_SPELL)
			ec:RegisterEffect(e2)
			local e3=e2:Clone()
			e3:SetValue(TYPE_EQUIP)
			ec:RegisterEffect(e3)
		end
	end
end
function cm.eqlimit(e,c)
	return e:GetOwner()==c
end





