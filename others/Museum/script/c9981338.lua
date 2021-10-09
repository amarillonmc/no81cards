--天空璋 四季异变-春
function c9981338.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	 --activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9981338,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_FZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,9981338)
	e1:SetCondition(c9981338.spcon)
	e1:SetTarget(c9981338.sptg)
	e1:SetOperation(c9981338.spop)
	c:RegisterEffect(e1)
	--change pos
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9981338,1))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c9981338.postg)
	e2:SetOperation(c9981338.posop)
	c:RegisterEffect(e2)
	--cannot be target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetValue(c9981338.atlimit)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e5:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e5:SetRange(LOCATION_FZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetTarget(c9981338.tglimit)
	e5:SetValue(aux.tgoval)
	c:RegisterEffect(e5)
end
function c9981338.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c9981338.spfilter(c,e,tp)
	return c:IsSetCard(0x6bd1) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9981338.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and chkc:IsFaceup() and chkc~=e:GetHandler() end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_ONFIELD,0,1,e:GetHandler())
		and Duel.IsExistingMatchingCard(c9981338.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c9981338.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c9981338.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c9981338.filter(c)
	return c:IsSetCard(0x6bd1) and c:IsFacedown() and c:IsDefensePos()
end
function c9981338.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9981338.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,0,0)
end
function c9981338.posop(e,tp,eg,ep,ev,re,r,rp,chk)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectMatchingCard(tp,c9981338.filter,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		local pos=Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEUP_DEFENSE)
		Duel.ChangePosition(tc,pos)
	end
end
function c9981338.filter2(c,atk)
	return c:IsFaceup() and c:IsSetCard(0x6bd1) and c:GetAttack()>atk
end
function c9981338.atlimit(e,c)
	return c:IsFaceup() and c:IsSetCard(0x6bd1) and Duel.IsExistingMatchingCard(c9981338.filter2,c:GetControler(),LOCATION_MZONE,0,1,nil,c:GetAttack())
end
function c9981338.tglimit(e,c)
	return c:IsSetCard(0x6bd1) 
		and Duel.IsExistingMatchingCard(c9981338.filter2,c:GetControler(),LOCATION_MZONE,0,1,nil,c:GetAttack())
end