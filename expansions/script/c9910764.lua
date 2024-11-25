--虹彩偶像 米娅·泰勒
function c9910764.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,9910764)
	e1:SetCondition(c9910764.spcon)
	e1:SetTarget(c9910764.sptg)
	e1:SetOperation(c9910764.spop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_GRAVE_ACTION)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9910765)
	e2:SetTarget(c9910764.thtg)
	e2:SetOperation(c9910764.thop)
	c:RegisterEffect(e2)
	--redirect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCondition(c9910764.recon)
	e3:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e3)
end
function c9910764.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_FZONE,LOCATION_FZONE,1,nil)
end
function c9910764.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9910764.spfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x5951) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9910764.fselect(g,tp,c)
	local res=true
	if Duel.GetLocationCount(tp,LOCATION_MZONE)==1 or Duel.IsPlayerAffectedByEffect(tp,59822133) then
		res=g:GetCount()<=1
	end
	return res and g:IsContains(c)
end
function c9910764.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c9910764.spfilter,tp,LOCATION_SZONE,0,nil,e,tp)
	if g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,c9910764.fselect,false,1,2,tp,e:GetHandler())
	if sg:GetCount()>0 then Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) end
end
function c9910764.spellfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL) and c:IsAbleToDeck()
end
function c9910764.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and c9910764.spellfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9910764.spellfilter,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=5 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9910764,0))
	local g=Duel.SelectTarget(tp,c9910764.spellfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	g:AddCard(e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,2,0,0)
end
function c9910764.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ConfirmDecktop(tp,5)
	local g2=Duel.GetDecktopGroup(tp,5)
	if #g2~=5 then return end
	local clist={}
	for sc in aux.Next(g2) do
		local code,code2=sc:GetCode()
		table.insert(clist,code)
		if code2 then
			table.insert(clist,code2)
		end
	end
	Duel.SortDecktop(tp,tp,5)
	local g=Group.CreateGroup()
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) then g:AddCard(c) end
	if tc:IsRelateToEffect(e) then g:AddCard(tc) end
	if g:GetCount()>0 then
		Duel.BreakEffect()
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetLabel(table.unpack(clist))
	e1:SetOperation(c9910764.thop2)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c9910764.thfilter(c,clist)
	if not c:IsAbleToHand() then return false end
	for i=1,#clist do
		local code=clist[i]
		if c:IsCode(code) then return true end
	end
	return false
end
function c9910764.thop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,9910764)
	local clist={e:GetLabel()}
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9910764.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,clist)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c9910764.recon(e)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:GetReasonPlayer()~=c:GetControler()
end
