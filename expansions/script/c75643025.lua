--星旅秘纹 永恒的闪耀
local s,id=GetID()
function s.initial_effect(c)
	aux.AddLinkProcedure(c,nil,2,99,s.lcheck)
	c:EnableReviveLimit()
	aux.AddCodeList(c,75643000,75643002)
	--①
	aux.EnableChangeCode(c,75643000,LOCATION_EXTRA+LOCATION_MZONE+LOCATION_GRAVE)
	--②星塔不受对方效果影响
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetTarget(s.immf1)
	e1:SetValue(s.immv1)
	c:RegisterEffect(e1)
	--②摘星征途不受不以自身为对象的对方的卡的效果影响
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(s.immf2)
	e2:SetValue(s.immv2)
	c:RegisterEffect(e2)
	--③
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,id)
	e3:SetTarget(s.gytg)
	e3:SetOperation(s.gyop)
	c:RegisterEffect(e3)
end
function s.lcheck(g,lc)
	return g:IsExists(Card.IsSetCard,1,nil,0x52c6)
end
function s.immf1(e,c)
	return c:IsCode(75643002)
end
function s.immf2(e,c)
	return c:IsFaceup() and c:IsSetCard(0x52c6)
end
function s.immv1(e,re,rp)
	return re:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function s.immv2(e,re,rp,c)
	if re:GetOwnerPlayer()==e:GetHandlerPlayer() then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return true end
	if not c then return false end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return not g or not g:IsContains(c)
end
function s.stfilter(c)
	return c:IsCode(75643002) and c:IsAbleToHand()
end
function s.stfield(c)
	return c:IsCode(75643002) and c:IsFaceup()
end
function s.tcfilter(c)
	return c:IsSetCard(0x52c6) and c:IsAbleToHand()
end
function s.secretfilter(c,sc)
	return c:IsSetCard(0x32c6) and c:IsAbleToHand() and aux.IsCodeListed(c,sc:GetCode())
end
function s.gytg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.stfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingMatchingCard(s.tcfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
	if Duel.IsExistingMatchingCard(s.stfield,tp,LOCATION_ONFIELD,0,1,nil) then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
	end
end
function s.gyop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(s.stfilter,tp,LOCATION_DECK,0,nil)
	local cg=Duel.GetMatchingGroup(s.tcfilter,tp,LOCATION_DECK,0,nil)
	if #sg==0 or #cg==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local st=sg:Select(tp,1,1,nil)
	if Duel.SendtoHand(st,nil,REASON_EFFECT)==0 then return end
	Duel.ConfirmCards(1-tp,st)
	Duel.ShuffleDeck(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=cg:Select(tp,1,1,nil):GetFirst()
	if Duel.SendtoHand(Group.FromCards(tc),nil,REASON_EFFECT)==0 then return end
	Duel.ConfirmCards(1-tp,tc)
	Duel.ShuffleDeck(tp)
	if not Duel.IsExistingMatchingCard(s.stfield,tp,LOCATION_ONFIELD,0,1,nil) then return end
	local mg=Duel.GetMatchingGroup(s.secretfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,nil,tc)
		if #mg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local rg=mg:Select(tp,1,1,nil)
		Duel.SendtoHand(rg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,rg)
		Duel.ShuffleDeck(tp)
	end
end
