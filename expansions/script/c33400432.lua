--AST 冈峰美纪惠 
function c33400432.initial_effect(c)
	 aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x9343),aux.NonTuner(Card.IsRace,RACE_WARRIOR),1)
	 c:EnableReviveLimit()
 --Destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,33400432)
	e1:SetCondition(c33400432.descon)
	e1:SetTarget(c33400432.destg)
	e1:SetOperation(c33400432.desop)
	c:RegisterEffect(e1)
 --material
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,33400432+10000)
	e2:SetCondition(c33400432.matcon)
	e2:SetTarget(c33400432.mattg)
	e2:SetOperation(c33400432.matop)
	c:RegisterEffect(e2)
end
function c33400432.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c33400432.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x9343)
end
function c33400432.filter2(c)
	return c:IsSetCard(0x6343)   and c:IsAbleToHand()
end
function c33400432.spcfilter(c)
	return c:IsSetCard(0x341) and c:IsFaceup()
end
function c33400432.cccfilter1(c)
	return c:IsCode(33400428) and c:IsFaceup()
end
function c33400432.cccfilter2(c)
	return c:IsCode(33400425) and c:IsFaceup() and c:IsSummonType(SUMMON_TYPE_XYZ)
end
function c33400432.filter11(c)
	return c:IsFaceup() and c:IsSetCard(0x9343) and c:IsType(TYPE_MONSTER)
end
function c33400432.filter12(c)
	return c:IsFaceup() and c:IsSetCard(0x9343)and c:IsType(TYPE_SPELL)
end
function c33400432.filter13(c)
	return c:IsFaceup() and c:IsSetCard(0x9343)and c:IsType(TYPE_TRAP)
end
function c33400432.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp)  end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and Duel.IsExistingMatchingCard(c33400432.filter,tp,LOCATION_ONFIELD,0,1,nil)end
	if Duel.IsExistingMatchingCard(c33400432.filter2,tp,LOCATION_GRAVE,0,1,nil)
			and
			(Duel.IsExistingMatchingCard(c33400432.spcfilter,tp,0,LOCATION_MZONE,1,nil) and 
			   not Duel.IsExistingMatchingCard(c33400432.spcfilter,tp,LOCATION_MZONE,0,1,nil))
			or
			  (not Duel.IsExistingMatchingCard(c33400432.spcfilter,tp,LOCATION_MZONE,0,1,nil) and
			   Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) and 
				(Duel.IsExistingMatchingCard(c33400432.cccfilter1,tp,LOCATION_SZONE,0,1,nil) or 
				Duel.IsExistingMatchingCard(c33400432.cccfilter2,tp,LOCATION_MZONE,0,1,nil) 
				)
			  )
			then
				Duel.RegisterFlagEffect(tp,33400432,RESET_EVENT+0x1fe0000+RESET_CHAIN,0,0)
	end 
	local ct=0
	if  Duel.IsExistingMatchingCard(c33400432.filter11,tp,LOCATION_ONFIELD,0,1,nil) then
		ct=ct+1
	end
	if  Duel.IsExistingMatchingCard(c33400432.filter12,tp,LOCATION_ONFIELD,0,1,nil) then
		ct=ct+1
	end
	if  Duel.IsExistingMatchingCard(c33400432.filter13,tp,LOCATION_ONFIELD,0,1,nil) then
		ct=ct+1
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c33400432.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.Destroy(g,REASON_EFFECT)
	if Duel.GetFlagEffect(tp,33400432) and Duel.IsExistingMatchingCard(c33400432.filter2,tp,LOCATION_GRAVE,0,1,nil) then	  
				if Duel.SelectYesNo(tp,aux.Stringid(33400432,0)) then 
				local g=Duel.GetMatchingGroup(c33400432.filter2,tp,LOCATION_GRAVE,0,nil)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local g1=g:Select(tp,1,1,nil)
				Duel.SendtoHand(g1,tp,REASON_EFFECT)
				end 
	end 
end

function c33400432.matfilter(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_WARRIOR) and c:IsControler(tp) and c:IsCanBeEffectTarget(e)
end
function c33400432.matcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c33400432.matfilter,1,nil,e,tp)
end
function c33400432.tgfilter(c,tp,eg)
	return eg:IsContains(c) and c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsControler(tp)
end
function c33400432.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c33400432.tgfilter(chkc,tp,eg) end
	if chk==0 then return Duel.IsExistingTarget(c33400432.tgfilter,tp,LOCATION_MZONE,0,1,nil,tp,eg) end
	if eg:GetCount()==1 then
		Duel.SetTargetCard(eg)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		Duel.SelectTarget(tp,c33400432.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,tp,eg)
	end
end
function c33400432.matop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Overlay(tc,Group.FromCards(c))
	end
end
