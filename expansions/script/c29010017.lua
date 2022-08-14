--方舟骑士-歌蕾蒂娅 29010017 29010016
c29010017.named_with_Arknight=1
function c29010017.initial_effect(c)
	aux.AddCodeList(c,29010009)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29010017,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,29010017)
	e1:SetTarget(c29010017.thtg)
	e1:SetOperation(c29010017.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--control 
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_CONTROL)
	e3:SetDescription(aux.Stringid(29010017,0))
	e3:SetType(EFFECT_TYPE_QUICK_O) 
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c29010017.target)
	e3:SetOperation(c29010017.operation)
	c:RegisterEffect(e3) 
	--recover 
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(29010017,0))
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c29010017.rctg)
	e4:SetOperation(c29010017.rcop)
	c:RegisterEffect(e4)
end 
function c29010017.thfilter(c)
	return c:IsSetCard(0x77af) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c29010017.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29010017.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c29010017.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c29010017.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c29010017.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and chkc:GetControler()~=tp and chkc:IsControlerCanBeChanged() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c29010017.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.GetControl(tc,tp,PHASE_END,1)
	end
end
function c29010017.ckfil(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER)  
end  
function c29010017.rctg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=Duel.GetMatchingGroupCount(c29010017.ckfil,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return rc>0 end 
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(rc*500)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,rc*500)
end
function c29010017.rcop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end








