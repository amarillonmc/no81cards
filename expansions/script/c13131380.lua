--措 手 不 稽
local m=13131380
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,13131380)
	e1:SetCondition(c13131380.tdcon)
	e1:SetTarget(c13131380.tdtg)
	e1:SetOperation(c13131380.tdop)
	c:RegisterEffect(e1)
	--RECOVER
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,13141380)
	e2:SetCondition(c13131380.reccon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c13131380.rectg)
	e2:SetOperation(c13131380.recop)
	c:RegisterEffect(e2)
	
end
function c13131380.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return eg:GetCount()==1 and tc:IsSetCard(0x1112) and tc:IsType(TYPE_MONSTER)
end
function c13131380.spfilter(c,e,tp,tc)
	return c:IsSetCard(0x1112) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(tc:GetCode()) 
end
function c13131380.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=eg:GetFirst()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c13131380.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,tc)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c13131380.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c13131380.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc)
	if tg:GetCount()>0 and Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)~=0 and
		Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) and
		Duel.SelectYesNo(tp,aux.Stringid(13131380,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
			if g:GetCount()>0 then
				Duel.HintSelection(g)
				Duel.Destroy(g,REASON_EFFECT)
			end
	end
end
function c13131380.reccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():GetControler()~=tp
end
function c13131380.recfilter(c)
	return c:IsCode(13131370) and c:IsFaceup() and c:GetAttack()>0
end
function c13131380.rectg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c13131380.recfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c13131380.recfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c13131380.recfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,g:GetFirst():GetAttack())
end
function c13131380.recop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:GetAttack()>0 then
		Duel.Recover(tp,tc:GetAttack(),REASON_EFFECT)
	end
end

