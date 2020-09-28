--索利德机人α
function c9951510.initial_effect(c)
	 c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c9951510.ffilter,3,true)
	aux.AddContactFusionProcedure(c,c9951510.cfilter,LOCATION_HAND,0,Duel.Remove,POS_FACEUP,REASON_COST)
  --spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c9951510.splimit)
	c:RegisterEffect(e1)
--attack all
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ATTACK_ALL)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--pierce
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e3)
 --equip
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9951510,0))
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCountLimit(1)
	e3:SetTarget(c9951510.eqtg)
	e3:SetOperation(c9951510.eqop)
	c:RegisterEffect(e3)
end
function c9951510.ffilter(c,fc,sub,mg,sg)
	return c:IsFusionSetCard(0x16) and (not sg or not sg:IsExists(Card.IsFusionCode,1,c,c:GetFusionCode()))
end
function c9951510.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c9951510.cfilter(c)
	return  c:IsFusionSetCard(0x16) and c:IsType(TYPE_MONSTER)
		and c:IsAbleToRemoveAsCost()
end
function c9951510.eqfilter(c,tp)
	return not c:IsForbidden() and c:CheckUniqueOnField(tp,LOCATION_SZONE)
end
function c9951510.filter(c,tp)
	return c:IsFacedown() or c9951510.eqfilter(c,tp)
end
function c9951510.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and g:GetCount()>0
		and g:IsExists(c9951510.filter,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,1-tp,LOCATION_EXTRA)
end
function c9951510.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	Duel.ConfirmCards(tp,g)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local sg=g:FilterSelect(tp,c9951510.eqfilter,1,1,nil,tp)
	local tc=sg:GetFirst()
	if tc then
		if Duel.Equip(tp,tc,c) then
			local atk=tc:GetTextAttack()
			--Add Equip limit
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(c9951510.eqlimit)
			tc:RegisterEffect(e1)
			if atk>0 then
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_EQUIP)
				e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OWNER_RELATE)
				e2:SetCode(EFFECT_UPDATE_ATTACK)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				e2:SetValue(atk)
				tc:RegisterEffect(e2)
			end
		end
	end
	Duel.ShuffleExtra(1-tp)
end
function c9951510.eqlimit(e,c)
	return e:GetOwner()==c
end