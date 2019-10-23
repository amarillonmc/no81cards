--暗黑界的兽神 巴拉斯
function c40008824.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0x6),1)
	c:EnableReviveLimit()  
	--mat check
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(c40008824.valcheck)
	c:RegisterEffect(e0) 
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40008824,0))
	e1:SetCategory(CATEGORY_HANDES+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,40008824)
	e1:SetCondition(c40008824.thcon)
	e1:SetTarget(c40008824.thtg)
	e1:SetOperation(c40008824.thop)
	c:RegisterEffect(e1) 
	e1:SetLabelObject(e0)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(40008824,1))
	e4:SetCategory(CATEGORY_HANDES+CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,40008824)
	e4:SetTarget(c40008824.sptg)
	e4:SetOperation(c40008824.spop)
	c:RegisterEffect(e4)
end
function c40008824.valcheck(e,c)
	local g=c:GetMaterial()
	local lv=0
	local tc=g:GetFirst()
	while tc do
		if not tc:IsType(TYPE_TUNER) then
			lv=lv+tc:GetLevel()
		end
		tc=g:GetNext()
	end
	e:SetLabel(lv)
end
function c40008824.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) and e:GetLabelObject():GetLabel()~=0
end
function c40008824.thfilter(c,lv)
	return c:IsSetCard(0x6) and c:IsAbleToHand() and c:IsLevelBelow(lv)
end
function c40008824.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local lv=e:GetLabelObject():GetLabel()
	if chk==0 then return Duel.IsExistingMatchingCard(c40008824.thfilter,tp,LOCATION_DECK,0,1,nil,lv) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function c40008824.thop(e,tp,eg,ep,ev,re,r,rp)
	local lv=e:GetLabelObject():GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c40008824.thfilter,tp,LOCATION_DECK,0,1,1,nil,lv)
	if g:GetCount()>0 then
		if Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
		   Duel.ConfirmCards(1-tp,g)
			if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 then
	local cg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	local sg=cg:RandomSelect(1-tp,1)
	Duel.SendtoGrave(sg,REASON_DISCARD+REASON_EFFECT)
			end
		end
	end
end
function c40008824.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,0,0,tp,1)
end
function c40008824.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.DiscardHand(tp,nil,1,1,REASON_DISCARD+REASON_EFFECT)==0 then return end
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)
	end
end