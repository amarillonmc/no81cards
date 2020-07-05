--镜野七罪 奇妙幻想
local m=33400704
local cm=_G["c"..m]
function cm.initial_effect(c)
	--copy
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(m,0))
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1,m+10000)
	e6:SetTarget(cm.cptg)
	e6:SetOperation(cm.cpop)
	c:RegisterEffect(e6)
  --tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,m)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
end
function cm.matfilter(c)
	return c:IsSetCard(0x341) or c:IsRace(RACE_SPELLCASTER)
end
function cm.cptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.matfilter,tp,LOCATION_EXTRA,0,1,nil) end
end
function cm.cpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local cg=Duel.SelectMatchingCard(tp,cm.matfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	if cg:GetCount()==0 then return end
	Duel.ConfirmCards(1-tp,cg)
	local code=cg:GetFirst():GetOriginalCode()
	local c=e:GetHandler()
	if not c:IsOnField() or c:IsFacedown() then return end  
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(code)
		c:RegisterEffect(e1)
	 local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetValue(1)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)
end

function cm.thfilter(c)
	return c:IsSetCard(0x3342)  and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if Duel.IsExistingMatchingCard(cm.setfilter2,tp,LOCATION_ONFIELD,0,1,nil,tp) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg1=Duel.SelectMatchingCard(tp,cm.setfilter2,tp,LOCATION_ONFIELD,0,1,1,nil,tp)
		Duel.SendtoHand(tg1,nil,REASON_EFFECT)
		 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local sg=Duel.SelectMatchingCard(tp,cm.setfilter,tp,LOCATION_HAND,0,1,1,nil,tp,tg1:GetFirst())
		Duel.SSet(tp,sg)
		end
	end
end
function cm.setfilter(c,tp,mc)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)  and c:IsSSetable(true) and ( c:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE-LOCATION_FZONE)>0 or mc:IsLocation(LOCATION_SZONE-LOCATION_FZONE) )
end
function cm.setfilter2(c,tp)
	return c:IsAbleToHand() and Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_HAND,0,1,nil,tp,c) 
end










