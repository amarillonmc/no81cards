--执棋者 -方舟骑士-
local m=29065506
local cm=_G["c"..m]
cm.named_with_Arknight=1
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,cm.lcheck)
	c:EnableReviveLimit()
	--tohand
	--local e1=Effect.CreateEffect(c)
	--e1:SetDescription(aux.Stringid(m,0))
	--e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	--e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	--e1:SetProperty(EFFECT_FLAG_DELAY)
	--e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	--e1:SetCountLimit(1,m+100)
	--e1:SetCondition(cm.thcon)
	--e1:SetTarget(cm.thtg)
	--e1:SetOperation(cm.thop)
	--c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,m)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(cm.spcost)
	e2:SetTarget(cm.tga)
	e2:SetOperation(cm.opa)
	c:RegisterEffect(e2)
end
--link summon
function cm.lcheck(g,lc)
	return g:IsExists(Card.IsLinkCode,1,nil,29065502)
end
--tohand
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function cm.thfilter(c)
	return c:IsCode(29065510) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.CheckLPCost(tp,600,true) end
	local lp=Duel.GetLP(tp)
	local g=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	local m=math.floor(math.min(lp,6000)/600)
	if g<6 then g=m end
	local t={}
	for i=1,m do
		t[i]=i*600
	end
	local ac=Duel.AnnounceNumber(tp,table.unpack(t))
	Duel.PayLPCost(tp,ac,true)
	e:SetLabel(ac/600)
end
function cm.cfilter(c)
	return (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight)) and c:IsAbleToHand()
end
function cm.tga(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
		and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_DECK,0,1,nil)end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function cm.opa(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
	local ac=e:GetLabel()
	Duel.ConfirmDecktop(tp,ac)
	local g=Duel.GetDecktopGroup(tp,ac)
	local sg=g:Filter(cm.cfilter,nil)
	if sg:GetCount()>0 then
		Duel.DisableShuffleCheck()
		local hg=sg:SelectSubGroup(tp,aux.dncheck,false,1,g:GetCount())
		if hg:GetFirst():IsAbleToHand() then
			Duel.SendtoHand(hg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,hg)
			Duel.ShuffleHand(tp)
		else
			Duel.SendtoGrave(hg,REASON_RULE)
		end
		Duel.ShuffleDeck(tp)
	else
		Duel.ShuffleDeck(tp)
	end
end
