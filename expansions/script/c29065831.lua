--微语之机影 薇洛儿
local m=29065831
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,m+100)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.activate)
	c:RegisterEffect(e2)
end
function cm.thfilter(c,tc)
	return c:IsSetCard(0x87ab) and c:IsType((tc:GetType() & 0x7)) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_HAND,1,nil) end
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local hg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_HAND,nil)
	if #hg==0 then return end
	local sg=hg:RandomSelect(tp,1)
	Duel.ConfirmCards(tp,sg)
	if not Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil,sg:GetFirst()) or not Duel.SelectYesNo(tp,m*16+1) then
		Duel.ShuffleHand(1-tp)
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,sg:GetFirst())
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	Duel.ShuffleHand(1-tp)
end
function cm.spcheck(c,e,tp)
	local tpe=c:GetOriginalType()&0x7
	return tpe&TYPE_MONSTER~=0 and c:IsFaceup() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.spcheck,tp,LOCATION_SZONE,0,1,e:GetHandler(),e,tp) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and not Duel.IsPlayerAffectedByEffect(tp,59822133) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),2,tp,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not e:GetHandler():IsRelateToEffect(e) or Duel.IsPlayerAffectedByEffect(tp,59822133) or Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local tg=Duel.SelectMatchingCard(tp,cm.spcheck,tp,LOCATION_SZONE,0,1,1,c,e,tp)
	if tg:GetCount()==0 then
		return 
	end
	Duel.HintSelection(tg)
	tg:AddCard(c)
	Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
end